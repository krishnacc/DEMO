//
//  NewChatViewController.swift
//  ATChat
//
//  Created by komal on 3/22/17.
//  Copyright © 2017 komal. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseCore
import FirebaseRemoteConfig
import UserNotifications
import IQKeyboardManagerSwift

typealias MessageType = () -> Void
typealias MessageTime = () -> Void
typealias MessageDate = () -> Void
//var chatIdNotification = NSInteger() as Int
//var strName : String = ""
//var strId : NSString = ""
class NewChatViewController: UIViewController,UIImagePickerControllerDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UNUserNotificationCenterDelegate
{
    
    
  
    @IBOutlet var bottomconst: NSLayoutConstraint!
        var ref: DatabaseReference!
    var height1 : Double = 0.0
    var snapshot: DataSnapshot?
    fileprivate var _refHandle: DatabaseHandle?
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    var messages: [DataSnapshot] = []
    var pathmsg : String = ""
    var pathStr : String = ""
    var arrOfMessages = [Any]()
    var arrList = [Any]()
    var msglength: Int = 0
    var userDefaultID1 : String = ""
    var userDefaultName1 : String = ""
    var uniqueId = ""
    var msg = ""
    var pathreceiver : String = ""
    var pathSender : String = ""
    var mdata:[String:AnyObject] = [:]
    var mdata2:[String:AnyObject] = [:]
//    var showKeyboard: Bool = false
    var isPlaceholder: Bool = false
    var placeholderText: String = ""
     var hud: MBProgressHUD?
    //  @IBOutlet var txtmsg: UITextField!
    
    @IBAction func btnback(_ sender: AnyObject) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: chatViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
           }
    @IBOutlet var scrollvw: UIScrollView!
    @IBOutlet var btnsendout: UIButton!
    @IBOutlet var chattblvw: UITableView!
    @IBOutlet var txtmsgvw: UITextView!
    @IBOutlet var chatimgpk: UIImageView!
//MARK: Button Send message action
    @IBAction func btnsend(_ sender: AnyObject) {
         btnsendout.isUserInteractionEnabled = true
        if(txtmsgvw.textColor == UIColor.lightGray){
        if((txtmsgvw.text == "Type message") || (txtmsgvw.text == "") || validate(textView: txtmsgvw)){
            btnsendout.isEnabled = false
            showKeyboard()
            enablebutton()
            txtmsgvw.text = ""
            txtmsgvw.textColor = UIColor.lightGray
            txtmsgvw.text = placeholderText
            txtmsgvw.selectedRange = NSRange(location: 0, length: 0)
            isPlaceholder = true
        }
        }
        else if(txtmsgvw.text == ""){
            btnsendout.isEnabled = false
             showKeyboard()
             enablebutton()
        }
        else if(validate(textView: txtmsgvw)){
             btnsendout.isEnabled = false
             showKeyboard()
             enablebutton()
        }
        else{
             btnsendout.isEnabled = true
            showKeyboard()
            sendMessage()
           // txtmsgvw.beginningOfDocument.accessibilityActivate() = true
           txtmsgvw.selectedTextRange = txtmsgvw.textRange(from: txtmsgvw.beginningOfDocument, to: txtmsgvw.beginningOfDocument)
           
        }
            // chattblvw.reloadData()
           // scheduleNotification()
    }
    
    
    
    
//MARK: Enable button 
    func enablebutton(){
     btnsendout.isEnabled = true
        
    }
    
//MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnsendout.isUserInteractionEnabled = true

      //  navigationitem.title = userDefaultName1
        self.title = userDefaultName1
    
        navigationController?.navigationBar.tintColor = UIColor.white
     navigationController?.navigationBar.barTintColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(183.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0 / 255.0))
        navigationController?.hidesBarsWhenKeyboardAppears = false
        navigationController?.automaticallyAdjustsScrollViewInsets = true
        
  IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses = [NewChatViewController.self]
        //  self.navigationitem.backBarButtonItem?.title = ""
       // navigationItem.backBarButtonItem?.title = ""
        pathStr =  (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.pathStr) as! NSString) as String
        placeholderText = "Type message"
        isPlaceholder = true
        print(txtmsgvw.text)
        txtmsgvw.text = placeholderText
        txtmsgvw.textColor = UIColor.lightGray
        txtmsgvw.selectedRange = NSRange(location: 0, length: 0)
        txtmsgvw.delegate = self
        configureRemoteConfig()
        configureDatabase()
        //scrollToLastRow()
        fetchConfig()
        configureStorage()
       // NotSelectableTextView()
       
       
       
       let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"reloadChatData"),
                       object:nil, queue:nil,
                      using:reloadChatData)
        self.hideKeyboard()
        chattblvw.allowsMultipleSelection = false
        
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        btnsendout.isUserInteractionEnabled = true
//        IQKeyboardManager.sharedManager().enable = false
//        
//        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        //Database.database().isPersistenceEnabled = true
        chatIdNotification = Int(StrUserID)!
//        // chattblvw.reloadData()
        chatIdNotification = (StrUserID as NSString).integerValue
        
//        let nc = NotificationCenter.default // Note that default is now a property, not a method call
//        nc.addObserver(forName:Notification.Name(rawValue:"reloadChatData"),
//                       object:nil, queue:nil,
//                       using:reloadChatData)
      
    }
    override func viewDidAppear(_ animated: Bool) {
        // chattblvw.reloadData()
        chatIdNotification = -1
        
    }
    override func viewWillDisappear(_ animated:Bool){
          NotificationCenter.default.removeObserver(self)
//        IQKeyboardManager.sharedManager().enable = true
//
//        IQKeyboardManager.sharedManager().enableAutoToolbar = true
         chatIdNotification = -1
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            }
    
    deinit {
        if let refHandle = _refHandle  {
            self.ref.child("messages").removeObserver(withHandle: refHandle)
            //   self.ref.child("user").removeObserver(withHandle: refHandle)
        }
    }
    
    
    
//MARK: validate textview
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        
        return true
    }
//MARK: custom method hide keyboard
   func hideKeyboard()
    {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(NewChatViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
           }
    
 
//MARK: custom method to dismiss keyboard
    func dismissKeyboard()
    {
        
        
        view.endEditing(true)
        txtmsgvw.text = "Type message"
        txtmsgvw.textColor = UIColor.lightGray
        
    }
//MARK: custom method show keyboard
    func showKeyboard()
    {
        
        
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(NewChatViewController.Keyboardundismiss))
            view.addGestureRecognizer(tap1)
        
        //self.navigationitem.title = userDefaultName1

    }
//MARK: custom method to undismiss keyboard
    func Keyboardundismiss()
    {
        
        view.endEditing(false)
        
    }
//MARK: reload chat data notification
func reloadChatData(notification:Notification) -> Void {
    var userInfo: [AnyHashable: Any]? = notification.userInfo

            print("in notification")
//  
       StrUserID = userInfo?["id"] as! String
  //  self.navigationItem.title = userInfo?["userName"] as! String?
//        
//        messages = [Any]() as! [DataSnapshot]
//      self.chattblvw.reloadData()
//      configureDatabase()
    }
//MARK: Reload tableview
   func reloadTbl() {
        self.chattblvw?.reloadData()
        // Do any additional setup after loading the view.
    }

//MARK: Textview delegate methods
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
   
      if (text.isEmpty)
  {
    navigationController?.hidesBarsWhenKeyboardAppears = false
    navigationController?.automaticallyAdjustsScrollViewInsets = false
        textView.text = " Type message"
        textView.textColor = UIColor.lightGray
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        return false
   }
        else  if textView.textColor == UIColor.lightGray && !text.isEmpty {
       
            textView.text = nil
            textView.textColor = UIColor.black
        }
    return true
    }
  func textViewDidBeginEditing(_ textView: UITextView) {
   //  navigationitem.title = userDefaultName1

    
    
        btnsendout.isEnabled = true
        if(textView.text == "Type message")
        {
            
           textView.text = ""
        }
        else{
           
            textView.isEditable = true
            textView.isSelectable = true
        }
    let indexPath = messages.count - 1
  
    
    bottomconst.constant = 300
    IQKeyboardManager.sharedManager().enabledDistanceHandlingClasses = [NewChatViewController.self]

           textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        // navigationitem.title = userDefaultName1
       
    
        if((textView.text == "") || (textView.text == "\n") || (textView.text == " ")){
            textView.text = "Type message"
                       textView.textColor = UIColor.lightGray
              btnsendout.isEnabled = false
           showKeyboard()
        }
        else{
           
            textView.isSelectable = true
            btnsendout.isEnabled = true
            }
         bottomconst.constant = 0
        textView.resignFirstResponder()
   }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
//MARK: Textview can perform actions (cut copy paste rights)
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if(txtmsgvw.textColor == UIColor.lightGray){
            OperationQueue.main.addOperation({() -> Void in
                UIMenuController.shared.setMenuVisible(false, animated: false)
            })
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
//MARK: configure database firebase method
func configureDatabase() {
       ref = Database.database().reference()
       ref.keepSynced(true)
       ref.child("messages").child(StrUserID).child(userDefaultID1).observe(.childAdded, with: {(_ snapshot: DataSnapshot) -> Void in
            self.messages.append(snapshot)
            self.chattblvw.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.chattblvw.scrollToRow(at: indexPath, at: .bottom, animated: true)
            //    let notificationName = Notification.Name("menuReload")
            
            //  NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTbl), name: notificationName, object: nil)
            })
         DispatchQueue.main.async{
        //self.chattblvw.reloadData()
       
        }
        
    }
//MARK: custom method to send message
    func sendMessage() {
        let trimmed = txtmsgvw.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //mdata = [AnyHashable: Any]()
        //   mdata["msg"] = txtmsgvw.text as AnyObject?
        mdata["msg"] = trimmed as AnyObject?
        print(txtmsgvw.text)
        let defaults = UserDefaults.standard
        let senderpath1 = defaults.string(forKey:"path1")!
        let StrUserName1 = defaults.string(forKey:"first_name")!
        mdata["senderName"] = StrUserName1 as AnyObject?
        mdata["senderImage"] = senderpath1 as AnyObject?
        mdata["userType"] = "SENDER" as AnyObject?
        mdata["notificationFlage"] = "true" as AnyObject?
        mdata["seen"] = "true" as AnyObject?
        mdata["receiverName"] = userDefaultName1 as AnyObject?
        mdata["receiverImage"] = pathreceiver as AnyObject?
        let myDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString: String = dateFormatter.string(from: myDate)
        mdata["date"] = dateString as AnyObject?
        let myTime = Date()
        dateFormatter.dateFormat = "hh:mm"
        let TimeString: String = dateFormatter.string(from: myTime)
        mdata["time"] = TimeString as AnyObject?
        let uDate = Date()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "ddMMyyHHmmss"
        let dateString1: String = dateFormatter1.string(from: uDate)
        mdata2["updatedTime"] = dateString1 as AnyObject?
        mdata2["userId"] = userDefaultID1 as AnyObject?
        let now = Date()
        let formatter = DateFormatter()
        let formatString: String = "ddMMyyyyHHmmssSSS"
        formatter.dateFormat = formatString
        let date: String = "\(formatter.string(from: now))"
        ref.child("messages").child(StrUserID).child(userDefaultID1).child(date).updateChildValues(mdata)
        ref.child("user").child(StrUserID).child(userDefaultID1).updateChildValues(mdata2)
        mdata["receiverName"] = userDefaultName1 as AnyObject?
        mdata["userType"] = "RECEVIER" as AnyObject?
        mdata["notificationFlage"] = false as AnyObject?
        mdata["seen"] = false as AnyObject?
        mdata["senderName"] =  StrUserName1  as AnyObject?
        mdata["receiverImage"] = pathreceiver as AnyObject?
        mdata["senderImage"] =  senderpath as AnyObject?
        // mdata["senderImage"] =  pathStr as AnyObject?
        ref.child("messages").child(userDefaultID1).child(StrUserID).child(date).updateChildValues(mdata)
        ref.child("user").child(userDefaultID1).child(StrUserID).updateChildValues(mdata2)
        txtmsgvw.text = ""
        txtmsgvw.textColor = UIColor.lightGray
        txtmsgvw.text = placeholderText
        txtmsgvw.selectedRange = NSRange(location: 0, length: 0)
        isPlaceholder = true
    }
    
//MARK: Table view delegate methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell :newchatcellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "sendercell") as! newchatcellTableViewCell
        // cell.awakeFromNib()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if(((messages[indexPath.row].value! as! [String:AnyObject]) ["userType"])! as! String == "SENDER")
        {
            DispatchQueue.main.async{
                cell.lblmsg1?.text = (((self.messages[indexPath.row].value! as! [String:AnyObject])["msg"])! as? String)!
                cell.sendertime?.text = (((self.messages[indexPath.row].value! as! [String:AnyObject])["time"])! as? String)!
                cell.newchatbg.layer.cornerRadius = 10
                cell.newchatbg.layer.masksToBounds = true
                let strurl = ((self.messages[indexPath.row].value! as! [String:AnyObject])["senderImage"])! as? String
                let url = NSURL(string:strurl!)!
                cell.sendertblvwcellimg.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "profile_placeholder"))
                cell.sendertblvwcellimg.layer.cornerRadius =
                    cell.sendertblvwcellimg.frame.size.width/2
                cell.sendertblvwcellimg.layer.masksToBounds = true
                cell.sendertblvwcellimg.layer.borderColor = UIColor.black.cgColor
                cell.sendertblvwcellimg.layer.borderWidth = 1
                cell.layoutIfNeeded()
               
            }
            return cell
        }
        else {
            let cell :ReceiverTableViewCell = tableView.dequeueReusableCell(withIdentifier: "receivercell") as! ReceiverTableViewCell
            
            //cell.awakeFromNib()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            DispatchQueue.main.async{
                cell.lblmsg2.text =  ((self.messages[indexPath.row].value! as! [String:AnyObject])["msg"])! as? String
                cell.receivertblvwcelltime?.text = ((self.messages[indexPath.row].value! as! [String:AnyObject])["time"])! as? String
                cell.receivertblvwcellimg.layer.cornerRadius = cell.receivertblvwcellimg.frame.size.width/2
                cell.imgbg.layer.cornerRadius = 10
                cell.imgbg.layer.masksToBounds = true
                
                //   let strurl1 = ((self.messages[indexPath.row].value! as! [String:AnyObject])["senderImage"])! as? String
                
                let strurl1 = ((self.messages[indexPath.row].value! as! [String:AnyObject])["senderImage"])! as? String
                let url1 = NSURL(string: strurl1!)!
                cell.receivertblvwcellimg.sd_setImage(with: url1 as URL?, placeholderImage: UIImage(named: "profile_placeholder"))
                cell.receivertblvwcellimg.layer.masksToBounds = true
                cell.receivertblvwcellimg.layer.borderColor = UIColor.black.cgColor
                cell.receivertblvwcellimg.layer.borderWidth = 1
                cell.layoutIfNeeded()
            
            }
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height:CGFloat = self.calculateHeight(inString: (((self.messages[indexPath.row].value! as! [String:AnyObject])["msg"])! as? String)!)
        return height + 50
    }
//MARK: custom method to calculate height of dynamic table view cell controllers
    func calculateHeight(inString:String) -> CGFloat
    {
        
        let messageString = inString
        let attributes : [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 14)]
        
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: self.view.frame.size.width*0.68, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }

//MARK: configure remote firebase
    func configureRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
    }

//MARK: Firebase fetch config
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
//MARK: Firebase configure storage
    func configureStorage() {
        storageRef = Storage().reference()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


