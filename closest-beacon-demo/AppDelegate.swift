
import UIKit
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (accepted, error) in
                if accepted == false{
                    print("Not accepted!")
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        application.beginBackgroundTask(withName: "showNotification", expirationHandler: nil)
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func pushNotification() {
        
        if #available(iOS 10.0, *) {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "Reminder!!"
            content.body = "shop nearby"
            content.sound = UNNotificationSound.default()
            
            if let path = Bundle.main.path(forResource: "photo2", ofType: "png") {
                let url = URL(fileURLWithPath: path)
                
                do {
                    let attachment = try UNNotificationAttachment(identifier: "photo", url: url, options: nil)
                    content.attachments = [attachment]
                } catch {
                    print("The attachment was not loaded.")
                }
            }
            
            let request = UNNotificationRequest(identifier: "textNotif", content: content, trigger: trigger)
            
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                    print("We have an error \(error)")
                }
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate?.pushNotification()
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
        func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
            let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
            if (knownBeacons.count > 0) {
                let closestBeacon = knownBeacons[0] as CLBeacon
                
                pushNotification();
            }
        }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }



}
