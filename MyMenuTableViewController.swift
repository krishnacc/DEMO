//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseRemoteConfig
import FirebaseStorage

var password : String = ""
var phoneno : String = ""
var dictData : NSDictionary = [:]
var email : String = ""
var psw : String = ""
var arrCategory = [[String:AnyObject]]()
var mdata = [AnyHashable: Any]()
var ref: DatabaseReference!
var user: [DataSnapshot]! = []


class MyMenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet var lblsurname: UILabel!
    @IBOutlet var lblname: UILabel!
    @IBOutlet var lblemail: UILabel!
    @IBOutlet var phoneno: UILabel!
    @IBOutlet var mypropic: UIImageView!
    
    var AryVCnames:[String] = ["Chat","Notes","Settings","About Chatt","Log Out"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let blackcolor = UIColor(red: 0/255.0, green: 183/255.0, blue:100/255.0, alpha: 1.0)
    let objViewControllerMain = ViewController()
    var aryImagesBlack:[String] = ["ic__0003_chat","ic__0002_notes", "ic__0004_settings","ic__0000_about_chat","ic__0005_logout"]
    var selectedMenuItem : Int = 0
    
// Mark : Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      //  wsFetchUser()
        view.backgroundColor = blackcolor
        tableView?.backgroundColor = blackcolor
        // Customize apperance of table view
        tableView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        // tableView?.separatorStyle = .none
        tableView?.backgroundColor = blackcolor
        tableView?.scrollsToTop = false
        tableView?.tableFooterView = UIView()
        // Preserve selection between presentations
        _ = IndexPath(row: 0, section: 0)
        //        self.tableView?.estimatedRowHeight = 300
        //        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.reloadData()
        // wsFetchUser()
    }
    override func viewWillAppear(_ animated: Bool) {
        wsFetchUser()
        // strNoNotes    = (UserDefaults.standard.value(forKey: "notess")) as! String
        //   self.tableView?.reloadData()
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
          wsFetchUser()
    }
    override func viewDidLayoutSubviews() {
        
        mypropic.layer.cornerRadius = mypropic.frame.size.width/2
        mypropic.clipsToBounds = true
        mypropic.layer.borderColor = UIColor.black.cgColor
        mypropic.layer.borderWidth = 1
    }
//MARK: Webservice call fetch user
    func wsFetchUser() {
        if ConnectionCheck.isConnectedToNetwork(){
            
            //StrUserID = (UserDefaults.standard.value(forKey: "id"))
            let postString = "user_id=\(StrUserID!)"
            
            let paramData = postString.data(using: .utf8)
            ApiCall.sharedInstance.requestPostMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_fetchuser", params: paramData!) { (success, responseData) in            print(responseData ?? AnyObject.self)
                let strstatus = (responseData? ["code"]!) as! Int
                if strstatus == 0
                {
                    DispatchQueue.main.async{
                        JLToast.makeText("no user found").show()
                    }           }
                else{
                    
                    let path = responseData?["path"]!  as! String
                    arrCategory = responseData?["data"]!  as! [[String : AnyObject]]
                    print(arrCategory)
                    DispatchQueue.main.async{
                        let name = (arrCategory[0] as AnyObject).value(forKey: "first_name") as? String
                        let email = (arrCategory[0] as AnyObject).value(forKey: "email_id") as? String
                         self.lblemail.text = email!
                        let surname = (arrCategory[0] as AnyObject).value(forKey: "last_name")as? String
                        self.lblname.text = name! + " " + surname!

                        let strUrl = "\(path)\(((arrCategory[0] as AnyObject).value(forKey:"image") as?  String)!)"
                        let url = NSURL(string: strUrl)
                            self.mypropic.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "profile_placeholder"))
                            self.tableView?.delegate = self
                            self.tableView?.dataSource = self
                            self.tableView?.reloadData()
                       
                    }
                    
                }
                
            }
        }
        else{
            JLToast.makeText("Check your conncection").show()
        }
    }
//MARK: set navigation bar left and right bar buttons
    override func setNavigationBarItem() {
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.yellow]
        
        self.addLeftBarButtonWithImage((UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal))!)
        self.addRightBarButtonWithImage((UIImage(named:"ic_search")?.withRenderingMode(.alwaysOriginal))!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK: configure database firebase
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        /* _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
         
         })*/
        ref.keepSynced(true)
        
        ref.child("tokens").child(StrUserID).observe(.childAdded, with: {(_ snapshot: DataSnapshot) -> Void in
            user.append(snapshot)
            // NSDictionary *dic = ;
            // NSLog(@"%@",snapshot.key);
        })
        
    }
    
// MARK: - Table view Methods
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return AryVCnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :sidebarcell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! sidebarcell
        
        cell.lbl_sidebar.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        cell.backgroundColor = blackcolor
        cell.img_sidebar.image = UIImage(named:aryImagesBlack[indexPath.row])
        cell.selectionStyle = .none
        //  let defaults = UserDefaults.standard
        //strNoNotes    = (UserDefaults.standard.value(forKey: "notess")) as! String
        if (indexPath.row == 1){
            //   cell.lbl_sidebar.text = AryVCnames[indexPath.row] + "                   ()"
            cell.lbl_sidebar.text = AryVCnames[indexPath.row] + "                   "
            if strNoNotes > 0 {
                cell.lbl_sidebar.text = AryVCnames[indexPath.row] + "                   (" + String(strNoNotes) + ")"
                
            }
        }
        else{
            cell.lbl_sidebar.text = AryVCnames[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select row: \(indexPath.row)")
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
            
        case 0:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "chatViewController") as! chatViewController
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "AboutChattViewController") as! AboutChattViewController
            break
        case 4:
            deviceToken = UserDefaults.standard.object(forKey: "MyAppDeviceToken") as! String
            self.configureDatabase()
            /*       deviceToken = UserDefaults.standard.object(forKey: "MyAppDeviceToken") as! String*/
            
            mdata["deviceType"] = "IOS"
            mdata["deviceToken"] = " "
            mdata["userActive"] = "true"
            mdata["userDeleted"] = "false"
            ref.child("tokens").child(StrUserID).updateChildValues(mdata)
            
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            if (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.issignedin) as? String) != nil {
                if (Constants().getUserDefault(KeyToReturnValye: Constants.ApiConstants.issignedin) as? String)! == "YES"
                {
                    
                }
                else{
                    Constants().setUserDefault(ObjectToSave: "" as AnyObject?, KeyToSave: Constants.ApiConstants.paramEmail)
                }
            }
            
            Constants().setUserDefault(ObjectToSave: "" as AnyObject?, KeyToSave: Constants.ApiConstants.paramPassword)
            Constants().setUserDefault(ObjectToSave: "" as AnyObject?, KeyToSave: Constants.ApiConstants.ParamuserID)
            //
            //            cell1.lbl_sidebar.textColor = UIColor.white
            //            cell1.img_sidebar.image = UIImage.init(named: AryForUserLogin[indexPath.row])
            selectedMenuItem = 4
            break
        default:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "chatViewController") as! chatViewController
            
            selectedMenuItem = 0
            
            break
        }
        let nvc: UINavigationController = UINavigationController(rootViewController: destViewController)
        nvc.navigationBar.barTintColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(183.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0 / 255.0))
        
        self.slideMenuController()?.changeMainViewController(nvc, close: true)
        
    }
}
