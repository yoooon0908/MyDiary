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


class FirstViewController: UIViewController {

    
   
    
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var firstDate: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
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
                

                    //データを一覧表示させる
//                    firstTitle.text = txt2
//                    firstDate.text = txt3
//                    firstImage.image = txt4
                


                
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
   
    
    
    
    //広告
    //バナーに広告が表示された時
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.myiAd.hidden = false
    }
    
    //バナーがクリックされた時
    func bannerViewACtionShouldBegin(banner:ADBannerView!,wullLeaveApplication willLeave: Bool) ->Bool{
        return willLeave
    }
    
    //広告表示にエラーが発生した場合
    func bannerView(banner:ADBannerView!, didFailToReceiveAdWithError error:NSError!) {
        self.myiAd.hidden = true
    }

    
    
}
