//
//  IntentHandler.swift
//  Menu Intent
//
//  Created by Sam Eckert on 09.06.18.
//  Copyright © 2018 sam0711er. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    let pushService = PushService()
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        
        pushService.scheduleNotification()
        
        return self
    }
    
}
