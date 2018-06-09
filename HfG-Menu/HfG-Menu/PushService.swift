//
//  PushService.swift
//  HfG-Menu
//
//  Created by Sam Eckert on 09.06.18.
//  Copyright © 2018 sam0711er. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Intents
import IntentsUI
import CoreGraphics

class PushService{
    let center = UNUserNotificationCenter.current()
    
    
    func scheduleNotification (){
        
        
        writeFileToFileSystem(image: convertPDFToImage(URLAsString: constructCurrentMenuURL()), completion: { success in
            print("Sucess so far")
        })
        
        let content = UNMutableNotificationContent()
        content.title = "HfG Menu"
        content.body = "Enjoy your meal!"
        content.categoryIdentifier = "EnterTextNotificationCategory"
        
        
        
        let attachement = try? UNNotificationAttachment(identifier: "attachment", url: constructImageFromFileSystemURL(), options: nil)
        content.attachments = [attachement!]
        
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let identifier = "EnterTextNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // let inputAction = UNTextInputNotificationAction.init(identifier: "Enter Text", title: "Enter Text on your amigOS", options: [], textInputButtonTitle: "Submit", textInputPlaceholder: "Type here…")
        
        let category = UNNotificationCategory(identifier: "EnterTextNotificationCategory", actions: [/*inputAction*/], intentIdentifiers: [], options: [])
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })
        center.setNotificationCategories([category])
    }
    
    
    
    func constructCurrentMenuURL() -> String{
        let currentDate = Calendar.current.component(.weekOfYear, from: Date())
        
        let stringConstructor = "https://studierendenwerk-ulm.de/wp-content/uploads/speiseplaene/HFG\(currentDate).pdf"
        
        
        print("contentURL is \(stringConstructor)")
        
        return stringConstructor
    }
    
    func constructImageFromFileSystemURL() -> URL{
        do{
            let fileManager = FileManager.default
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("menu.png")
            
            return fileURL
        } catch {
            return URL(string: "")!
            print(error)
        }
    }
    
    func convertPDFToImage(URLAsString:String) -> UIImage {
        
        /* let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
         let filePath = documentsURL.appendingPathComponent("pathLocation").path*/
        
        // let filePath = URL(string: URLAsString)
        
        do {
            let pdfdata = try NSData(contentsOf: URL(string: URLAsString)! )
            //  let pdfdata = try NSData(contentsOfFile: URLAsString, options: NSData.ReadingOptions.init(rawValue: 0))
            
            let pdfData = pdfdata as! CFData
            let provider:CGDataProvider = CGDataProvider(data: pdfData)!
            let pdfDoc:CGPDFDocument = CGPDFDocument(provider)!
            let pdfPage:CGPDFPage = pdfDoc.page(at: 1)!
            var pageRect:CGRect = pdfPage.getBoxRect(.mediaBox)
            pageRect.size = CGSize(width:pageRect.size.width, height:pageRect.size.height)
            
            print("\(pageRect.width) by \(pageRect.height)")
            
            UIGraphicsBeginImageContext(pageRect.size)
            let context:CGContext = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.translateBy(x: 0.0, y: pageRect.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
            context.drawPDFPage(pdfPage)
            context.restoreGState()
            let pdfImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            print("Image converted")
            return pdfImage
        }
        catch {
            return UIImage()
        }
    }
    
    func writeFileToFileSystem(image: UIImage, completion: (Bool) -> Void){
        print("writeFileToFileSystem")
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent("menu.png")
            print("do runs")
            
            completion(true)

            
            if let imageData = UIImagePNGRepresentation(image) {
                try imageData.write(to: fileURL)
                print("Completion")
                completion(true)
            }else{
                print("No Image Data")
            }
        } catch {
            print(error)
        }
    }
  
}
