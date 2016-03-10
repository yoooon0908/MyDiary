//
//  SecondViewController.swift
//  EnglishDiary
//
//  Created by 三浦宏予 on 2016/02/20.
//  Copyright © 2016年 Hiroyo Miura. All rights reserved.
//
import UIKit
import CoreData

class SecondViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var secSelect = -1
    var englist:[NSDictionary] = []
    
    //DBの名前
    let ENTITY_NAME = "Data"
    //txt1
    let ITEM_NAME1 = "content"
    //txt2
    let ITEM_NAME2 = "title"
    //txt3
    let ITEM_NAME3 = "date"
    //txt4
    let ITEM_NAME4 = "image"
    
    var assetURL = ""
    
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var secDate: UITextField!
    @IBOutlet weak var secTitle: UITextField!
    @IBOutlet weak var secImageView: UIImageView!
    @IBOutlet weak var secContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.edit = ""
        readData()
        
        //        //ファイルの場所を探せる↓
        //#if DEBUG
//                    print("----------------------------------");
//                    print("[DEBUG]");
//                    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//                    print(documentsPath)
//                    print("----------------------------------");
        //        //#endif

       
    }
    
    
    
    // データ登録/更新
    func writeData() -> Bool{
        var ret = false
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let results: Array = try context.executeFetchRequest(request)
            
            let df = NSDateFormatter()
            df.dateFormat = "yyyy/MM/dd"
            
                            // 見つからなかったら新規登録
                let entity: NSEntityDescription! = NSEntityDescription.entityForName(ENTITY_NAME, inManagedObjectContext: context)
                let obj = Data(entity: entity, insertIntoManagedObjectContext: context)
                
                obj.setValue(secContent.text, forKey: "content")
                obj.setValue(secTitle.text, forKey: "title")
                obj.setValue(df.dateFromString(secDate.text!), forKey: "date")
                obj.setValue(assetURL, forKey: "image")
                
                appDelegate.saveContext()
            
                print("INSERT CONTENT: \(secContent.text)")
                print("INSERT TITLE: \(secTitle.text)")
                print("INSERT DATE: \(secDate.text)")
                print("INSERT IMAGE: \(secImageView.image)")
                
                do {
                    try context.save()
                } catch let error as NSError {
                    // エラー処理
                    print("INSERT ERROR:\(error.localizedDescription)")
                }
                ret = true
            
        } catch let error as NSError {
            // エラー処理
            print("FETCH ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
    // データ読み込み
    func readData() -> String{
        var ret = ""
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                // 見つかったら読み込み
                let obj = results[0] as! NSManagedObject
                let txt1 = obj.valueForKey(ITEM_NAME1) as! String
                let txt2 = obj.valueForKey(ITEM_NAME2) as! String
                let txt3 = obj.valueForKey(ITEM_NAME3) as! NSDate
                let txt4 = obj.valueForKey(ITEM_NAME4) as! String
                
                print("READ CONTENT:\(txt1)")
                print("READ TITLE:\(txt2)")
                print("READ DATE:\(txt3)")
                print("READ IMAGE:\(txt4)")
                
            }
        } catch let error as NSError {
            // エラー処理
            print("READ ERROR:\(error.localizedDescription)")
        }
        return ret
    }
    
   
    
    override func viewWillAppear(animated: Bool) {
         var langEn = appDelegate.langEn
        secContent.text = appDelegate.texttmp + langEn
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //★の内容をtextfildに表示させる
    
    @IBAction func tapStar(sender: UIButton) {
        appDelegate.texttmp = secContent.text
        
    }
    
    
    @IBAction func tapSave(sender: UIButton) {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
      

        //アラートを出す
        if df.dateFromString(secDate.text!) == ""  {
            let alertController = UIAlertController(title: "Please!!", message: "すべての項目を入力してください。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if secImageView.image == "" {
            let alertController = UIAlertController(title: "Please!!", message: "すべての項目を入力してください。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if secTitle.text == "" {
            let alertController = UIAlertController(title: "Please!!", message: "すべての項目を入力してください。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if secContent.text == "" {
            let alertController = UIAlertController(title: "Please!!", message: "すべての項目を入力してください。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else{
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("welcome3")
            self.presentViewController(targetView as! UIViewController, animated: true, completion: nil)
        }

          writeData()
    }
    
    @IBAction func tapPhoto(sender: UIButton) {
        
        // フォトライブラリが使用可能か？
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            // フォトライブラリの選択画面を表示
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    // 写真選択時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 選択した画像を取得
        if info[UIImagePickerControllerOriginalImage] != nil {
            if let photo:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                
                // ImageViewにその画像を設定
                secImageView.image = photo
                assetURL = (info[UIImagePickerControllerReferenceURL]?.description)!
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

}

