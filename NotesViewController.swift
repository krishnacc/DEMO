//
//  NotesViewController.swift
//  ATChat
//
//  Created by komal on 3/22/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit
var arrData = [[String:AnyObject]]()

//MARK: GLOBAL VARIABLE
var strNoNotes : Int = 0
class NotesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    //MARK: OUTLET
    @IBOutlet var lblNoNotes: UILabel!
    @IBOutlet var tablevw: UITableView!
    @IBOutlet var btn : UIBarButtonItem!
    //MARK: Application life cycle didload
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.ws()
        lblNoNotes.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.ws()
        //        self.tablevw.delegate = self
        //        self.tablevw.dataSource = self
        self.tablevw.reloadData()
    }
    
    //MARK: Fetch note Webservice call
    func ws()
    {
        if ConnectionCheck.isConnectedToNetwork(){
             StrUserID =     (UserDefaults.standard.value(forKey: "id")) as! String
            let postString = "user_id=\(StrUserID!)"
            let paramData = postString.data(using: .utf8)
            ApiCall.sharedInstance.requestPostMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_fetchnote", params: paramData!) { (success, responseData) in
                print(responseData ?? AnyObject.self)
                DispatchQueue.main.async{
                    let strstatus = (responseData? ["status"]) as! NSString
                    if(strstatus == "error")
                    {
                        //   DispatchQueue.main.async{
                        self.tablevw.isHidden = true
                        self.lblNoNotes.isHidden = false
                        
                        strNoNotes =  arrData.count
                        if strNoNotes > 0 {
                            self.btn = UIBarButtonItem(title: " (" + String(strNoNotes) + ")" , style: .plain, target: self, action: nil)
                        }
                        else {
                            self.btn = UIBarButtonItem(title: "" , style: .plain, target: self, action: nil)
                        }
                    }
                    else{
                        //   DispatchQueue.main.async {
                        self.tablevw.isHidden = false
                        self.lblNoNotes.isHidden = true
                        
                        arrData = responseData?["data"]  as! [[String : AnyObject]]
                        print(arrData)
                        self.tablevw.delegate = self
                        self.tablevw.dataSource = self
                        self.tablevw.reloadData()
                       
                        strNoNotes =  arrData.count
                        if strNoNotes > 0 {
                            self.btn = UIBarButtonItem(title: " (" + String(strNoNotes) + ")" , style: .plain, target: self, action: nil)
                        }
                        else {
                            self.btn = UIBarButtonItem(title: "" , style: .plain, target: self, action: nil)
                        }
                    }
                    self.navigationItem.rightBarButtonItem = self.btn
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                    //  self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
        }
            
        else{
            JLToast.makeText("Check your conncection").show()
        }
        
    }
    //MARK: Create note button action
    @IBAction func createnotebtnac(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MakeNoteViewController") as! MakeNoteViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    //MARK: Table view Number of rows in section delegate method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arrData.count
    }
    //MARK: Table View Cell for row at index path delgate method added notes
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :NotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotesTableViewCell
        
//        let dictTemp = (arrData[0] as AnyObject).value(forKey: "id")
        
        // cell.lblnotesname.text! = ((arrData[indexPath.row] as AnyObject).value(forKey:"title") as? String)!
        //cell.lblnotesname.text! = ((arrData[indexPath.row] as AnyObject).value(forKey:"description") as? String)!
        cell.lblnotesname.text = (arrData[indexPath.row]as AnyObject).value(forKey:"title")as? String
        cell.lbldisc.text = (arrData[indexPath.row]as AnyObject).value(forKey:"description")as? String
        return cell
    }
    //MARK: Table View did select row at index path method delegate method to update notes
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let myVC = storyBoard.instantiateViewController(withIdentifier: "UpdateNotesViewController") as! UpdateNotesViewController
        self.present(myVC, animated:true, completion:nil)
        //  self.navigationController?.pushViewController(myVC, animated: true)
        myVC.txtnotename.text = (arrData[indexPath.row] as AnyObject).value(forKey:"title") as? String
        myVC.txtnotedis.text = (arrData[indexPath.row] as AnyObject).value(forKey:"description") as? String
        let strNoteIDs = (arrData[indexPath.row] as AnyObject).value(forKey: "id")
        //     Noteid = strNoteID
        myVC.strNoteId = strNoteIDs as! String
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension NotesViewController : SlideMenuControllerDelegate {
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

extension UIViewController {
    
    func setNavigationBarItem() {
        self.title = "Notes"
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.addLeftBarButtonWithImage((UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal))!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
}

