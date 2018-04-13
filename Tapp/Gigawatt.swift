//
//  Gigawatt.swift
//  Tapp
//
//  Created by s on 2017-12-01.
//  Copyright © 2017 Carspotter Daily. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON
import Charts
import FlatButton


class Gigawatt: NSViewController {
    @IBOutlet weak var BatteryImage: NSImageView!
    @IBOutlet weak var PercentageLabel: NSTextField!
    @IBOutlet weak var ChargingImage: NSImageView!
    @IBOutlet weak var ChargeLimit: BarChartView!
    @IBOutlet weak var Graph: LineChartView!
    @IBOutlet weak var ChargeControl: FlatButton!
    @IBOutlet weak var Standard90: FlatButton!
    @IBOutlet weak var MaxRange: FlatButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
                self.view.layer?.backgroundColor = CVD.Theme 
        if(UserDefaults.standard.array(forKey: "Levels") != nil) {
            if(UserDefaults.standard.array(forKey: "Levels")!.count > CVD.GraphSavedValues) {
                var modifier = UserDefaults.standard.array(forKey: "Levels")
                modifier?.removeFirst()
                UserDefaults.standard.set(modifier, forKey: "Levels")
            } else {
        CVD.Levels = UserDefaults.standard.array(forKey: "Levels") as! [Int]
            }
        }
        self.Graph.scaleXEnabled = false
        self.Graph.leftAxis.drawGridLinesEnabled = false
        self.Graph.leftAxis.drawAxisLineEnabled = false
        self.Graph.rightAxis.drawGridLinesEnabled = false
        self.Graph.rightAxis.drawAxisLineEnabled = false
        self.Graph.xAxis.enabled = false
        self.Graph.legend.enabled = false
        self.Graph.xAxis.axisMinimum = 0
        self.setLevel()
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        self.setLevel()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.setLevel), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ColorChange(_:)), name: NSNotification.Name(rawValue: "ChangeColor"), object: nil)
    }
    override func viewWillDisappear() {
        super.viewWillDisappear()
        timer.invalidate()
    }
    
    var v = CVD.SelectedVehicle
    var timer = Timer()
    var lineChartEntry = [ChartDataEntry]()
    
    @objc func ColorChange(_ notification: NSNotification) {
        self.view.layer?.backgroundColor = notification.userInfo!["color"] as! CGColor
    }

    
   @objc func setLevel() {
                let json = CVD.Data
                let percentage = json["response"]["charge_state"]["usable_battery_level"].intValue
                let ChargeState = json["response"]["charge_state"]["charging_state"].stringValue
                self.PercentageLabel?.stringValue = "\(percentage)%"
                    self.BatteryImage?.image = CVD.BatteryImage
                    self.BatteryImage?.image?.backgroundColor = .darkGray
                NSApplication.shared().applicationIconImage = CVD.BatteryImage
                if(ChargeState == "Charging") {
                    self.ChargingImage?.image = #imageLiteral(resourceName: "Charging")
                    self.ChargingImage.image?.backgroundColor = .darkGray
                    self.PercentageLabel?.stringValue = "Charging \(percentage)%"
                    self.ChargeControl.title = "Stop Charging"
                } else if(ChargeState == "Complete") {
                    self.PercentageLabel.stringValue = "Charging Complete \(percentage)%"
                    self.ChargeControl.isEnabled = false
                } else if(ChargeState == "Disconnected"){
                    self.ChargeControl.isEnabled = false
    }
    self.Graph.clear()
    self.lineChartEntry.removeAll()
    if(CVD.Levels.count >= CVD.GraphSavedValues) {
        CVD.Levels.removeFirst()
    }
    if(CVD.Levels.isEmpty) {
        self.Graph.leftAxis.axisMaximum = 100
        self.Graph.leftAxis.axisMinimum = 0
        self.Graph.rightAxis.axisMaximum = 100
        self.Graph.rightAxis.axisMinimum = 0 
    } else {
        self.Graph.leftAxis.axisMaximum = Double(CVD.Levels.first! + 5)
        self.Graph.leftAxis.axisMinimum = Double(CVD.Levels.first! - 5)
        self.Graph.rightAxis.axisMaximum = Double(CVD.Levels.last! + 5)
        self.Graph.rightAxis.axisMinimum = Double(CVD.Levels.last! - 5)
    }
    CVD.Levels.append(json["response"]["charge_state"]["usable_battery_level"].intValue)
    UserDefaults.standard.set(CVD.Levels, forKey: "Levels")
    let levs = (CVD.Levels.count - 1)
    for i in 0...levs {
        let value = ChartDataEntry(x: Double(i), y: Double(CVD.Levels[i]))
        self.lineChartEntry.append(value)
    }
        let line = LineChartDataSet(values: self.lineChartEntry, label: "Battery Level")
        line.colors = [.blue]
        line.mode = .cubicBezier
        line.fillColor = .blue
        line.fillAlpha = 0.5
        line.drawFilledEnabled = true
        line.drawCirclesEnabled = false
        
        let chartdat = LineChartData()
        chartdat.addDataSet(line)
        chartdat.setDrawValues(false)
        self.Graph?.data = chartdat
        self.Graph?.chartDescription?.text = "Battery Level %"
        
    

    }
    
    @IBAction func ChargeControl(_ sender: Any) {
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
                let json = JSON(data!)
                CVD.Data = JSON.null
                CVD.Data = json
                let chargeState = CVD.Data["response"]["charge_state"]["charging_state"].stringValue
                if(chargeState == "Charging") {
                    print("Button pressed, vehicle currently charging")
                    let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/stop_charging")
                    let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
                        self.ChargeControl.title = "Start Charging"
                    }
                } else if(chargeState == "Complete") {
                    self.ChargeControl.isEnabled = false
                }
                else {
                    print("Button pressed, vehicle currently unlocked")
                    let url = URL(string:"https://owner-api.teslamotors.com/api/1/vehicles/\(vehicleid)/command/start_charging")
                    let _ = Alamofire.request(url!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
                        self.ChargeControl.title = "Stop Charging"
                    }
                }
        }
    }
    
    @IBAction func MaxRange(_ sender: Any) {
        _ = Alamofire.request(URL(string: "https://owner-api.teslamotors.com/api/1/vehicles/\(CVD.vehicleIDs[CVD.SelectedVehicle])/command/charge_max_range")!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
        }
    }
    
    @IBAction func Standard90(_ sender: Any) {
        _ = Alamofire.request(URL(string: "https://owner-api.teslamotors.com/api/1/vehicles/\(CVD.vehicleIDs[CVD.SelectedVehicle])/command/charge_standard")!, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: CVD.headers).responseJSON { response in
        }
    }
    
    
}
