//
//  EULA.swift
//  Tapp
//
//  Created by s on 2018-03-02.
//  Copyright © 2018 Carspotter Daily. All rights reserved.
//

import Cocoa
import Alamofire

class EULA: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if(UserDefaults.standard.bool(forKey: "EULA")) {
            self.view.window?.close()
        }
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.darkGray.cgColor
        
        var EULASTR = String()
        let request = Alamofire.request(URL(string: "https://raw.githubusercontent.com/HudsonGraeme/Tapp/master/LICENSE")!)
            .responseString { response in
                EULASTR = response.result.value!
                let AttrEULA = NSAttributedString(string: EULASTR)
            self.TextView.textStorage?.setAttributedString(AttrEULA)
        }
    }
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask.remove(NSWindowStyleMask.resizable)
        self.view.window?.styleMask.remove(NSWindowStyleMask.miniaturizable)
        self.view.window?.styleMask.remove(NSWindowStyleMask.closable)
        self.view.window?.orderFrontRegardless()
    }
    @IBOutlet var TextView: NSTextView!
    @IBOutlet weak var Remember: NSButton!
    @IBOutlet weak var Accept: NSButton!
    @IBOutlet weak var Decline: NSButton!
    
    @IBAction func Accept(_ sender: Any) {
        CVD.EULA = true
        if(Remember.state == NSControlStateValueOn) {
            UserDefaults.standard.set(true, forKey: "EULA")
            self.performSegue(withIdentifier: "EULAToLogin", sender: self)
            self.view.window?.close()
        } else {
            self.performSegue(withIdentifier: "EULAToLogin", sender: self)
            self.view.window?.close()
        }
        
    }
    
    @IBAction func Decline(_ sender: Any) {
        if(Remember.state == NSControlStateValueOn) {
            UserDefaults.standard.set(false, forKey: "EULA")
            exit(0)
        } else {
            //exit(0)
            NSApp.terminate(nil)
        }
    }
    
}
