//
//  AppDelegate.swift
//  ATChat
//
import UIKit
import Fabric
import TwitterKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage
import FirebaseInstanceID
import FirebaseRemoteConfig
import FirebaseAnalytics
import UserNotifications
var chatIdNotification : Int!
var StrUserID : String!
var StrUserName : String = ""
var senderpath : String = ""
//var StrsenderPath : String
var path2: String = ""
var refreshedToken = ""
//var userInfo : NSDictionary = NSDictionary()
var isRememberMe = false
@available(iOS 10.0, *)
var objNotificationContent = UNMutableNotificationContent()

@available(iOS 10.0, *)
var center = UNUserNotificationCenter.current()
//weak var remoteMessageDelegate: MessagingDelegate? { get set }
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,
    UNUserNotificationCenterDelegate,MessagingDelegate
{
    var window: UIWindow?
    //  var StrUserId=NSString() as String
    var ref: DatabaseReference!
    var token: String = ""
    var badgeCount = NSInteger() as Int
    var loginViewController: MyMenuTableViewController?
    var loginTopVC : ExSlideMenuController?
    fileprivate var _refHandle: DatabaseHandle?
    var messages: [DataSnapshot]! = []
    
//MARK: init method
    override init() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        // FirebaseApp.configure().isPersistenceEnabled = true
        
    }
 //MARK: Did finish launching with options
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
             IQKeyboardManager.sharedManager().enable = true
           
            
            IQKeyboardManager.sharedManager().enableAutoToolbar = true
            
            
            IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
       //     IQKeyboardManager.sharedManager().toolbarPreviousNextAllowedClasses
            
             //IQKeyboardManager.sharedManager().enableAutoToolbar = true
            //ask for notification
            let application = UIApplication.shared
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.badge, .sound, .alert],
                    completionHandler: { (granted: Bool, error: Swift.Error?) in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        // PUSH通知許可
                        if granted {
                            UNUserNotificationCenter.current().delegate = self
                            // For iOS 10 data message (sent via FCM)
                            Messaging.messaging().delegate = self
                            application.registerForRemoteNotifications()
                           
                            return
                        }
                        // PUSH通知拒否
                        print("PUSH通知拒否")
                })
            } else {
                if application.responds(to: #selector(application.registerUserNotificationSettings(_:))) {
                    let settings = UIUserNotificationSettings(
                        types: [.alert, .badge, .sound],
                        categories: nil)
                    application.registerUserNotificationSettings(settings)
                    application.registerForRemoteNotifications()
                }
            }
            
          //  FirebaseApp.configure()
          NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.tokenRefreshNotification),
                                                   name: NSNotification.Name.InstanceIDTokenRefresh,
                                                   object: nil)
            AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(false)
            AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(true)
            
            //remember me
        if  (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.paramEmail) as? String) == "" || (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.paramPassword) as? String) == "" || (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.ParamuserID) as? String) == "" {
            isRememberMe = false
        }
        else if (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.paramEmail) as? String) == nil && (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.paramPassword) as? String) == nil || (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.ParamuserID) as? String) == nil {
            isRememberMe = false
            Constants().setUserDefault(ObjectToSave: "NO" as AnyObject?, KeyToSave: Constants.ApiConstants.issignedin)
            if launchOptions != nil {
                //opened from a push notification when the app is closed
                var userInfo: [AnyHashable: Any]? = (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any])
                if userInfo != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TestNotification"), object: nil, userInfo: userInfo)
                    window?.rootViewController?.present(loginViewController!, animated: true, completion: { _ in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TestNotification"), object: nil, userInfo: userInfo)
                    })
                    print("userInfo->\(userInfo?["aps"])")
                }
            }
            else {
               // window?.rootViewController?.present(loginViewController!, animated: true, completion: { _ in
            }
}
        else {
            StrUserID = (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.ParamuserID) as! NSString) as String!
            print(StrUserID)
            isRememberMe = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "chatViewController") as! chatViewController
            let leftViewController = storyboard.instantiateViewController(withIdentifier: "MyMenuTableViewController") as! MyMenuTableViewController
            if launchOptions != nil {
                //opened from a push notification when the app is closed
                var userInfo: [AnyHashable: Any]? = (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any])
                if userInfo != nil {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TestNotification"), object: nil, userInfo: userInfo)
                window?.rootViewController?.present(loginViewController!, animated: true, completion: { _ in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TestNotification"), object: nil, userInfo: userInfo)
                    })
                    print("userInfo->\(userInfo?["aps"])")
                }
            }
            else {
                //window?.rootViewController?.present(loginViewController!, animated: true, completion: { _ in })
            }
            let nvc = UINavigationController(rootViewController: mainViewController)
            nvc.navigationBar.barTintColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(183.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0 / 255.0))
            let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
            slideMenuController.automaticallyAdjustsScrollViewInsets = true
            // slideMenuController.delegate = ViewController
            self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
            self.window?.rootViewController = slideMenuController
            self.window?.makeKeyAndVisible()
            }
            Twitter.sharedInstance().start(withConsumerKey:"i2M998qDviWxsNQNp1snnlLGN", consumerSecret:"NAofnOhcaEt0trCs8OncqnOA6HEdYA3G01IkudDSLG7f1Tyoc6")

        //twitter
     Fabric.with([Twitter.self])
        // return YES
        
return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
//MARK: slide menu view controller set method
    func createMenuView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "chatViewController") as! chatViewController
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "MyMenuTableViewController") as! MyMenuTableViewController
        let nvc = UINavigationController(rootViewController: mainViewController)
        nvc.navigationBar.barTintColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(183.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0 / 255.0))
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        // slideMenuController.delegate = ViewController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
    }
    
//MARK: navigate after receive notification
    func nav()
    {

    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NewChatViewController") as! NewChatViewController
        self.window?.rootViewController?.present(navigationController, animated: true, completion: {})
        
    }
    
//MARK: configure Database method
func configureDatabase() {
      ref = Database.database().reference()
//        _refHandle = ref.child("messages").child(StrUserID).observe(.childAdded, with: {(_ snapshot: FIRDataSnapshot) -> Void in
             ref.child("messages").observeSingleEvent(of: .value, with: { (snapshot) in
            print("\(snapshot.key)")
        })
    }
//MARK: firebase messaging delegate method
    public func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        
    }
//MARK: Did receive remote notification for ios9 and below
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (_: UIBackgroundFetchResult) -> Void) {
//        print("Message ID: \(userInfo["gcm.message_id"]!)")
//           print("userInfo=>\(userInfo)")
//       // FIRMessaging().appDidReceiveMessage(userInfo)
//      //  FIRMessaging.appDidReceiveMessage()
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//     
//       showAlert(withUserInfo: userInfo)
//       // var userInfo: [AnyHashable: Any]? = notification.request.content.userInfo
//
////        application.applicationIconBadgeNumber = 0
////        if application.applicationState == .active {
////             Messaging.messaging().appDidReceiveMessage(userInfo)
////             showAlert(withUserInfo: userInfo)
////            
////        }
//        let state = UIApplication.shared.applicationState
//        
//        if state == .background {
//            Messaging.messaging().appDidReceiveMessage(userInfo)
//            showAlert(withUserInfo: userInfo)
//            // background
//            //  self.nav()
//            
//        }
//        else if state == .active {
//            Messaging.messaging().appDidReceiveMessage(userInfo)
//            showAlert(withUserInfo: userInfo)
//            // foreground
//            //self.nav()
//            
//        }
//
//    //  self.nav()
//        
//        completionHandler(UIBackgroundFetchResult.newData)
//        
//    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        // Print notification payload data
      // var userInfo: [AnyHashable: Any]? = notification.request.content.userInfo

        // FIRMessaging().appDidReceiveMessage(userInfo)
        //  FIRMessaging.appDidReceiveMessage()
        Messaging.messaging().appDidReceiveMessage(userInfo)

        showAlert(withUserInfo: userInfo)
        if (chatIdNotification != (userInfo["id"] as! Int))
        {
            showAlert(withUserInfo: userInfo)
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadChatData"), object: nil, userInfo: userInfo)
        }
        
        
        
        //        application.applicationIconBadgeNumber = 0
        //        if application.applicationState == .active {
        //             Messaging.messaging().appDidReceiveMessage(userInfo)
        //             showAlert(withUserInfo: userInfo)
        //
        //        }
        
        self.createMenuView()
//        let state = UIApplication.shared.applicationState
//        
//        if state == .background {
//            Messaging.messaging().appDidReceiveMessage(userInfo)
//            showAlert(withUserInfo: userInfo)
//            // background
//            //  self.nav()
//            self.createMenuView()
//
//        }
//        else if state == .active {
//            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadChatData"), object: nil, userInfo: userInfo)
//            
//            Messaging.messaging().appDidReceiveMessage(userInfo)
//            showAlert(withUserInfo: userInfo)
//            // foreground
//            //self.nav()
//            }
//            self.createMenuView()
//
//        }
        

    }
    func nothing()
    {
        print("nothing")
    }
    func createmenu2()
    {
    
    }
 //MARK: Notification Will present delegate method for ios 10
   @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
   {
    let userInfo: [AnyHashable: Any]? = notification.request.content.userInfo
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let mainViewController = storyboard.instantiateViewController(withIdentifier: "chatViewController") as! chatViewController
//    let nvc = UINavigationController(rootViewController: mainViewController)
   // userInfo = notification.request.content.userInfo as NSDictionary
     if (chatIdNotification != (userInfo?["id"] as! Int))
     {
      showAlert(withUserInfo: userInfo!)
     // Print full message.
     //NSLog(@"%@", userInfo);
     // Change this to your preferred presentation option
     
     }
    if let viewControllers = window?.rootViewController?.childViewControllers {
        for viewController in viewControllers {
            if viewController .isKind(of: NewChatViewController.self) {
                //println("Found it!!!")
                nothing()
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadChatData"), object: nil, userInfo: userInfo)
                
            }
        }
    }
   

    else{
       showAlert(withUserInfo: userInfo!)
          self.createMenuView()
    }
     //  self.nav()
  


     completionHandler([UNNotificationPresentationOptions.sound , UNNotificationPresentationOptions.alert , UNNotificationPresentationOptions.badge])
}
//MARK: Notification delegate method Did recive response for ios 10
@available(iOS 10, *)
func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void)
{
    
        let userInfo: [AnyHashable: Any] = response.notification.request.content.userInfo
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//    
//       print("userInfo=>\(userInfo)")
//       showAlert(withUserInfo: userInfo)
//    self.createMenuView()

       //  MIDINoteMessage.appData
//     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadChatData"), object: nil, userInfo: userInfo)
//       let nav: UINavigationController? = (loginTopVC?.mainViewController as? UINavigationController)
//       if (nav?.topViewController?.isKind(of: chatViewController.self))! {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadChatData"), object: nil, userInfo: userInfo)
//    }
//       else {
//           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TestNotification"), object: nil, userInfo: userInfo)
//  }
    // self.createMenuView()
//    let state = UIApplication.shared.applicationState
//    
//    if state == .background {
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        showAlert(withUserInfo: userInfo)
//        self.createMenuView()
//
//        // background
//        
//
//    }
//    else if state == .active {
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        showAlert(withUserInfo: userInfo)
//        self.createMenuView()
//
//        // foreground
//       
//
//    }
    let state = UIApplication.shared.applicationState
    
    if state == .background {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        showAlert(withUserInfo: userInfo)
        // background
        //  self.nav()
        self.createMenuView()
        
    }
 

    else if state == .active {
        
    if let viewControllers = window?.rootViewController?.childViewControllers {
    for viewController in viewControllers {
    if viewController .isKind(of: NewChatViewController.self) {
    //println("Found it!!!")
    nothing()
    //                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadChatData"), object: nil, userInfo: userInfo)
    
    }
    }
    }
        else{
            Messaging.messaging().appDidReceiveMessage(userInfo)
            showAlert(withUserInfo: userInfo)
            // foreground
            //self.nav()
        
        self.createMenuView()
        }
    }

    completionHandler()
   }
    
//MARK: Remote message delegate method
  func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    
    
        //remoteMessage.appData
    }

//MARK: Refreshed token method
func tokenRefreshNotification(notification: NSNotification) {
        //  print("refresh token call")
   guard InstanceID.instanceID().token() != nil
        else{
            return
        }
        let refreshedToken: String = InstanceID.instanceID().token()!
        print(refreshedToken)
        UserDefaults.standard.set(refreshedToken, forKey: "MyAppDeviceToken")
        UserDefaults.standard.synchronize()
        connectToFcm()
    }
//MARK: Connect to FCM (Firebase)
    func connectToFcm() {
        // Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return
        }
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        Messaging.messaging().connect { (error) in
            if error != nil {
                print("Unable  to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
            }
        }
    }
//MARK: Did register for remote notifications With Device token to get Device token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        InstanceID.instanceID().setAPNSToken(deviceToken, type: InstanceIDAPNSTokenType.sandbox)

        /* let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
         print(deviceTokenString)*/
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
                InstanceID.instanceID().setAPNSToken(deviceToken, type:InstanceIDAPNSTokenType.prod)
        UserDefaults.standard.set(deviceTokenString, forKey: "MyAppDeviceToken")
        UserDefaults.standard.synchronize()
        //refreshedToken  = FIRInstanceID.instanceID().token()! as String
    }
    
//MARK: Did fail to get device token (if in simulator)
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
//MARK: UIApplication in background method
    func applicationDidEnterBackground(_ application: UIApplication) {
//        FIRMessaging.messaging().disconnect()
//        print("Disconnected from FCM.")
        badgeCount = badgeCount + 1
        badgeCount = application.applicationIconBadgeNumber;
    }
//MARK: facebook shared instance with url method
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
//MARK: UIApplication Will Resign Active method
    func applicationWillResignActive(_ application: UIApplication) {
      
    }
//MARK: UIApplication Will enter in Forground method
    func applicationWillEnterForeground(_ application: UIApplication) {
        
       // let badgeCount as NSInteger = badgeCount + 1;
        //application.applicationIconBadgeNumber = 0;
       badgeCount = badgeCount + 1
       badgeCount = application.applicationIconBadgeNumber;
    }
//MARK: UIApplication Did Become Active method
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        self.connectToFcm()
        
    }
    //MARK: UIApplication Will Terminate method
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
//MARK: Notification Alert
    func notificationAlert(_ title: String, andMessage msg: String) {
        if #available(iOS 10.0, *) {
            objNotificationContent.title = title
            objNotificationContent.body = msg
            objNotificationContent.sound = UNNotificationSound.default()
            objNotificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber?
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: objNotificationContent, trigger:trigger)
           center.add(request, withCompletionHandler: {(_ error: Error?) -> Void in
                if error == nil {
                }
               else{
               }
            })
   }
        else {
            // Fallback on earlier versions
       }
}

//MARK: Show alert after receiving notification method 
   func showAlert(withUserInfo userInfo: [AnyHashable : Any]){
        configureDatabase()
        let apsKey = "aps"
        let gcmMessage = "alert"
        let gcmLabel = "google.c.a.c_l"
        
        if let aps = userInfo[apsKey] as? NSDictionary {
            if let message = aps[gcmMessage] as? String {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: userInfo[gcmLabel] as? String ?? "",
                                                  message: message, preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
                    alert.addAction(dismissAction)
                    self.window?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

       }





