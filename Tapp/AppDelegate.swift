//
//  AppDelegate.swift
//  Tapp
//
//  Created by Hudson Graeme on 2017-01-06.
//  

import Cocoa
import Locksmith
import Firebase

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
 
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
 
    
        public func cData() {
        print("Hello!")
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "user")
            }
        catch {
            print("Locksmith couldn't delete any data")
        }
            
        if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
            
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Firebase.defaultConfig()
        NSApplication.shared().registerForRemoteNotifications(matching: .alert)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        exit(0);
    }
    

}

