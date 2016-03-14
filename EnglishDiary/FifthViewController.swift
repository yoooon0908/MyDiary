//
//  FifthViewController.swift
//  EnglishDiary
//
//  Created by 三浦宏予 on 2016/02/20.
//  Copyright © 2016年 Hiroyo Miura. All rights reserved.
//

import UIKit

class FifthViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var fifTableView: UITableView!
    
    //気分をリストで表示できるようにする
    //辞書＋辞書
    
    var fifSelect = -1
    var englist:[NSDictionary] = []

    var langEn = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    
    //行数
    func tableView(tabeleView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return englist.count
    }
    
    //表示するセルの中身2
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell{
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "myCell2")
        
        
//        cell.textLabel!.text = "\(englist[indexPath.row]["En"])" + "\(englist[indexPath.row]["Ja"])"
         cell.textLabel!.text = "\(englist[indexPath.row]["En"] as! String)"
        
        
        //文字色
        cell.textLabel!.textColor = UIColor.whiteColor()
        //ボールド
        cell.textLabel!.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
//        //文字大きさ
//        cell.textLabel!.font = UIFont.systemFontOfSize(15)
        // 背景色
        cell.backgroundColor = UIColor.clearColor()
        // 選択された時の背景色
        var cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor =  UIColor(red: 1.0, green: 0, blue: 1.0, alpha: 0.2)
        cell.selectedBackgroundView = cellSelectedBgView
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        //json.txtファイルを読み込んで
        
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
            var path = NSBundle.mainBundle().pathForResource("study", ofType: "txt")
            var jsondata = NSData(contentsOfFile: path!)
            let jsonDictionaray = (try! NSJSONSerialization.JSONObjectWithData(jsondata!, options: [])) as! NSArray
        
            for data in jsonDictionaray {
                var d1 = data["En"] as! String
                
                self.englist.append(data as! NSDictionary)
                print(d1)
               
            }
        }else if fifSelect == 2 {
            var path = NSBundle.mainBundle().pathForResource("trip", ofType: "txt")
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
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier("welcomeedit")
            self.presentViewController(targetView as! UIViewController, animated: true, completion: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
