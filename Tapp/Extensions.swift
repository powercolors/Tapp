//
//  Extensions.swift
//  ADB
//
//  Created by s on 2017-10-02.
//  Copyright © 2017 Hudson Graeme. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import AlamofireImage
import SwiftyJSON


extension NSView {
    func slideInFromLeft(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer?.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    func slideInFromRight(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromRightTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromRightTransition.type = kCATransitionPush
        slideInFromRightTransition.subtype = kCATransitionFromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer?.add(slideInFromRightTransition, forKey: "slideInFromRightTransition")
    }
    
    func slideInFromTop(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromTopTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromTopTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromTopTransition.type = kCATransitionPush
        slideInFromTopTransition.subtype = kCATransitionFromTop
        slideInFromTopTransition.duration = duration
        slideInFromTopTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromTopTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer?.add(slideInFromTopTransition, forKey: "slideInFromTopTransition")
    }
    
    func slideInFromBottom(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromBottomTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromBottomTransition.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        slideInFromBottomTransition.type = kCATransitionPush
        slideInFromBottomTransition.subtype = kCATransitionFromBottom
        slideInFromBottomTransition.duration = duration
        slideInFromBottomTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromBottomTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer?.add(slideInFromBottomTransition, forKey: "slideInFromBottomTransition")
    }
    func fadeIn(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let fadeIn = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            fadeIn.delegate = delegate as? CAAnimationDelegate
        }
        
        // Customize the animation's properties
        fadeIn.type = kCATransitionFade
        fadeIn.subtype = kCATransitionReveal
        fadeIn.duration = duration
        fadeIn.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        fadeIn.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer?.add(fadeIn, forKey: "fadeIn")
    }

    
    
    
    
}

extension FileManager {
    class func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    class func desktopDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

extension JSON {
    static func checkNull(_ input: JSON) -> Bool{
        if(input == JSON.null) {
            return false
        } else {
            return true
        }
}
}
extension start {
     func Alert(_ title:String,_ text:String,_ style:NSAlertStyle,_ buttonCount:Int, _ buttonNames:NSArray) -> Int {
        var count = buttonCount
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = style
        while count >= 1 {
            let name = buttonNames[count - 1] as! String
            alert.addButton(withTitle: name)
            count = count - 1
        }
        let stackViewer = NSStackView()
        
        alert.accessoryView = stackViewer
        
        let response: NSApplication.ModalResponse = alert.runModal()
        return response
    }
}

extension Gigawatt {
    func Alert(_ title:String,_ text:String,_ style:NSAlertStyle,_ buttonCount:Int, _ buttonNames:NSArray) -> Int {
        var count = buttonCount
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = style
        while count >= 1 {
            let name = buttonNames[count - 1] as! String
            alert.addButton(withTitle: name)
            count = count - 1
        }
        
        let stackViewer = NSStackView()
        
        alert.accessoryView = stackViewer
        
        let response: NSApplication.ModalResponse = alert.runModal()
        return response
    }
}

@available(OSX 10.12.2, *)
extension Plaid {
    func Alert(_ title:String,_ text:String,_ style:NSAlertStyle,_ buttonCount:Int, _ buttonNames:NSArray) -> Int {
        var count = buttonCount
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = style
        while count >= 1 {
            let name = buttonNames[count - 1] as! String
            alert.addButton(withTitle: name)
            count = count - 1
        }
        
        let stackViewer = NSStackView()
        
        alert.accessoryView = stackViewer
        
        let response: NSApplication.ModalResponse = alert.runModal()
        return response
    }
}
extension Subzero {
    func Alert(_ title:String,_ text:String,_ style:NSAlertStyle,_ buttonCount:Int, _ buttonNames:NSArray) -> Int {
        var count = buttonCount
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = text
        alert.alertStyle = style
        while count >= 1 {
            let name = buttonNames[count - 1] as! String
            alert.addButton(withTitle: name)
            count = count - 1
        }
        
        let stackViewer = NSStackView()
        
        alert.accessoryView = stackViewer
        
        let response: NSApplication.ModalResponse = alert.runModal()
        return response
    }
}
extension NSViewController {
    class func WakeUp(ID VehicleID: Int) {
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(VehicleID)/wake_up")
        _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in

        }
    }
}

extension NSMutableAttributedString {

}

extension NSAttributedString {
    func setColorForText(attrStr:NSMutableAttributedString, _ textToFind: String, with color: NSColor) {
        let inputLength = attrStr.string.count
        let searchString = textToFind
        let searchLength = searchString.count
        var range = NSRange(location: 0, length: attrStr.length)
        while (range.location != NSNotFound) {
            range = (attrStr.string as NSString).range(of: searchString, options: [], range: range)
            if (range.location != NSNotFound) {
                attrStr.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: range.location, length: searchLength))
                range = NSRange(location: range.location + range.length, length: inputLength - (range.location + range.length))
            }
        }
    }
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString
    {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
}
