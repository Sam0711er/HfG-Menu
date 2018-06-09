//
//  ViewController.swift
//  HfG-Menu
//
//  Created by Sam Eckert on 09.06.18.
//  Copyright © 2018 sam0711er. All rights reserved.
//

import UIKit
import UserNotifications
import Intents
import IntentsUI

class ViewController: UIViewController {

    @IBOutlet var scheduleLocalPushButton: UIButton!
    @IBOutlet var previewImageView: UIImageView!
    
    let center = UNUserNotificationCenter.current()
    let pushService = PushService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func scheduleLocalPushAction(_ sender: Any) {
        startUserActivity()
        
        print("Schedule Local Push")
        
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }else{
                self.pushService.scheduleNotification()
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }else{
                self.pushService.scheduleNotification()
                print("Noti on")
            }
        }

    }
    
    
    

    func startUserActivity() {
        let activity = NSUserActivity(activityType: "com.sam0711er.HfG-Menu")
        if #available(iOS 12.0, *) {
           // activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        }
        activity.isEligibleForSearch = true
        activity.title = "Menu"
        self.userActivity = activity;
        self.userActivity?.becomeCurrent()
        
        
        let intent = INIntent()
        if #available(iOS 12.0, *) {
           // intent.suggestedInvocationPhrase = "Show me the menu"
        } else {
            // Fallback on earlier versions
        }
        
        let inIntentResponse = INIntentResponse()
        
        let inInteraction = INInteraction(intent: intent, response: inIntentResponse)
        inInteraction.donate(completion: {error in
            
        })
        
    }
    
    // 2.
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
    }
    
    
}

