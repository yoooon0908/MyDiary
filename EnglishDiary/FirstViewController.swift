//
//  FirstViewController.swift
//  EnglishDiary
//
//  Created by 三浦宏予 on 2016/02/20.
//  Copyright © 2016年 Hiroyo Miura. All rights reserved.
//

import iAd
import UIKit
import CoreData
import Photos


class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
   var firstIndex = -1
    
    var diaryList:NSArray = []
    

    
  
    @IBOutlet weak var myiAd: ADBannerView!
    
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
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //広告
        super.viewDidLoad()
        self.canDisplayBannerAds = true
        self.myiAd.hidden = true
        
        readData()
        
    }
    
    
    func readData() -> String{
        var ret = ""
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ENTITY_NAME)
        request.returnsObjectsAsFaults = false
        
        do {
            
            
            let results : Array = try context.executeFetchRequest(request)
            if (results.count > 0 ) {
                
                
                
                  diaryList = results
                
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    //表示するセル
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        

        let obj = diaryList[indexPath.row] as! NSManagedObject
      
        var cell = tableView.dequeueReusableCellWithIdentifier("myCell3")! as UITableViewCell
        
        let df = NSDateFormatter()
            df.dateFormat = "yyyy/MM/dd"
        
        
        //データを送る
        cell.tag = indexPath.row
        
        //改行
        cell.textLabel!.numberOfLines  = 0
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping


        // 選択された時の背景色
        var cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor =  UIColor(red: 0, green: 1, blue: 0.5, alpha: 0.2)
        cell.selectedBackgroundView = cellSelectedBgView
        
        
         //tag1 写真
        var urlstring:String = obj.valueForKey(ITEM_NAME4) as! String
        var myImage = NSURL(string: urlstring)!
        
        if (urlstring != "") {
            
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([myImage], options: nil)
            let asset: PHAsset = fetchResult.firstObject as! PHAsset
            let manager: PHImageManager = PHImageManager()
            manager.requestImageForAsset(asset,
                targetSize: CGSizeMake(100, 100),
                contentMode: .AspectFill,
                options: nil) { (image, info) -> Void in
                    
                var firstImage = cell.viewWithTag(1) as! UIImageView
                    firstImage.image = image
            }
            
        }
        
        //tag2 Date
        var firstDate = cell.viewWithTag(2) as! UILabel
            df.dateFromString(firstDate.text!)
            //firstDate.text = obj.valueForKey(ITEM_NAME3) as! String
            firstDate.text = df.stringFromDate(obj.valueForKey(ITEM_NAME3) as! NSDate)

        //tag3 Title
        var firstTitle = cell.viewWithTag(3) as! UILabel
            firstTitle.text = obj.valueForKey(ITEM_NAME2) as! String
        
        
        
        return cell
    }
    
     // 選択された時に行う処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)行目を選択")
        firstIndex = indexPath.row
        performSegueWithIdentifier("show1",sender: nil)

    }
    
    // Segueで画面遷移する時
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if ((sender?.tag) != nil) {
//            let thVC = segue.destinationViewController as! ThirdViewController
//                thVC.thirdIndex = self.firstIndex[(sender?.tag)!]
//            
//        }
//
//    }


   

    
//       //広告
//    //バナーに広告が表示された時
//    func bannerViewDidLoadAd(banner: ADBannerView!) {
//        self.myiAd.hidden = false
//    }
//    
//    //バナーがクリックされた時
//    func bannerViewACtionShouldBegin(banner:ADBannerView!,wullLeaveApplication willLeave: Bool) ->Bool{
//        return willLeave
//    }
//    
//    //広告表示にエラーが発生した場合
//    func bannerView(banner:ADBannerView!, didFailToReceiveAdWithError error:NSError!) {
//        self.myiAd.hidden = true
//    }
//
    
    
}
