//
//  ViewController.swift
//  ATChat
//
//  Created by komal on 3/21/17.
//  Copyright © 2017 komal. All rights reserved.
//
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import SystemConfiguration
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseRemoteConfig
import FirebaseStorage
import IQKeyboardManagerSwift
//MARK: GLOBAL Variables
//let appDelegate : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
var StrEmail : String = ""
var StrSocialID : String = ""
//var StrUserID : String = ""
var isclickedKeepme = true
//var StrsenderPath : String = ""
var deviceToken : String = ""
var hud: MBProgressHUD?
class ViewController: UIViewController ,UITextFieldDelegate{
    //MARK: Outlets
    var mdata = [AnyHashable: Any]()
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle?
    var user: [DataSnapshot] = []
    var snapshot: DataSnapshot?
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    var msglength: Int = 0
    var strFname : String = ""
    var type : NSString = NSString()
    var STRid : NSString = NSString()
    
    @IBAction func btncancelvw(_ sender: AnyObject) {
        self.socialview.isHidden = true
    }
    @IBOutlet var btnRememberMe: UIButton!
    @IBOutlet var outbtnsocialsubmit: UIButton!
    @IBOutlet var txtpsw: UITextField!
    @IBOutlet var txtemail: UITextField!
    @IBOutlet var forgetout: UIButton!
    @IBOutlet var btnregpressed: UIButton!
    @IBOutlet var socialview: UIView!
    @IBOutlet var txtsocialemail: UITextField!
    @IBOutlet var btnTwitterAction: UIButton!
    @IBOutlet var btnloginpressed: UIButton!
    
    @IBAction func btnsocialsubmit(_ sender: AnyObject) {
    if !(self.isValidEmail(testStr: (self.txtsocialemail.text)!)){
            self.txtsocialemail.text = ""
           // JLToast.makeText("Enter Email").show()
        let alert = UIAlertController(title: "Login", message: "Enter email Id", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)

        }
        else{
            self.socialLoginWS()
        }
        txtsocialemail.text = ""
        self.socialview.isHidden = true
        }
@IBAction func onBtnRememberMe(_ sender: AnyObject)
        {
            if isclickedKeepme {
                btnRememberMe.setImage(UIImage(named: "checked"), for: .normal)
                Constants().setUserDefault(ObjectToSave: txtemail.text as AnyObject?, KeyToSave: Constants.ApiConstants.paramEmail)
                Constants().setUserDefault(ObjectToSave: "YES" as AnyObject?, KeyToSave: Constants.ApiConstants.issignedin)
                Constants().setUserDefault(ObjectToSave: txtpsw.text as AnyObject?, KeyToSave: Constants.ApiConstants.paramPassword)
                isclickedKeepme = false
            }
            else {
                Constants().setUserDefault(ObjectToSave: "NO" as AnyObject?, KeyToSave: Constants.ApiConstants.issignedin)
                btnRememberMe.setImage(UIImage(named: "unchecked"), for: .normal)
                isclickedKeepme = true
            }
}
//MARK: Email ID validation check for fb and twitter login
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    

    //MARK: Application life cycle didload
    override func viewDidLoad() {
        super.viewDidLoad()
        txtemail.delegate = self
        txtpsw.delegate = self
        self.setupEmailTxtField()
        self.setupPasswordTxtField()
        self.socialview.isHidden = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        

    }
    override func viewDidLayoutSubviews() {
        outbtnsocialsubmit.layer.cornerRadius = 12
        outbtnsocialsubmit.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //highlite forgetpassword button
        forgetout.setTitleColor(UIColor.green, for: UIControlState.highlighted)
       
                    if  (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.paramEmail) as? String) != nil && (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.paramPassword) as? String) != nil {
                txtemail.text! = (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.paramEmail) as? String)!
            }
            if (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.issignedin) as? String) != nil {
                if (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.issignedin) as? String)! == "YES"
                {
                    btnRememberMe.setImage(UIImage(named: "checked"), for: .normal)
                    isclickedKeepme = false
                }
            }
        }
    deinit {
        if let refHandle = _refHandle  {
            self.ref.child("tokens").removeObserver(withHandle: refHandle)
        }
    }
//MARK: Configure Firebase Database
    func configureDatabase() {
        ref = Database.database().reference()
        ref.keepSynced(true)

        ref.child("tokens").child(StrUserID).observe(.childAdded, with: {(_ snapshot: DataSnapshot) -> Void in
            self.user.append(snapshot)
        })
        
    }
    
//MARK: Textfield set up
    func setupEmailTxtField() {
        let imageView = UIImageView()
        let leftV = UIView()
        txtemail.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        leftV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let image = UIImage(named: "ic_email-1.png")
        imageView.image = image
        leftV.addSubview(imageView)
        txtemail.leftView = leftV
        txtemail.leftViewMode = UITextFieldViewMode.always
    }
    
    func setupPasswordTxtField() {
        let imageView = UIImageView()
        let leftV = UIView()
        txtpsw.attributedPlaceholder = NSAttributedString(string: "Password",
                                                          attributes: [NSForegroundColorAttributeName: UIColor.black])
        leftV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let image = UIImage(named: "ic_password.png")
        imageView.image = image
        leftV.addSubview(imageView)
        txtpsw.leftView = leftV
        txtpsw.leftViewMode = UITextFieldViewMode.always
    }
    //MARK: Textfield return delegate method
    func textFieldShouldReturn (_ textField: UITextField) -> Bool{
        if ((textField == txtemail)){
            txtpsw.becomeFirstResponder();
        }
        else if ((textField == txtpsw)){
            textField.resignFirstResponder();
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK: Login button action
    @IBAction func btnloginaction(_ sender: AnyObject) {
        if (txtemail.text! == ""){
            //  JLToast.makeText("please enter first name").show()
            let alert = UIAlertController(title: "Login", message: "Please enter Email Address", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
       
        else if (txtpsw.text! == ""){
            // JLToast.makeText("please enter last name").show()
            let alert = UIAlertController(title: "Login", message: "Please enter Password", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
       
        else{
        webServiceCallLogin()
        }
    }
//MARK: Webservice Call for login
    func webServiceCallLogin() {
        if (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.issignedin) as? String) != nil {
            if (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.issignedin) as? String)! == "YES"
            {
                Constants().setUserDefault(ObjectToSave: txtemail.text! as AnyObject?, KeyToSave: Constants.ApiConstants.paramEmail)
                
                Constants().setUserDefault(ObjectToSave: txtpsw.text! as AnyObject?, KeyToSave: Constants.ApiConstants.paramPassword)
                Constants().setUserDefault(ObjectToSave: "regular" as AnyObject?, KeyToSave: "loginType")
            }
        }
      if ConnectionCheck.isConnectedToNetwork() {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.label.text = "Loading"
            let postString = "email_id=\(txtemail.text!)&password=\(txtpsw.text!)"
            let paramData = postString.data(using: .utf8)
            ApiCall.sharedInstance.requestPostMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_signin", params: paramData!)
            {
                (success, responseData) in
                print(responseData ?? AnyObject.self)
                var dataArr = responseData ?? AnyObject.self as! NSArray
                var strStatus=dataArr.value(forKey: "status") as! NSString
                if(strStatus.lowercased=="error")
                {
                    DispatchQueue.main.async{
                        hud?.hide(animated: true)
                       // JLToast.makeText("enter valid email id or password").show()
                        let alert = UIAlertController(title: "Login", message: "Please enter valid email id or password" as String, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)

                    }
                }
                else
                {
                     path2 = responseData?["path"]! as! String
                    //path1 = responseData?["path"]! as! String
                    var data = dataArr.object(forKey: "data") as? NSDictionary
                    var strMessage=dataArr.value(forKey: "message") as! NSString
                    DispatchQueue.main.async{
                        StrUserID=(data?.value(forKey: "id") as? String)!
                        
                        if isclickedKeepme == false{
                            Constants().setUserDefault(ObjectToSave: StrUserID as AnyObject?, KeyToSave: Constants.ApiConstants.ParamuserID)
                            StrUserID = (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.ParamuserID) as! NSString) as String!
                        }
                        //  StrEmail=(data?.value(forKey:"email_id")as? String)!
                        //JLToast.makeText(strStatus as String).show()
                        let defaults = UserDefaults.standard
                        defaults.set(self.txtemail.text!, forKey: "email")
                        defaults.set(self.txtpsw.text!, forKey: "password")
                        StrUserName = (data?.value(forKey: "first_name") as? String)!
                        senderpath = "\(path2)\(((data?.value(forKey:"image") as?  String))!)"
                        // let url = NSURL(string:senderpath)!
                        // StrsenderPath = (data?.value(forKey: "image")as? String)!
                        defaults.set(StrUserID, forKey: "id")
                        defaults.set(StrUserName, forKey: "first_name")
                        defaults.set(senderpath, forKey:"path1")
                        hud?.hide(animated: true)
                        UserDefaults.standard.set(true, forKey: "isLogin") //Bool
                        deviceToken = UserDefaults.standard.object(forKey: "MyAppDeviceToken") as! String
                        if deviceToken.isEmpty{
                            let appDelegate : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.createMenuView()
                        }
                        else
                        {
                           deviceToken = UserDefaults.standard.object(forKey: "MyAppDeviceToken") as! String
                            self.configureDatabase()
                            /*       deviceToken = UserDefaults.standard.object(forKey: "MyAppDeviceToken") as! String*/
                            self.mdata["deviceType"] = "IOS"
                            self.mdata["deviceToken"] = deviceToken
                            self.mdata["userActive"] = "true"
                            self.mdata["userDeleted"] = "false"
                            self.ref.child("tokens").child(StrUserID).updateChildValues(self.mdata)
                            let appDelegate : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.createMenuView()
                            
                        }
                    }
                }
            }
        }
        else{
            JLToast.makeText("Check your conncection").show()
        }
        
    }
//MARK: Firebase Fetch config method
    func fetchConfig() {
        var expirationDuration: Double = 3600
        // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
        // the server.
        if self.remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [weak self] (status, error) in
            if status == .success {
                print("Config fetched!")
                guard let strongSelf = self else { return }
                strongSelf.remoteConfig.activateFetched()
                let friendlyMsgLength = strongSelf.remoteConfig["friendly_msg_length"]
                if friendlyMsgLength.source != .static {
                    strongSelf.msglength = Int(friendlyMsgLength.numberValue!)
                    print("Friendly msg length config: \(strongSelf.msglength)")
                }
            } else {
                print("Config not fetched")
                if let error = error {
                    print("Error \(error)")
                }
            }
        }
    }
//MARK: Configure storage method
    func configureStorage() {
        storageRef = Storage().reference()
    }
//MARK: Configure remote storage method
    func configureRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
    }
    
//MARK: forget password action
    @IBAction func btnforgetactionp(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
//MARK: registration action
    @IBAction func btnregister(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
//MARK: facebook login button action
    @IBAction func btnfblogin(_ sender: AnyObject) {
        fblogin()
    }
    
//MARK: facebook login function
    func fblogin()
    {
        //simple facebook login without webservice
        //        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self){(result,err)in
        //
        //            if err != nil{
        //                print("error\(err)")
        //                return
        //            }
        //            _ = UIApplication.shared.delegate as! AppDelegate
        //            //    appDelegate.loginSuccessful()
        //        }
        
//LOGIN with facebook
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let objFBSDKLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        objFBSDKLoginManager.logIn(withReadPermissions: ["email"]) { (result, error) -> Void in
            if (error == nil) {
                let objLoginResult : FBSDKLoginManagerLoginResult = result!
                if (result?.isCancelled)! {
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        //                        self.viewBlurimg.isHidden = true
                    }
                    return
                }
                if (objLoginResult.grantedPermissions.contains("email")) {
                    if ((FBSDKAccessToken.current()) != nil) {
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil) {
                                self.type = "facebook"
                                let response = result as AnyObject?
                                DispatchQueue.main.async {
                                    //                                    MBProgressHUD.hide(for: self.view, animated: true)
                                    self.socialLoginWS()
                                    // self.viewFBLogin.isHidden = false
                                }
                                let fnm = response?.object(forKey: "first_name") as AnyObject?
                                self.strFname = (fnm as! NSString) as String
                                let id = response?.object(forKey: "id") as AnyObject?
                                StrSocialID = id as! String
                                let lnm = response?.object(forKey: "last_name") as AnyObject?
                                let strLastName: String = (lnm as? String)!
                                //  userFName.name = "\(strFirstName)\(strLastName)"
                                print(strLastName)
                                let img = ((response?.object(forKey: "picture") as AnyObject?)?.object(forKey: "data") as AnyObject?)?.object(forKey:"url") as AnyObject?
                                let strPictureURL: String = (img as? String)!
                                // strProfileImg = strPictureURL
                                print(strPictureURL)
                                StrUserName = "\(fnm!)" + " " + "\(lnm!)" as String
                                
                            }
                        })
                    }
                }
            }
            else{
                
            }
        }
    }
//MARK: Webservice call for Social Login(fb and twitter)
func socialLoginWS() {
        // Post
        if ConnectionCheck.isConnectedToNetwork() {
            //           MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let postString = "type=\(type)&social_id=\(StrSocialID)&email_id=\(txtsocialemail.text!)&first_name=\(strFname)"
            let paramData = postString.data(using: .utf8)
            ApiCall.sharedInstance.requestPostMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_soclogin", params: paramData!) { (success, responseData) in
                print(responseData ?? AnyObject.self)
                
                let status = (responseData?["status"]!) as! NSString
                
                //unm                   let arydata2 = (arydata[0] as! NSDictionary)["fname"]!
                //                    StrUserName = String(describing: arydata2)
                
                //  StrUserID = () as String
                let strcode = (responseData?["code"]!) as! Int
                if(strcode == 2){
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.socialview.isHidden = false
                                           }
                }
                if (status == "success"){
                    let defaults = UserDefaults.standard
                    let arydata = (responseData?["data"]!) as! NSArray
                    let arydata1 = (arydata[0] as! NSDictionary)["id"]!
                    StrUserID = String(describing: arydata1)
                    defaults.set(StrUserID, forKey: "id")
                    DispatchQueue.main.async {
                        let appDelegate : AppDelegate! = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.createMenuView()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
}
                else{
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        //                        Toast(text: "Error", duration: Delay.short).show()
                        //JLToast.makeText("Error").show()
                        let alert = UIAlertController(title: "Login", message: "Error", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)

                    }
                }
            }
        }
        else{
            JLToast.makeText("Check Your Conection").show()
            
        }
        
    }

    
//MARK: twitter login button action
@IBAction func twitaction(_ sender: AnyObject) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Twitter.sharedInstance().logIn {
        (session, error) -> Void in
            if (session != nil) {
                print("signed in as \(session!.userName)")
                self.type = "twitter"
                StrSocialID = session!.userID as String
                let client = TWTRAPIClient()
                client.loadUser(withID: (session?.userID)!, completion: { (user, error) -> Void in
                    DispatchQueue.main.async {
                        self.strFname = (user!.name) as String
                        print("Name: \(user!.name)")
                        print("Image Url: \(user!.profileImageURL)")
                        StrUserName = (user!.name) as String
                        self.socialLoginWS()
                    }
                    
                })
            }
            else {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
            
                }
            }
        }
    }
    
    
    

    
}
