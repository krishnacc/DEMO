//
//  chatViewController.swift
//  ATChat
//
//  Created by komal on 3/22/17.
//  Copyright © 2017 komal. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth
import FirebaseAnalytics
import FirebaseRemoteConfig
import FirebaseStorage
var allchat = [[String : AnyObject]]()
var userDefaultID : String = ""
var userDefaultName : String = ""
var path1: String = ""
var idArr = NSArray()
var strUrl: NSString!
class chatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var backStr = NSString()
    var ref: DatabaseReference!
    var hud: MBProgressHUD?
    fileprivate var _refHandle: DatabaseHandle?
    var snapshot: DataSnapshot?
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    var user:[DataSnapshot]! = []
    var mdata2 = [AnyHashable:Any]()
    var sortedArray = [[String:AnyObject]]()
    var messages = [DataSnapshot]()
    var childdata : NSDictionary = [:]
    var emailArray = [[String:AnyObject]]()
    var db: NSDictionary = NSDictionary()
    var msglength: Int = 0
    var arrResult = [[String:AnyObject]]()
    var isMychat: Bool = true
    @IBOutlet var lblChatAvailable: UILabel!
    @IBOutlet var imgUnselectedMyChat: UIImageView!
    @IBOutlet var imgUnselectedAllChat: UIImageView!
    @IBOutlet var imgSelectedMyChat: UIImageView!
    @IBOutlet var imgSelectedAllChat: UIImageView!
    @IBOutlet var chatfetchallchatusers: UITableView!
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imgSelectedAllChat.isHidden = true
        self.ws1()
        lblChatAvailable.isHidden = true
        self.setNavigationBarItem()
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"reloadChatData"),
                       object:nil, queue:nil,
                       using:reloadChatData)
        chatfetchallchatusers.allowsMultipleSelection = false
    }
//    func receiveTestNotification(notification:Notification) -> Void {
//        var userInfo: [AnyHashable: Any]? = notification.userInfo
//        print("in notification")
//        //segue perform
//   }
    func reloadChatData(notification:Notification) -> Void {
        print("in notification")
    }
   override func viewWillAppear(_ animated: Bool) {
        if(isMychat == true){
            //Database.database().isPersistenceEnabled = true
            chatfetchallchatusers.allowsMultipleSelection = false
            chatfetchallchatusers.allowsSelection = true
            configureRemoteConfig()
            configureDatabase()
            fetchConfig()
            configureStorage()
            // chatfetchallchatusers.reloadData()
                   }
        else{
            self.ws1()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        if let refHandle = _refHandle  {
            self.ref.child("user").removeObserver(withHandle: refHandle)
        }
    }
//MARK: Configure Storage Firebase
    func configureStorage() {
        storageRef = Storage().reference()
    }
    override func setNavigationBarItem() {
        self.title = "Chat"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.addLeftBarButtonWithImage((UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal))!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
//MARK: - custom Button MYChat
    @IBAction func onBtnMyChat(_ sender: AnyObject) {
      // arrResult = [[String:AnyObject]]()
        imgSelectedMyChat.isHidden = false
        imgSelectedAllChat.isHidden = true
        isMychat = true
        configureDatabase()
      chatfetchallchatusers.delegate = self
      chatfetchallchatusers.dataSource = self
      chatfetchallchatusers.reloadData()
    }
//MARK: - custom Button AllChat
    @IBAction func onBtnAllChat(_ sender: AnyObject) {
        self.lblChatAvailable.isHidden = true
        self.chatfetchallchatusers.isHidden = false
        
        imgSelectedMyChat.isHidden = true
        imgSelectedAllChat.isHidden = false
        isMychat = false
        //        ws1()
        chatfetchallchatusers.delegate = self
        chatfetchallchatusers.dataSource = self
        chatfetchallchatusers.reloadData()
    }

    @IBAction func Allchatbtnac(_ sender: AnyObject) {
        
    }
//MARK: New chat button action
    @IBAction func btnnewchatction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let NewChatViewController1 = storyBoard.instantiateViewController(withIdentifier:
            "NewChatViewController") as! NewChatViewController
        self.present(NewChatViewController1, animated:true, completion:nil)
    }
//MARK : Configure Databse Firebase
    func configureDatabase(){
               arrResult = [[String:AnyObject]]()
        ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("user").observeSingleEvent(of: .value, with: { (snapshot) in
        if snapshot.hasChild(StrUserID!){
        self.ref.child("user").child(StrUserID).observeSingleEvent(of: .value, with: { (snapshot) in
//                    self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//                    self.hud?.label.text = "Loading"
                if snapshot.exists() {
                    self.childdata = snapshot.value!  as! NSDictionary
                        print(self.childdata)
                        var temarray = [[String:AnyObject]]()
                        for i in 0 ..< self.childdata.count
                        {
                            temarray.append(self.childdata[self.childdata.allKeys[i]] as! [String : AnyObject])
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "ddMMyyHHmmss"
                        self.sortedArray  = temarray.sorted {
                            (dictOne, dictTwo) -> Bool in
                            let d1 = dateFormatter.date(from: (dictOne["updatedTime"]! as! String))
                            let d2 = dateFormatter.date(from: (dictTwo["updatedTime"]! as! String))
                            return d1! > d2!
                        }
                        print(self.sortedArray)
                        print(allchat)
                        for i in 0..<self.sortedArray.count {
                            let data = self.sortedArray[i]
                            let userid = Int(data["userId"]! as! String)!
                            print(userid)
                            for j in 0..<allchat.count {
                                let data = allchat[j]
                                let id = Int(data["id"]! as! String)!
                                print(id)
                                if (userid == id){
                                    self.arrResult.append(allchat[j])
                                    print(self.arrResult)
                                    self.hud?.hide(animated: true)

                                }
                            }
                        }
                        print(self.arrResult)
                            self.hud?.hide(animated: true)
                        self.chatfetchallchatusers.delegate = self
                        self.chatfetchallchatusers.dataSource = self
                        self.chatfetchallchatusers.reloadData()
                   }
                    else{
                            self.hud?.hide(animated: true)
                        self.lblChatAvailable.isHidden = false
                        self.chatfetchallchatusers.isHidden = true
                    }
                    
                }) { (error) in
                    self.hud?.hide(animated: true)

                    print(error.localizedDescription)
                }
                print("true rooms exist")
                
            }else{
                 self.hud?.hide(animated: true)
                self.lblChatAvailable.isHidden = false
                self.chatfetchallchatusers.isHidden = true
                print("false room doesn't exist")
            }
       })
    }
//MARK: Webservice call all chat fetch all registered users
    func ws1()
    {
         if ConnectionCheck.isConnectedToNetwork() {
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.label.text = "Loading"
        ApiCall.sharedInstance.requestGetMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_fetchalluser")
        {
            (success, responseData) in
            print(responseData ?? AnyObject.self)
            DispatchQueue.main.async {
                print(responseData?["data"])
                path1 = responseData?["path"]! as! String
                allchat = responseData?["data"]!  as!   [[String : AnyObject]]
                
                Constants().setUserDefault(ObjectToSave: path1 as AnyObject?, KeyToSave: Constants.ApiConstants.pathStr)
                let defaults = UserDefaults.standard
                let strEmail = defaults.string(forKey:"email")
                //let path = defaults.string(forKey: "path")
                for i in 0..<allchat.count {
                    var data1 = allchat[i]
                    let email1 = (data1["email_id"]! as! String)
                    print(email1)
                    if(strEmail == email1){
                        allchat.remove(at:i)
                        break;
                      //  print(allchat)
                    }
                }
                self.hud?.hide(animated: true)
                self.chatfetchallchatusers.delegate = self
                self.chatfetchallchatusers.dataSource = self
                self.chatfetchallchatusers.reloadData()
            }
        }
        }
        else
         {
            JLToast.makeText("please check your internet connection").show()
        }
    }
    
//MARK : configure remoteconfig firebase
    func configureRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
    }
//MARK: fetch config firebase
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
//MARK: - TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if(isMychat == true){
            return arrResult.count
        }
        else{
            return allchat.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :ChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatTableViewCell
        if(isMychat == true){
              DispatchQueue.main.async {
                 self.chatfetchallchatusers.allowsMultipleSelection = false
            cell.lblname.text = (self.arrResult[indexPath.row]as AnyObject).value(forKey:"first_name")as? String
            cell.lblemail.text = (self.arrResult[indexPath.row]as AnyObject).value(forKey:"email_id")as? String
            let strurl = "\(path1)\(((self.arrResult[indexPath.row] as AnyObject).value(forKey:"image")as? String)!)"
            let url = NSURL(string: strurl)!
            cell.imgvw.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "profile_placeholder"))
            cell.imgvw.layer.cornerRadius = cell.imgvw.frame.size.width/2
            cell.imgvw.clipsToBounds = true
            cell.imgvw.layer.borderColor = UIColor.black.cgColor
            cell.imgvw.layer.borderWidth = 1
            }
        }
        else{
              DispatchQueue.main.async {
            cell.lblname.text = (allchat[indexPath.row]as AnyObject).value(forKey:"first_name")as? String
            cell.lblemail.text = (allchat[indexPath.row]as AnyObject).value(forKey:"email_id")as? String
            let strurl = "\(path1)\(((allchat[indexPath.row] as AnyObject).value(forKey:"image")as? String)!)"
            let url = NSURL(string: strurl)!
            cell.imgvw.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "profile_placeholder"))
            cell.imgvw.layer.cornerRadius = cell.imgvw.frame.size.width/2
            cell.imgvw.clipsToBounds = true
            cell.imgvw.layer.borderColor = UIColor.black.cgColor
            cell.imgvw.layer.borderWidth = 1
           }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let myVC = storyBoard.instantiateViewController(withIdentifier: "NewChatViewController") as! NewChatViewController
        if(isMychat == true){
             self.chatfetchallchatusers.allowsMultipleSelection = false
            self.chatfetchallchatusers.allowsSelection = false
             DispatchQueue.main.async {
                self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                self.hud?.label.text = "Loading"
            let strchatIDs = (self.arrResult[indexPath.row] as AnyObject).value(forKey: "id")!
            let defaults = UserDefaults.standard
            defaults.set(strchatIDs, forKey: "selectid")
            let strchatname = (self.arrResult[indexPath.row] as AnyObject).value(forKey: "first_name")
            let receiverpath = "\(path1)\(((self.arrResult[indexPath.row] as AnyObject).value(forKey:"image")as? String)!)"
            let senderpath = "\(path1)\(((self.arrResult[indexPath.row] as AnyObject).value(forKey:"image")as? String)!)"
            self.hud?.hide(animated: true)
            //     Noteid = strNoteID
            // myVC.userDefaultID1 = strchatIDs as! String
            myVC.userDefaultID1 = strchatIDs as! String
            myVC.userDefaultName1 = strchatname as! String
            myVC.pathreceiver = receiverpath
            myVC.pathSender = senderpath
           //  self.present(myVC, animated:true, completion:nil)
            self.navigationController?.pushViewController(myVC, animated: true)
               
              // self.present(myVC, animated:true, completion:nil)
            }
            
        }
        else{
            DispatchQueue.main.async {
            let strchatIDs = (allchat[indexPath.row] as AnyObject).value(forKey: "id")!
            let defaults = UserDefaults.standard
            defaults.set(strchatIDs, forKey: "selectid")
            let strchatname = (allchat[indexPath.row] as AnyObject).value(forKey: "first_name")
            let receiverpath = "\(path1)\(((allchat[indexPath.row] as AnyObject).value(forKey:"image")as? String)!)"
            let senderpath = "\(path1)\(((allchat[indexPath.row] as AnyObject).value(forKey:"image")as? String)!)"
            //     Noteid = strNoteID
            // myVC.userDefaultID1 = strchatIDs as! String
            myVC.userDefaultID1 = strchatIDs as! String
            myVC.userDefaultName1 = strchatname as! String
            myVC.pathreceiver = receiverpath
            myVC.pathSender = senderpath
            //            self.present(myVC, animated:true, completion:nil)
            self.navigationController?.pushViewController(myVC, animated: true)
               
               // self.present(myVC, animated:true, completion:nil)
            }
        }
    }
}
extension chatViewController : SlideMenuControllerDelegate {
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
