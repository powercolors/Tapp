//
//  Plaid.swift
//  Tapp
//
//  Created by s on 2017-11-19.
//  Copyright © 2017 Carspotter Daily. All rights reserved.
//

import Foundation
import Cocoa
import SwiftyJSON
import Alamofire
import Locksmith
import FlatButton
let NOTIFICATIONKEY = "Tapp2"
class Plaid: NSViewController, NSUserNotificationCenterDelegate {
    @IBOutlet weak var Lock: FlatButton!
    @IBOutlet weak var RStart: FlatButton!
    @IBOutlet weak var VehicleImage: NSImageView!
    @IBOutlet weak var FlashLights: FlatButton!
    @IBOutlet weak var Horn: FlatButton!
    @IBOutlet weak var Trunk: FlatButton!
    @IBOutlet weak var Frunk: FlatButton!
    @IBOutlet weak var ChargePort: FlatButton!
    @IBOutlet weak var VIN: NSTextField!
    @IBOutlet weak var ChargeLabel: NSTextField!
    
    var token = CVD.Token!
    var vehicleID = CVD.vehicleIDs[CVD.SelectedVehicle]
    var headers = CVD.headers
    let json = CVD.Data[CVD.SelectedVehicle]
    let v = CVD.SelectedVehicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.vehicleID = CVD.vehicleIDs[v]
        if(UserDefaults.standard.value(forKey: "GraphXMax") != nil) {
            CVD.GraphSavedValues = UserDefaults.standard.integer(forKey: "GraphXMax")
        }
        
        let isLocked = json["response"]["vehicle_state"]["locked"].boolValue
        if(isLocked == true) {
            print("Vehicle is locked")
            self.Lock.title = "Unlock"
        }
        else {
            print("Vehicle is Unlocked")
            self.Lock.title = "Lock"
        }
        NSUserNotificationCenter.default.delegate = self
        self.WakeVehicle()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layer?.backgroundColor = CVD.Theme
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.getcardata()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getcardata), name: NSNotification.Name(rawValue: NOTIFICATIONKEY), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ColorChange(_:)), name: NSNotification.Name(rawValue: "ChangeColor"), object: nil)
        self.view.layer?.backgroundColor = NSColor(red: 85, green: 85, blue: 85, alpha: 1.0).cgColor
        let jsonCharge = json["response"]["charge_state"]["charging_state"].stringValue
        if(jsonCharge == "Complete") {
            self.ChargeLabel.stringValue = "Charging Complete"
            self.ChargeLabel.textColor = .systemGreen
        } else if(jsonCharge == "Connected") {
            self.ChargeLabel.stringValue = "Charge Cable Connected"
            self.ChargeLabel.textColor = .systemBlue
        } else if(jsonCharge == "null") {
            self.ChargeLabel.stringValue = ""
        } else if(jsonCharge == "Supercharging") {
            self.ChargeLabel.stringValue = "Supercharging"
            self.ChargeLabel.textColor = .systemPurple
        } else {
            self.ChargeLabel.stringValue = jsonCharge
        }

    }
    override func viewWillDisappear() {
        super.viewWillDisappear()
        timer.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    

    var timer = Timer()
    
    @objc func ColorChange(_ notification: NSNotification) {
        self.view.layer?.backgroundColor = notification.userInfo!["color"] as! CGColor
    }
    @objc func getcardata(){
        print("hello")
                let json = CVD.Data[v]
        self.VIN.stringValue = "VIN : \(json["response"]["vin"].stringValue)"
                let vehMod = json["response"]["vehicle_config"]["car_type"].stringValue
                CVD.VehicleTrims.append(vehMod.last!)
                if(json["response"]["vehicle_state"]["valet_mode"] == "true") {
                    print("valet mode")
                }
                else if(json["response"]["vehicle_state"]["valet_mode"] == "false") {
                    print("no valet mode")
                }
                if(json["response"]["vehicle_config"]["can_actuate_trunks"].boolValue) {
                    self.Frunk.isHidden = false
                    self.Trunk.isHidden = false
                } else {
                    self.Frunk.isHidden = true
                    self.Trunk.isHidden = true
                    }

                    if(json["response"]["drive_state"]["shift_state"] == JSON.null || json["response"]["drive_state"]["shift_state"].stringValue == "P") {
                        
                    }
                    else {
                        self.RStart.isHidden = true
                    }
        if(json["response"]["charge_state"]["charging_state"].stringValue == "Charging" || json["response"]["charge_state"]["charging_state"].stringValue == "Complete" || json["response"]["charge_state"]["charging_state"].stringValue == "Connected") {
            self.ChargePort.isHidden = true
        }
        
                    /*
                     Changes App Icon yeh
                     */
                    let percentage = json["response"]["charge_state"]["usable_battery_level"].intValue
                    if(percentage <= 0) {
                        NSApplication.shared().applicationIconImage = #imageLiteral(resourceName: "NoBattery")
                    }
                    else if(percentage >= 0 && percentage <= 20) {
                        NSApplication.shared().applicationIconImage = #imageLiteral(resourceName: "LowBattery")
                    }
                    else if(percentage > 20 && percentage <= 40) {
                        NSApplication.shared().applicationIconImage = #imageLiteral(resourceName: "2Battery")
                    }
                    else if(percentage > 40 && percentage <= 60) {
                        NSApplication.shared().applicationIconImage = #imageLiteral(resourceName: "3Battery")
                    }
                    else if(percentage > 60 && percentage <= 80) {
                        NSApplication.shared().applicationIconImage = #imageLiteral(resourceName: "4Battery")
                    }
                    else if(percentage > 80 && percentage <= 100) {
                        NSApplication.shared().applicationIconImage =  #imageLiteral(resourceName: "FullBattery")
                    }
       self.getimg(1)
        CVD.BatteryImage = NSApplication.shared().applicationIconImage
        }
    
    

    
    func getimg(_ Reload: Int?) {
        let options = CVD.optionCodes[v]
        let model = CVD.VehicleTrims[v]
        let url = URL(string:"https://www.tesla.com/configurator/compositor/?model=m\(model)&view=STUD_SEAT_ABOVE&options=\(options)&bkba_opt=1&size=1920")
        let _ = Alamofire.request(url!).responseImage { response in
            let data = response.result.value
            if(data != nil) {
                let img = data
            self.VehicleImage.image = img
                
            CVD.VehicleAbov = data!
            self.VehicleImage.wantsLayer = true
            self.VehicleImage.layer?.backgroundColor = NSColor.darkGray.cgColor
                if(Reload == 0) {
                let notification = NSUserNotification()
                notification.title = "Logged in successfully"
                notification.contentImage = data
                notification.informativeText = "Thank you for using Tapp :)"
                NSUserNotificationCenter.default.deliver(notification)
                NSUserNotificationCenter.default.removeDeliveredNotification(NSUserNotificationCenter.default.deliveredNotifications[0]) //Deletes login noty
                }
            }
        }
    }
    
    
    func WakeVehicle() {
        let vehicleid = CVD.vehicleIDs[CVD.SelectedVehicle]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/wake_up")
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
        }
    }
    
    @IBAction func Lock(_ sender: Any) {
            let token = CVD.Token
            let vehicleid = CVD.vehicleIDs[v]
            let headers = [
                "Authorization": "Bearer \(token!)"
            ]
            let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/data")
            let _ = Alamofire.request(url!, method: .get, encoding: URLEncoding.default, headers: headers).downloadProgress(queue: DispatchQueue.global(qos: .utility)) {
                progress in
                }
                .validate { request, response, data in
                    return .success
                }
                .responseJSON {
                    response in
                    let data = response.result.value
                    let json = JSON(data!)
                    CVD.Data.remove(at: 0)
                    CVD.Data.append(json)
                    let isLocked = json["response"]["vehicle_state"]["locked"].boolValue
                    if(isLocked == true) {
                        print("Button pressed, vehicle currently locked")
                        let urll = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(self.vehicleID)/command/door_unlock")
                        let _ = Alamofire.request(urll!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                            print(response)
                            self.Lock.title = "Lock"
                        }
                    }
                    else {
                        print("Button pressed, vehicle currently unlocked")
                        let urll = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(self.vehicleID)/command/door_lock")
                        let _ = Alamofire.request(urll!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                            print(response)
                            self.Lock.title = "Unlock"
                        }
                    }
        }
    }
    
    
    
    
    @IBAction func RStart(_ sender: Any) {
        let password = CVD.pass
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleID)/command/remote_start_drive?password=\(password)")
            
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let data = response.result.value
            let json = JSON(data!)
            
            print(json, response)
            
        }
    }
    
    @IBAction func FlashLights(_ sender: Any) {
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleID)/command/flash_lights")
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            
        }
    }
    
    @IBAction func Horn(_ sender: Any) {
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleID)/command/honk_horn")
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response)
            
        }
    }
    
    
    @IBAction func Frunk(_ sender: Any) {
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleID)/command/trunk_open?which_trunk=front")
        
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
    }
    
    @IBAction func Trunk(_ sender: Any) {
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleID)/command/trunk_open?which_trunk=rear")
        
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
    }
    
    
    @IBAction func ChargePort(_ sender: Any) {
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleID)/command/charge_port_door_open")
        
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        }
    }
    
    
}
