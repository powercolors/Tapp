//
//  start.swift
//  Tapp
//
//  Created by s on 2017-10-09.
//  Copyright © 2017 Carspotter Daily. All rights reserved.
//

import Foundation
import Cocoa
import Alamofire
import SwiftyJSON
import CoreWLAN
import Locksmith
import FlatButton

class start: NSViewController, NSUserNotificationCenterDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSUserNotificationCenter.default.delegate = self
        print(currentSSIDs().first!)
        let SSID = currentSSIDs().first!
        self.tapp.font = NSFont(name: "KaushanScript-Regular", size: 72.0)
        
        /*if(UserDefaults.standard.string(forKey: SSID) != nil) {
            print("known network")
            
            let KnownNetwork = UserDefaults.standard.string(forKey: SSID)!
            if(KnownNetwork != "Safe") {
                performSegue(withIdentifier: "ShowProxy", sender: self)
            }
        }
        else {
            
            let response = self.Alert("New Network Detected", "Is the network " + SSID + " a network you would consider safe?", .informational , 3 , ["No", "Maybe", "Yes"])
            if response == 1000 {
                print("Yes")
                CVD.SSIDs[SSID] = "Safe"
                if(UserDefaults.standard.integer(forKey: "SaveNetwork") == NSOnState) {
                UserDefaults.standard.set("Safe", forKey: SSID)
                }
            }
            else if response == 1001 {
                print("Maybe")
                CVD.SSIDs[SSID] = "Unsafe"
                if(UserDefaults.standard.integer(forKey: "SaveNetwork") == NSOnState) {
                    UserDefaults.standard.set("Unsafe", forKey: SSID)
                }
                performSegue(withIdentifier: "ShowProxy", sender: self)
            }
            else if response == 1002 {
                print("No")
                CVD.SSIDs[SSID] = "Unsafe"
                if(UserDefaults.standard.integer(forKey: "SaveNetwork") == NSOnState) {
                    UserDefaults.standard.set("Unsafe", forKey: SSID)
                }
                performSegue(withIdentifier: "ShowProxy", sender: self)
            }
            else {
                print("Response: ", response)
            }
            self.view.window?.setIsVisible(true)
            print(CVD.SSIDs)
        }*/
        if(!UserDefaults.standard.bool(forKey: "EULA") && !CVD.EULA) {
            
        } else {
        if(Locksmith.loadDataForUserAccount(userAccount: "user") != nil) {
            let notification = NSUserNotification()
            notification.actionButtonTitle = "OK"
            notification.title = "Logging in..."
            notification.informativeText = "Syncing..."
            notification.identifier = "LoggedInNotification"
            NSUserNotificationCenter.default.deliver(notification)
            CVD.SavedToken = true
            CVD.Token = Locksmith.loadDataForUserAccount(userAccount: "user")!["token"]
            CVD.headers = [
                "Authorization": "Bearer \(CVD.Token!)"
            ]
            headers = CVD.headers
            print(CVD.headers)
            print(CVD.Token!)
            getVehicles()
            
           
        }
        else {
            CVD.SavedToken = false
        }
        
        if(CVD.SavedToken == true) {
            self.or.stringValue = ""
            self.tapp.stringValue = "Welcome back!"
            self.tapp.slideInFromLeft()
            self.acctok.isHidden = true
            self.password.isHidden = true
            self.shwpswd.isHidden = true
            self.visAcc.isHidden = true
            self.acctok.isHidden = true
            self.email.isHidden = true
            self.shwtk.isHidden = true
            self.stayLogged.slideInFromRight()
        }
        if(UserDefaults.standard.string(forKey: "Style") == nil) {
        UserDefaults.standard.set("Dark", forKey: "Style")
            CVD.Theme = NSColor.darkGray.cgColor
        } else if(UserDefaults.standard.string(forKey: "Style") == "Light"){
            CVD.Theme = NSColor.lightGray.cgColor
        } else if(UserDefaults.standard.string(forKey: "Style") == "Disco") {
            CVD.Theme = NSColor.systemBlue.cgColor
        }
        self.view.layer?.backgroundColor = CVD.Theme
    }
}
    override func viewDidAppear() {
        super.viewDidAppear()
        self.tapp.font = NSFont(name: "KaushanScript-Regular", size: 72.0)
        self.email.textColor = NSColor.black
        self.shwtk.slideInFromRight()
        self.shwpswd.slideInFromRight()
        self.view.window?.styleMask.remove(NSWindowStyleMask.resizable)
        if(!UserDefaults.standard.bool(forKey: "EULA") && !CVD.EULA) {
            self.performSegue(withIdentifier: "ToEULA", sender: self)
            self.view.window?.close()
        } else {
            
        }
    }
    var headers = [
    "Bearer":""
]
    
    @IBOutlet weak var tapp: NSTextField!
    @IBOutlet weak var email: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var acctok: NSSecureTextField!
    @IBOutlet weak var login: NSButton!
    @IBOutlet weak var shwtk: NSButton!
    @IBOutlet weak var shwpswd: NSButton!
    @IBOutlet weak var pswdcell: NSSecureTextFieldCell!
    @IBOutlet weak var tkcell: NSSecureTextFieldCell!
    @IBOutlet weak var or: NSTextField!
    @IBOutlet weak var stayLogged: NSButton!
    @IBOutlet weak var visPswd: NSTextField!
    @IBOutlet weak var visAcc: NSTextField!
    
   func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    func getVehicles() {
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/")
        let _ = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: CVD.headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                let data = response.result.value
                if(data != nil) {
                let json = JSON(data!)
                
                print(json)
                switch response.result {

                case .success:
                    if(json["response"] != JSON.null) {
                    if data != nil {
                        CVD.numOfVehicles = json["count"].intValue
                        for i in 1 ... CVD.numOfVehicles {
                            print(i)
                            let x = i - 1
                            CVD.optionCodes.append(json["response"][x]["option_codes"].stringValue)
                            CVD.vehicleIDs.append(json["response"][x]["id_s"].intValue)
                        }
                    self.performSegue(withIdentifier: "LogToSelect", sender: nil)
                        self.view.window?.close()
                    }
                    }
                default:
                print("data_request defaulted")
                    self.or.textColor = .red
                    self.or.stringValue = "Unknown Error"
                    self.or.slideInFromRight()
        }
                }
                else {
                    self.or.textColor = .red
                    self.or.stringValue = "Unknown Error"
                    self.or.slideInFromRight()
                }
    }
    }
    
    
    
    
    
    @IBAction func shwpswd(_ sender: Any) {
        if(shwpswd.state == 1) {
            self.visPswd.stringValue = self.password.stringValue
            self.password.isHidden = true
            self.visPswd.isHidden = false
        }
        else if(shwpswd.state == 0) {
            self.password.stringValue = self.visPswd.stringValue
            self.password.isHidden = false
            self.visPswd.isHidden = true
        }
    }
    @IBAction func shwtk(_ sender: Any) {
        if(shwtk.state == 1) {
            self.visAcc.stringValue = self.acctok.stringValue
            self.acctok.isHidden = true
            self.visAcc.isHidden = false
        }
        else if(shwtk.state == 0) {
            self.acctok.stringValue = self.visAcc.stringValue
            self.acctok.isHidden = false
            self.visAcc.isHidden = true
        }
        
    }
    
    
    
    
    @IBAction func login(_ sender: Any) {
        if(self.acctok.stringValue == "" && self.visAcc.stringValue == "") {
        // Login button pressed
        print("Triggered")
            print("Locksmith is nil")
            var pass = ""
            let mail = self.email.stringValue
            if(self.acctok.stringValue == "" && self.visAcc.stringValue == "") {
            print("accs are nil")
            if(self.password.stringValue == "" && self.visPswd.stringValue != "") {
                pass = self.visPswd.stringValue
                if(mail != "" && pass != "") {
                    logn(mail, pass)
                }
                print("if")
            }
            else if(self.visPswd.stringValue == "" && self.password.stringValue != "") {
                pass = self.password.stringValue
                print("else vis")
                if(mail != "" && pass != "") {
                logn(mail, pass)
                }
            }
            else if(self.password.stringValue == "" && self.visPswd.stringValue == "") {
                print("Both nil")
                self.or.stringValue = "Please enter your info"
                self.or.slideInFromRight()
            }
            else if(self.password.stringValue != "" && self.visPswd.stringValue != "") {
                pass = self.password.stringValue
                print("Both good")
                if(mail != "" && pass != "") {
                    logn(mail, pass)
                }
            }
            else {
                print("password is else, doing nothing")
                }
            }
    }
        else {
            print("access token entered")
            print("Token must be something..")
            if(self.acctok.stringValue != "" && self.visAcc.stringValue != "") {
                print("Both token fields aren't empty")
                checkToken(self.acctok.stringValue)
            }
            else if(self.acctok.stringValue == "" && self.visAcc.stringValue != "") {
                print("visAcc is the field")
                checkToken(self.visAcc.stringValue)
            }
            else if(self.acctok.stringValue != "" && self.visAcc.stringValue == "") {
                print("acctok it is")
                checkToken(self.acctok.stringValue)
            }
        }
}
    
    
    
    func logn(_ mail:String?,_ pass:String?) {
        print("logn")
        let notification = NSUserNotification()
        notification.actionButtonTitle = "OK"
        notification.title = "Logging in..."
        notification.informativeText = "Please wait while we contact Tesla's servers..."
        notification.identifier = "LoggedInNotification"
        NSUserNotificationCenter.default.deliver(notification)
        let url = URL(string: "https://owner-api.teslamotors.com/oauth/token?grant_type=password&client_id=81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384&client_secret=c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3&email=\(mail!)&password=\(pass!)")
        print("setting url OK  ", url!)
            let _ = Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print("response in")
                let data = response.result.value
                let json = JSON(data as Any)
                print(json)
                let status = response.response!.statusCode
                
                switch(status) {
                case 200:
                    print("200")
                    CVD.isLoggedInWithToken = false
                    self.or.stringValue = "Success!"
                    self.or.slideInFromRight()
                    switch(self.stayLogged.state){
                    case 1:
                        do {
                            try Locksmith.saveData(data: ["token": json["access_token"].stringValue], forUserAccount: "user")
                            print(json["access_token"].stringValue)
                            CVD.Token = json["access_token"].stringValue
                            self.getVehicles()
                        }
                        catch {
                            print("Failed to save token")
                        }
                        return
                    case 0:
                        print("user didn't want to save the token")
                        do {
                            CVD.Token = json["access_token"].stringValue
                            self.getVehicles()
                        }
                        catch {
                            print("Failed to delete data")
                        }
                        return
                    default:
                        print("Switch defaulted for some reason")
                    }
                    
                    
                case 400:
                    print("400 - Email or pass empty")
                    self.or.textColor = NSColor.red
                    self.or.stringValue = "Email or Password field left blank"
                case 401:
                    print("401 - Forbidden.. Email or Password incorrect")
                    self.or.textColor = NSColor.red
                    self.or.stringValue = "Invalid login info"
                case 404:
                    print("404")
                    self.or.textColor = NSColor.red
                    self.or.stringValue = "My Bad.. Contact Dev"
                case nil:
                    print("nil")
                    self.or.textColor = NSColor.red
                    self.or.stringValue = "No Wifi!"
                default:
                    print("Here is the error: \(status)")
                    self.or.stringValue = "Unknown error \(status)"
                    
                }
                
        }
    }
    
    
    
    
    
    public func checkToken(_ token: String!) {
        let headers = [
            "Authorization": "Bearer \(token!)"
        ]
        print(token)
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/")
        
        let _ = Alamofire.request(url!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            
            }
            .validate { request, response, data in
                
                return .success
            }
            .responseJSON { response in
                
                switch response.result {
                    
                case .success:
                    let data = response.result.value
                    if data != nil {
                        let json = JSON(data!)
                        print(json)
                        print("Token is all good")
                        CVD.Token = token
                        do {
                             try Locksmith.saveData(data: ["token" : token], forUserAccount: "user")
                        }
                        catch {
                            print("couldn't save locksmith data")
                        }
                        self.getVehicles()
                    }
                case .failure:
                    print("Token Check failure")
                    self.or.textColor = NSColor.red
                    self.or.stringValue = "Invalid Token"
                    self.or.slideInFromRight()
                    self.acctok.resignFirstResponder()
                }
        }
    
}
    
    
    
    
    
    func currentSSIDs() -> [String] {
        let client = CWWiFiClient.shared()
        return client.interfaces()?.flatMap { interface in
            return interface.ssid()
            } ?? []
    }
    
    
    
    
    
}

class SplitView : NSSplitViewController {
    override func viewDidAppear() {
        super .viewDidAppear()
        self.view.window?.styleMask.remove(NSWindowStyleMask.resizable)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.ReloadData), userInfo: nil, repeats: true)
    }
    var timer = Timer()
    
    @objc func ReloadData(){
        print("SHMELLO")
        let vehicleid = CVD.vehicleIDs[CVD.SelectedVehicle]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data")
        let _ = Alamofire.request(url!, method: .get, encoding: URLEncoding.default, headers: CVD.headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) {
            progress in
            }
            .validate { request, response, data in
                return .success
                
            }
            .responseJSON {
                response in
                let data = response.result.value
                if(data != nil) {
                    let json = JSON(data!)
                    CVD.Data = JSON.null
                    CVD.Data = json
                }
                else {
                    print("error")
                }
        }
            .response(completionHandler: { response in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATIONKEY), object: nil)
                
            }
        
        )
    }
}

