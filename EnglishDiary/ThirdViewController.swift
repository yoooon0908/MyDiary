//
//  ThirdViewController.swift
//  EnglishDiary
//
//  Created by 三浦宏予 on 2016/02/20.
//  Copyright © 2016年 Hiroyo Miura. All rights reserved.
//


import UIKit
import Social
import CoreData
import Photos

class ThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
    @IBOutlet weak var thDate: UITextField!
    @IBOutlet weak var thTitle: UITextField!
    @IBOutlet weak var thImage: UIImageView!
    @IBOutlet weak var thContent: UITextView!
    @IBOutlet weak var FBBtn: UIButton!
  
    
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

    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        
        
        appDelegate.edit = "edit"
        readData()
        
        //        //ファイルの場所を探せる↓
        //#if DEBUG
//        print("----------------------------------");
//        print("[DEBUG]");
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//        print(documentsPath)
//        print("----------------------------------");
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
            
            if (results.count > 0 ) {
                // 検索して見つかったらアップデートする
                let obj = results[0] as! NSManagedObject
                
                let txt1 = obj.valueForKey(ITEM_NAME1) as! String
                let txt2 = obj.valueForKey(ITEM_NAME2) as! String
                let txt3 = obj.valueForKey(ITEM_NAME3) as! NSDate
                let txt4 = obj.valueForKey(ITEM_NAME4) as! String
                
                obj.setValue(thContent.text, forKey: "content")
                obj.setValue(thTitle.text, forKey: "title")
                obj.setValue(df.dateFromString(thDate.text!), forKey: "date")
                obj.setValue(assetURL, forKey: "image")
                
                print("UPDATE CONTENT: \(txt1) TO \(thContent.text)")
                print("UPDATE TITLE: \(txt2) TO \(thTitle.text)")
                print("UPDATE DATE: \(txt3) TO \(thDate.text)")
                print("UPDATE IMAGE: \(txt4) TO \(thImage.image)")
                
                appDelegate.saveContext()
                ret = true
                
            }else{
                // 見つからなかったら新規登録
                let entity: NSEntityDescription! = NSEntityDescription.entityForName(ENTITY_NAME, inManagedObjectContext: context)
                let obj = Data(entity: entity, insertIntoManagedObjectContext: context)
                
                obj.setValue(thContent.text, forKey: "content")
                obj.setValue(thTitle.text, forKey: "title")
                obj.setValue(df.dateFromString(thDate.text!), forKey: "date")
                obj.setValue(assetURL, forKey: "image")
                
                print("INSERT CONTENT: \(thContent.text)")
                print("INSERT TITLE: \(thTitle.text)")
                print("INSERT DATE: \(thDate.text)")
                print("INSERT IMAGE: \(thImage.image)")
                
                do {
                    try context.save()
                } catch let error as NSError {
                    // エラー処理
                    print("INSERT ERROR:\(error.localizedDescription)")
                }
                ret = true
            }
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
        thContent.text = appDelegate.texttmp + langEn
        
        
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        
        if (myDefault.objectForKey("NAME") != nil){
            var myStr:String = myDefault.objectForKey("NAME")! as! String
            //assetURLの読み込み
            //var image = assetURL
            
            
            //let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs(fileURLWithPath: NSURL(assetURL), options: nil)
            
            var assetURL = NSURL(string: myStr as! String)!
            
            
                    
                    let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([assetURL], options: nil)
                    let asset: PHAsset = fetchResult.firstObject as! PHAsset
                    let manager: PHImageManager = PHImageManager()
                    manager.requestImageForAsset(asset,
                        targetSize: CGSizeMake(100, 100),
                        contentMode: .AspectFill,
                        options: nil) { (image, info) -> Void in
                            
                            self.thImage.image = image
                    }
            
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapFBBtn(sender: UIButton) {
        var facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookVC.setInitialText(thContent.text)
        //facebookVC.addImage(UIImage(named: "thImage"))
        
        presentViewController(facebookVC, animated: true, completion: nil)
    }
    
    @IBAction func tapStar(sender: UIButton) {
        appDelegate.texttmp = thContent.text
        
    }
    
    @IBAction func tapImage(sender: UIButton) {
        
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
                thImage.image = photo
                assetURL = (info[UIImagePickerControllerReferenceURL]?.description)!
                
                //NSUserDefaultsのインスタンスを生成
                let defaults = NSUserDefaults.standardUserDefaults()
                
                //"NAME"というキーで配列namesを保存
                defaults.setObject(assetURL, forKey:"NAME")
                
                // シンクロを入れないとうまく動作しないときがあります
                defaults.synchronize()

            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
        
        
        
    }
    
    @IBAction func tapEdit(sender: UIButton) {
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        
        //アラートを出す
        if df.dateFromString(thDate.text!) == ""  {
            let alertController = UIAlertController(title: "Please!!", message: "すべての項目を入力してください。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if thImage.image == "" {
            let alertController = UIAlertController(title: "Please!!", message: "すべての項目を入力してください。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if thTitle.text == "" {
            let alertController = UIAlertController(title: "Please!!", message: "すべての項目を入力してください。", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if thContent.text == "" {
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
   
    
}
