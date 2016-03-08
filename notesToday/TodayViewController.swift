//
//  TodayViewController.swift
//  notesToday
//
//  Created by Taarak on 11/8/15.
//  Copyright © 2015 Adithya Bharadwaj. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding  {
    
    let tapRec = UITapGestureRecognizer()
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        nameLabel.backgroundColor = UIColor.clearColor()
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
        
        tapRec.addTarget(self, action: "launchApp")
        nameLabel.addGestureRecognizer(tapRec)
        nameLabel.userInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func updateTime(){
        
        nameLabel.text = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
    }
    
    func launchApp(){
        let text = "note://recent"
        let url: NSURL = NSURL(string: text)!
        extensionContext?.openURL(url, completionHandler: nil)
        
        
    }
    
}
