//
//  DataViewController.swift
//  SwiftSpaceApp
//
//  Created by Luka Mijatovic on 28/03/2019.
//  Copyright © 2019 KodBiro. All rights reserved.
//

import UIKit
import SpaceShooter

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""

    var unityView : UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if (dataObject == "March") {
            SpaceAppController.shared().application(UIApplication.shared, didFinishLaunchingWithOptions: [:])
            SpaceAppController.shared().applicationDidBecomeActive(UIApplication.shared)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

            self.unityView = SpaceAppController.shared().unityView()
            self.view.addSubview(self.unityView!)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let uv = self.unityView {
            uv.frame = self.view.bounds
        }
    }
    
    @objc func applicationWillResignActive() {
        SpaceAppController.shared().applicationWillResignActive(UIApplication.shared)
    }
    
    @objc func applicationDidBecomeActive() {
        SpaceAppController.shared().applicationDidBecomeActive(UIApplication.shared)
    }
    
    @objc func applicationWillEnterForeground() {
        SpaceAppController.shared().applicationWillEnterForeground(UIApplication.shared)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
        
        if let _ = self.unityView {
            // resume unity - it's safe to call the methods below since we handle the state in the framework
            SpaceAppController.shared().applicationWillEnterForeground(UIApplication.shared)
            SpaceAppController.shared().applicationDidBecomeActive(UIApplication.shared)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let _ = self.unityView {
            // pause unity if the view controller is not visible any more
            SpaceAppController.shared().applicationWillResignActive(UIApplication.shared)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

