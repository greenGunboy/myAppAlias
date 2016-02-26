//
//  startViewController.swift
//  myApp
//
//  Created by Tsubasa Takahashi on 2016/02/16.
//  Copyright © 2016年 Tsubasa Takahashi. All rights reserved.
//

import UIKit

class startViewController: UIViewController {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onewordLabel: UILabel!
    @IBOutlet weak var twowordLabel: UILabel!
    @IBOutlet weak var threewordLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var doneBtn: UIButton!
    
    var userIdea:[NSDictionary] = []
    
//    appdelegateにあるデータを取り出す
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var timerCount = 60 * 3
    var timer = NSTimer()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        var filePath = NSBundle.mainBundle().pathForResource("wordsList", ofType: "plist")
        var Objects = NSDictionary(contentsOfFile: filePath!)
        var word = Objects!["words"]
        
        var oneword = Int(arc4random()) % (word!.count)!
        var twoword = Int(arc4random()) % (word!.count)!
        var threeword = Int(arc4random()) % (word!.count)!
        
        self.onewordLabel.text = (Objects!["words"]!["\(oneword)"]) as! String
        self.twowordLabel.text = (Objects!["words"]!["\(twoword)"]) as! String
        self.threewordLabel.text = (Objects!["words"]!["\(threeword)"]) as! String
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        タイマーの設置
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("Counting"), userInfo: nil, repeats: true)
//        ユーザーがタイマーセットをした時に起動
        if appDelegate.startFlg {
            timerCount = 60 * appDelegate.startMin + appDelegate.startSec
            
            appDelegate.startFlg = false
        }
        
    }
    


    
    func Counting(){
//        タイムフォーマットの指定(00:00)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "mm:ss"
//        １ずつ引いていく
        timerCount -= 1
//       分、秒に変換
        let mm = timerCount / 60
        let ss = timerCount % 60
        let mm_str = NSString(format: "%02d", mm)
        let ss_str = NSString(format: "%02d", ss)
        
        timeLabel.text = "\(mm_str):\(ss_str)"
//        カウントが０になった場合の処理
        if timerCount == 0 {
//            アラートメッセージを表示
        let alertController = UIAlertController(title: "Time Up", message: "Idea Listへ保存しました", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: /* tableView or ViewControllerへ遷移させる */nil))
            presentViewController(alertController, animated: true, completion: nil)
//            タイマーを止める
            timer.invalidate()
            
        }
    }
    
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func completeBtn(sender: UIButton) {
        
//        udから取り出す
        var ud = NSUserDefaults.standardUserDefaults()
        userIdea = ud.objectForKey("ideaList")! as! [NSDictionary]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var now = NSDate()
        
        var time : String = dateFormatter.stringFromDate(now)
        var one : String = onewordLabel.text!
        var two : String = twowordLabel.text!
        var three : String = threewordLabel.text!
        var memo : String = memoTextView.text!
        
        var ideaInfo: NSDictionary = ["time":time,"one":one,"two":two,"three":three,"memo":memo]
        
        userIdea.append(ideaInfo)
        
        ud.setObject(userIdea, forKey: "ideaList")
    
        }
    
    
    @IBAction func resetBtn(sender: UIButton) {
       
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var tableVC = segue.destinationViewController as! tableViewController
        tableVC.listArray = userIdea
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
