//
//  FifthViewController.swift
//  EnglishDiary
//
//  Created by 三浦宏予 on 2016/02/20.
//  Copyright © 2016年 Hiroyo Miura. All rights reserved.
//

import iAd
import UIKit

class FifthViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    
    @IBOutlet var myiAd: ADBannerView!
    @IBOutlet weak var fifTableView: UITableView!
    
    var thirdIndex = -1
    var fifSelect = -1
    var englist:[NSDictionary] = []
    var langEn = -1
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //広告
        super.viewDidLoad()
        self.canDisplayBannerAds = true
        self.myiAd.hidden = true
    
        
    }
    
    
    //行数
    func tableView(tabeleView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return englist.count
    }
    
    //表示するセルの中身
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell{
        
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell2")

         cell.textLabel!.text = "\(englist[indexPath.row]["En"] as! String)"
        
        //改行
        cell.textLabel!.numberOfLines  = 0
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
        //文字色
        cell.textLabel!.textColor = UIColor.whiteColor()
        //ボールド
        cell.textLabel!.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        // 背景色
        cell.backgroundColor = UIColor.clearColor()
        // 選択された時の背景色
        var cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor =  UIColor(red: 0, green: 1, blue: 0.5, alpha: 0.2)
        cell.selectedBackgroundView = cellSelectedBgView
        
        return cell
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        //ファイルを読み込む
        if fifSelect == 0 {
            var path = NSBundle.mainBundle().pathForResource("life", ofType: "txt")
            var jsondata = NSData(contentsOfFile: path!)
            let jsonDictionaray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
           
            for data in jsonDictionaray {
                var d1 = data["En"] as! String
                self.englist.append(data as! NSDictionary)
                print(d1)
                
            }
        }else if fifSelect == 1 {
            var path = NSBundle.mainBundle().pathForResource("weather", ofType: "txt")
            var jsondata = NSData(contentsOfFile: path!)
            let jsonDictionaray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
        
            for data in jsonDictionaray {
                var d1 = data["En"] as! String
                self.englist.append(data as! NSDictionary)
                print(d1)
               
            }
        }else if fifSelect == 2 {
            var path = NSBundle.mainBundle().pathForResource("dream", ofType: "txt")
            var jsondata = NSData(contentsOfFile: path!)
            let jsonDictionaray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
            
            for data in jsonDictionaray {
                var d1 = data["En"] as! String
                self.englist.append(data as! NSDictionary)
                print(d1)
            }
        }else if fifSelect == 3 {
            var path = NSBundle.mainBundle().pathForResource("housework", ofType: "txt")
            var jsondata = NSData(contentsOfFile: path!)
            let jsonDictionaray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
            
            for data in jsonDictionaray {
                var d1 = data["En"] as! String
                self.englist.append(data as! NSDictionary)
                print(d1)
            }
        }else if fifSelect == 4 {
            var path = NSBundle.mainBundle().pathForResource("feeling", ofType: "txt")
            var jsondata = NSData(contentsOfFile: path!)
            let jsonDictionaray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
            
            for data in jsonDictionaray {
                var d1 = data["En"] as! String
                
                self.englist.append(data as! NSDictionary)
                print(d1)
            }
        }
    }
    
    
    // 選択された時に行う処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        appDelegate.langEn = englist[indexPath.row]["En"] as! String
        if appDelegate.edit == "" {
            //データを送る
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("welcome")
            self.presentViewController(targetView as! UIViewController, animated: true, completion: nil)
            
        }else{
            
            var targetView: ThirdViewController = self.storyboard!.instantiateViewControllerWithIdentifier("welcomeedit") as! ThirdViewController
            
            targetView.thirdIndex = thirdIndex
            
            self.presentViewController(targetView as! UIViewController, animated: true, completion: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    //広告
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
