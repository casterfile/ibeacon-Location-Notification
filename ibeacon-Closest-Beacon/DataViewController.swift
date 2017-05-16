//
//  DataViewController.swift
//  ibeacon-Closest-Beacon
//
//  Created by cast on 15/05/2017.
//  Copyright © 2017 JTAC. All rights reserved.
//

import UIKit
import CoreLocation;
import UserNotifications

class DataViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    let locationManager = CLLocationManager()
    var notifyInfoData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = "Beacon Scanner"
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.NotificationInfo(Color: "Gray")
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.NotificationInfo(Color: "Blue")
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.NotificationInfo(Color: "Orage")
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.NotificationInfo(Color: "Red")
            }
            print(distance)
            
        }
    }
    
    func NotificationInfo(Color: String) {
        if(notifyInfoData){
//            notifyInfoData = false
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey:
                "Hello!: "+Color, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey:
                "Hello_message_body", arguments: nil)
            
            // Deliver the notification in five seconds.
            content.sound = UNNotificationSound.default()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                            repeats: false)
             var diceRoll = Int(arc4random_uniform(1000) + 1)
             var identifierRandomName = "identifier" + String(diceRoll)
            // Schedule the notification.
            let request = UNNotificationRequest(identifier: identifierRandomName, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request, withCompletionHandler: nil)
            
            
        }
    }


}

