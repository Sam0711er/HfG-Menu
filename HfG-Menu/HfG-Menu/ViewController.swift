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
import Lottie


class ViewController: UIViewController {

    let animationView = LOTAnimationView(name: "Success")

    
    @IBOutlet var timeAmountLabel: UILabel!
    @IBOutlet var scheduleLocalPushButton: UIButton!
    @IBOutlet var previewImageView: UIImageView!
    
    let center = UNUserNotificationCenter.current()
    let pushService = PushService()
    
    @IBOutlet var stepperInstance: UIStepper!
    @IBAction func stepper(_ sender: Any) {
        UserDefaults.standard.set(stepperInstance.value, forKey: "delay")
        timeAmountLabel.text = String(UserDefaults.standard.double(forKey: "delay")) + " s"

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = .red
        
        timeAmountLabel.text = String(UserDefaults.standard.double(forKey: "delay")) + " s"
        stepperInstance.minimumValue = 1
        
        stepperInstance.stepValue = 1

          animationView.center = CGPoint(x: view.center.x, y: view.center.y-100)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func scheduleLocalPushAction(_ sender: Any) {
        showThanks()
        
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
    
    func showThanks(){
        animationView.center = CGPoint(x: view.center.x, y: view.center.y+200)
        animationView.contentScaleFactor = 2
        self.view.addSubview(animationView)
        animationView.play{ (finished) in
            // Do Something
        }
    }
    

    func startUserActivity() {
        
        let activity = NSUserActivity(activityType: "com.sam0711er.HfG-Menu")
        if #available(iOS 12.0, *) {
            //activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        }
        activity.isEligibleForSearch = true
        activity.title = "Show me the Menu"
        self.userActivity = activity;
        self.userActivity?.becomeCurrent()
        
        
        INPreferences.requestSiriAuthorization { (status) in
            print("Status: \(status)")
        }
        
        
        let intent = INIntent()
        
        if #available(iOS 12.0, *) {
            //intent.suggestedInvocationPhrase = "Show me the menu"
        } else {
            // Fallback on earlier versions
        }
        
        let inIntentResponse = INIntentResponse()
        
        print("Registering inInteraction")
        let inInteraction = INInteraction(intent: intent, response: inIntentResponse)
        
        inInteraction.donate(completion: { item in
            print("Item is \(item)")
        })
        
    }
    
    // 2.
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
    }
    
    
}

