//
//  Subzero.swift
//  Tapp
//
//  Created by s on 2018-02-04.
//  Copyright © 2018 Carspotter Daily. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import FlatButton

class Subzero: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.onLoad()
        self.HVACImage.toolTip = "Turn the HVAC on"
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        self.onLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.onLoad), name: NSNotification.Name(rawValue: NOTIFICATIONKEY), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ColorChange(_:)), name: NSNotification.Name(rawValue: "ChangeColor"), object: nil)
        self.view.layer?.backgroundColor = CVD.Theme
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        timer.invalidate()
    }
    
    @objc func ColorChange(_ notification: NSNotification) {
        self.view.layer?.backgroundColor = notification.userInfo!["color"] as! CGColor
    }

    @IBOutlet weak var DriverTempLabel: NSTextField!
    @IBOutlet weak var PassengerTempLabel: NSTextField!
    @IBOutlet weak var InteriorTemperature: NSLevelIndicator!
    @IBOutlet weak var ExteriorTemperature: NSLevelIndicator!
    @IBOutlet weak var ExtTemperatureLabel: NSTextField!
    @IBOutlet weak var IntTemperatureLabel: NSTextField!
    @IBOutlet weak var HVACImage: NSImageView!
    @IBOutlet weak var DriverUp: FlatButton!
    @IBOutlet weak var DriverDown: FlatButton!
    @IBOutlet weak var PassengerUp: FlatButton!
    @IBOutlet weak var PassengerDown: FlatButton!
    @IBOutlet weak var HVACControl: FlatButton!
    
    var timer = Timer()
    let v = CVD.SelectedVehicle
    var DriverTemp = Int()
    var PassengerTemp = Int()
    let json = CVD.Data[CVD.SelectedVehicle]
    let units = CVD.Data[CVD.SelectedVehicle]["response"]["gui_settings"]["gui_temperature_units"].stringValue.uppercased()
    
    @objc func onLoad() {
        if(json["response"]["climate_state"]["is_climate_on"].boolValue) {
            self.HVACControl.title = "Turn HVAC Off"
        } else {
            self.HVACControl.title = "Turn HVAC On"
        }
                let units = json["response"]["gui_settings"]["gui_temperature_units"].stringValue.uppercased()
            let interiorTemp = json["response"]["climate_state"]["inside_temp"].doubleValue
            let exteriorTemp = json["response"]["climate_state"]["outside_temp"].doubleValue
            self.InteriorTemperature?.doubleValue = interiorTemp
            self.IntTemperatureLabel?.stringValue = "\(interiorTemp)°\(units)"
            self.ExteriorTemperature?.doubleValue = exteriorTemp
            self.ExtTemperatureLabel?.stringValue = "\(exteriorTemp)°\(units)"
            self.DriverTempLabel?.stringValue = "\(json["response"]["climate_state"]["driver_temp_setting"].intValue)°\(units)"
            self.DriverTemp = json["response"]["climate_state"]["driver_temp_setting"].intValue
            self.PassengerTempLabel?.stringValue = "\(json["response"]["climate_state"]["passenger_temp_setting"].intValue)°\(units)"
            self.PassengerTemp = json["response"]["climate_state"]["passenger_temp_setting"].intValue
            if(units == "C") {
                if(interiorTemp >= 15) {
                    self.HVACImage?.image = #imageLiteral(resourceName: "HVAC_COOL")
                }
                else {
                    self.HVACImage?.image = #imageLiteral(resourceName: "HVAC_HEAT")
                }
            }
            else if(units == "F") {
                if(interiorTemp >= 85) {
                    self.HVACImage?.image = #imageLiteral(resourceName: "HVAC_COOL")
                }
                else {
                    self.HVACImage?.image = #imageLiteral(resourceName: "HVAC_HEAT")
                }
            }
        }
    @IBAction func DriverUp(_ sender: Any) {
        self.DriverTempLabel.stringValue = "\(self.DriverTempLabel.intValue + 1)°\(units)"
        let drvtemp = self.DriverTempLabel.integerValue
        let passtemp = self.PassengerTempLabel.integerValue
        let vehicleid = CVD.vehicleIDs[CVD.SelectedVehicle]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/set_temps?driver_temp=\(drvtemp)&passenger_temp=\(passtemp)")
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
        }
    }
    @IBAction func DriverDown(_ sender: Any) {
        self.DriverTempLabel.stringValue = "\(self.DriverTempLabel.intValue - 1)°\(units)"
        let drvtemp = self.DriverTempLabel.integerValue
        let passtemp = self.PassengerTempLabel.integerValue
        let vehicleid = CVD.vehicleIDs[CVD.SelectedVehicle]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/set_temps?driver_temp=\(drvtemp)&passenger_temp=\(passtemp)")
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
        }
    }
    @IBAction func PassengerUp(_ sender: Any) {
        self.PassengerTempLabel.stringValue = "\(self.PassengerTempLabel.intValue + 1)°\(units)"
        let drvtemp = self.DriverTempLabel.integerValue
        let passtemp = self.PassengerTempLabel.integerValue
        let vehicleid = CVD.vehicleIDs[CVD.SelectedVehicle]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/set_temps?driver_temp=\(drvtemp)&passenger_temp=\(passtemp)")
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
        }
    }
    @IBAction func PassengerDown(_ sender: Any) {
        self.PassengerTempLabel.stringValue = "\(self.PassengerTempLabel.intValue - 1)°\(units)"
        let drvtemp = self.DriverTempLabel.integerValue
        let passtemp = self.PassengerTempLabel.integerValue
        let vehicleid = CVD.vehicleIDs[CVD.SelectedVehicle]
        let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/set_temps?driver_temp=\(drvtemp)&passenger_temp=\(passtemp)")
        let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
            print(response.result.value)
        }
    }
    
    @IBAction func HVACControl(_ sender: Any) {
        if(HVACControl.title == "Turn HVAC On") {
            HVACControl.title = "Loading"
            let vehicleid = CVD.vehicleIDs[CVD.SelectedVehicle]
            let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/auto_conditioning_start")
            let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
                self.HVACControl.title = "Turn HVAC Off"
            }
        } else if(HVACControl.title == "Turn HVAC Off") {
            HVACControl.title = "Loading"
            let vehicleid = CVD.vehicleIDs[CVD.SelectedVehicle]
            let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/auto_conditioning_stop")
            let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
                self.HVACControl.title = "Turn HVAC On"
            }
        }

    }
    
    
    
}
