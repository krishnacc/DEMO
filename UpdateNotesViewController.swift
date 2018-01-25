//
//  UpdateNotesViewController.swift
//  ATChat
//
//  Created by komal on 3/31/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit
//MARK: Global variable
let Noteid : String = ""

class UpdateNotesViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
//MARK: OUTLET
    @IBOutlet var txtnotename: UITextField!
    @IBOutlet var txtnotedis: UITextView!
    var strNoteId = ""
    var hud: MBProgressHUD?
    @IBOutlet var btnoutupdate: UIButton!
    
    @IBOutlet var btnoutdelete: UIButton!

    @IBOutlet var navview: UIView!
    @IBOutlet var navbar: UINavigationBar!
    
//MARK: Application life cycle didload
    override func viewDidLoad() {
        super.viewDidLoad()
       txtnotedis.delegate = self
       txtnotename.delegate = self
// n.navigationBar.barTintColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(183.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0 / 255.0))        self.hideKeyboard()
      
        navbar.barTintColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(183.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0 / 255.0))
//        navview.backgroundColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(183.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0 / 255.0))
        
        navview?.backgroundColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(183.0 / 255.0), blue: CGFloat(100.0 / 255.0), alpha: CGFloat(1.0 / 255.0))
        
        if ConnectionCheck.isConnectedToNetwork(){
            
        }
            
        else{
            JLToast.makeText("Check your conncection").show()
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        }
    override func viewDidLayoutSubviews() {
        btnoutupdate.layer.cornerRadius = 12
        btnoutupdate.layer.masksToBounds = true
        btnoutdelete.layer.cornerRadius = 12
        btnoutdelete.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        arrData.removeAll()
    }
    
//MARK: textfield should return delegate method
    func textFieldShouldReturn (_ textField: UITextField) -> Bool{
        if ((textField == txtnotename)){
            txtnotedis.becomeFirstResponder();
            
        }
        else{
            textField.resignFirstResponder();
        }
        return true
        
    }
    
//MARK: textview should return delegate method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
//MARK: Back button action
    @IBAction func onbtnBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {
        });
    }
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UpdateNotesViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
  
//MARK: update button action
    @IBAction func btnupdate(_ sender: AnyObject) {
        if ConnectionCheck.isConnectedToNetwork(){
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.label.text = "Loading"
             StrUserID =     (UserDefaults.standard.value(forKey: "id")) as! String
        let postString = "user_id=\(StrUserID!)&title=\(txtnotename.text!)&description=\(txtnotedis.text!)&note_id=\(strNoteId)"
        let paramData = postString.data(using: .utf8)
        ApiCall.sharedInstance.requestPostMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_editnote", params: paramData!)
        {
            (success, responseData) in
            print(responseData ?? AnyObject.self)
            let strstatus = (responseData? ["status"]) as! NSString
            // let strmsg  = (responseData? ["message"]) as! NSString
            
            if(strstatus=="error")
            {
                  DispatchQueue.main.async{
                 self.hud?.hide(animated: true)
               // JLToast.makeText(strstatus as String).show()
                let alert = UIAlertController(title: "Update Note", message: strstatus as String, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.dismiss(animated: true, completion: {});

                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                  DispatchQueue.main.async{
                 self.hud?.hide(animated: true)
                // JLToast.makeText("Note updated successfully").show()
                let alert = UIAlertController(title: "Update Note", message: "Note updated successfully" as String, preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.dismiss(animated: true, completion: {});

                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                           }
            }
        }
        }
        else{
            JLToast.makeText("Check your conncection").show()
            }
    }
//MARK: delete button action
    @IBAction func btndeleteacc(_ sender: AnyObject) {
        if ConnectionCheck.isConnectedToNetwork(){

            let alert = UIAlertController(title: "",
                                          message: "",
                                          preferredStyle: .alert)
        // Change font of the title and message
          //  let titleFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "AmericanTypewriter", size: 18)! ]
         //   let messageFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
           // let attributedTitle = NSMutableAttributedString(string: "Are you sure you want to delete note ??", attributes: titleFont)
         let attributedTitle = NSMutableAttributedString(string: "Are you sure you want to delete note ??")
            alert.setValue(attributedTitle, forKey: "attributedTitle")
            let action1 = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                self.hud?.label.text = "Loading"
                StrUserID = (UserDefaults.standard.value(forKey: "id")) as! String
                StrUserID = (UserDefaults.standard.value(forKey: "id")) as! String
                let postString = "user_id=\(StrUserID!)&note_id=\(self.strNoteId)"
                let paramData = postString.data(using: .utf8)
                ApiCall.sharedInstance.requestPostMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_deletenote", params: paramData!)
                {
                    (success, responseData) in
                    print(responseData ?? AnyObject.self)
                    //JLToast.makeText("deleted successfully").show()
                     DispatchQueue.main.async{
                     self.hud?.hide(animated: true)
                    let alert = UIAlertController(title: "Delete notes", message: "Note deleted successfully" as String, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                         self.dismiss(animated: true, completion: {});
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            })
            let action2 = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
                print("ACTION 2 selected!")
            })
            // Add action buttons and present the Alert
            alert.addAction(action1)
            alert.addAction(action2)
        
           // alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
        }
        else{
             JLToast.makeText("Check your conncection").show()
        }
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
