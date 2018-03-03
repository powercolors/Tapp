//
//  SelectVehicle.swift
//  Tapp
//
//  Created by s on 2018-02-07.
//  Copyright © 2018 Carspotter Daily. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage
import SwiftyJSON
import Locksmith
import FlatButton

class SelectVehicle : NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.darkGray.cgColor
        self.view.alphaValue = 0.7
        let NumberOfVehicles = CVD.numOfVehicles
        switch NumberOfVehicles {
        case _ where NumberOfVehicles > 5:
            print("Over 5")
        case 5:
            print("5 vehicles")
        case 4:
            Click5.isHidden = true
            Click4.isEnabled = false
            Click3.isEnabled = false
            Click2.isEnabled = false
            Click1.isEnabled = false
        case 3:
            Click5.isHidden = true
            Click4.isHidden = true
            Click3.isEnabled = false
            Click2.isEnabled = false
            Click1.isEnabled = false
        case 2:
            Click5.isHidden = true
            Click4.isHidden = true
            Click3.isHidden = true
            Click2.isEnabled = false
            Click1.isEnabled = false
        case 1:
            Click5.isHidden = true
            Click4.isHidden = true
            Click3.isHidden = true
            Click2.isHidden = true
            Click1.isEnabled = false
        case 0:
            print(0)
            Click5.isHidden = true
            Click4.isHidden = true
            Click3.isHidden = true
            Click2.isHidden = true
            Click1.isEnabled = false
        default:
            print("default number of vehicles")
        }
        self.Loading.integerValue = 1
        for i in 0 ... (NumberOfVehicles - 1) {
            getcardata(i)
        }
        
        
    }
    override func viewDidAppear() {
        super .viewDidAppear()
        self.view.window?.styleMask.remove(NSWindowStyleMask.resizable)
        /*if(!UserDefaults.standard.bool(forKey: "EULA") && !CVD.EULA) {
            self.performSegue(withIdentifier: "SelectToEULA", sender: self)
            self.view.window?.close()
        } else {
            
        }*/
    }
    
    @IBOutlet weak var Click1: NSButton!
    @IBOutlet weak var Click2: NSButton!
    @IBOutlet weak var Click3: NSButton!
    @IBOutlet weak var Click4: NSButton!
    @IBOutlet weak var Click5: NSButton!
    @IBOutlet weak var Loading: NSLevelIndicator!
    @IBOutlet weak var LoadingText: NSTextField!
    
    
    func getimg(_ Car: Int) {
        self.Loading.integerValue = 3
        var BtnImg = self.Click1!
        switch Car {
        case 5:
            BtnImg = self.Click5
        case 4:
            BtnImg = self.Click4
        case 3:
            BtnImg = self.Click3
        case 2:
            BtnImg = self.Click2
        case 1:
            BtnImg = self.Click1
        default:
            BtnImg = self.Click1
        }
        
        let options = CVD.optionCodes[Car]
        let model = CVD.VehicleTrims[Car]
        let url = URL(string:"https://www.tesla.com/configurator/compositor/?model=m\(model)&view=STUD_SIDE&options=\(options)&bkba_opt=1&size=1920")
        print(url!)
        let _ = Alamofire.request(url!).responseImage { response in
            let data = response.result.value
            BtnImg.image = data
            self.view.alphaValue = 1.0
            self.Loading.isHidden = true
            self.LoadingText.isHidden = true
            BtnImg.isEnabled = true
        }
    }
    
    
    func getcardata(_ Car: Int){
        self.Loading.integerValue = 2
        let vehicleid = CVD.vehicleIDs[Car]
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
                    print(json)
                    CVD.Data.append(json)
                    let vehMod = json["response"]["vehicle_config"]["car_type"].stringValue
                    CVD.VehicleTrims.append(vehMod.last!)
                    var carname = String()
                    if(JSON.checkNull(json["response"]["display_name"])) {
                    carname = json["response"]["display_name"].stringValue
                    } else {
                        carname = "Error"
                    }
                    switch Car {
                    case 5:
                        self.Click5.title = carname
                    case 4:
                        self.Click4.title = carname
                    case 3:
                        self.Click3.title = carname
                    case 2:
                        self.Click2.title = carname
                    case 1:
                        self.Click1.title = carname
                    default:
                        self.Click1.title = carname
                    }
                    self.getimg(Car)
                }
                else {
                    print("No data!")
                    self.performSegue(withIdentifier: "BackToLogin", sender: self)
                    self.view.window?.close()
                }
        }
    }
    
    
    @IBAction func Click1(_ sender: Any) {
        CVD.SelectedVehicle = 0
        self.performSegue(withIdentifier: "SelectToView", sender: self)
        self.view.window?.close()
    }
    @IBAction func Click2(_ sender: Any) {
        CVD.SelectedVehicle = 1
        self.performSegue(withIdentifier: "SelectToView", sender: self)
        self.view.window?.close()
    }
    @IBAction func Click3(_ sender: Any) {
        CVD.SelectedVehicle = 2
        self.performSegue(withIdentifier: "SelectToView", sender: self)
        self.view.window?.close()
    }
    @IBAction func Click4(_ sender: Any) {
        CVD.SelectedVehicle = 3
        self.performSegue(withIdentifier: "SelectToView", sender: self)
        self.view.window?.close()
    }
    @IBAction func Click5(_ sender: Any) {
        CVD.SelectedVehicle = 4
        self.performSegue(withIdentifier: "SelectToView", sender: self)
        self.view.window?.close()
    }
    
    
    
    
    
}
