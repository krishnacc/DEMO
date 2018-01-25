//
//  MakeNoteViewController.swift
//  ATChat
//
//  Created by komal on 3/30/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit
class MakeNoteViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
let appDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: OUTLET
    @IBOutlet var txtemaildescnote: UITextView!
    @IBOutlet var txtemailnote: UITextField!
    @IBOutlet var btnoutaddnotes: UIButton!
    var hud: MBProgressHUD?
//MARK: Application lifecycle didload
    override func viewDidLoad() {
        super.viewDidLoad()
        txtemailnote.delegate = self
        txtemaildescnote.delegate = self
        self.hideKeyboard()
       
        // Do any additional setup after loading the view.
    }
//    override func viewDidAppear(_ animated: Bool) {
//        
//        btnoutaddnotes.layer.cornerRadius = 12
//        btnoutaddnotes.layer.masksToBounds = true
//        
//    }
    override func viewDidLayoutSubviews() {
        btnoutaddnotes.layer.cornerRadius = 12
        btnoutaddnotes.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    //MARK: textfield should return delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MakeNoteViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
//MARK textview should return delegate method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
//MARK: Back button action
    @IBAction func onBtnBack(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
//MARK: Done button action
    @IBAction func btnDoneac(_ sender: AnyObject) {
        if ConnectionCheck.isConnectedToNetwork(){
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.label.text = "Loading"
        StrUserID =     (UserDefaults.standard.value(forKey: "id")) as! String
        //self.navigationController?.popViewController(animated: true)
        let postString = "user_id=\(StrUserID!)&title=\(txtemailnote.text!)&description=\(txtemaildescnote.text!)"
        let paramData = postString.data(using: .utf8)
        ApiCall.sharedInstance.requestPostMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_addnote", params: paramData!)
        {
            (success, responseData) in
            print(responseData ?? AnyObject.self)
            let strstatus = (responseData? ["status"]) as! NSString
            // let strmsg  = (responseData? ["message"]) as! NSString
           if(strstatus=="error")
            {
                 DispatchQueue.main.async{
                self.hud?.hide(animated: true)
                let alert = UIAlertController(title: "Add notes", message: strstatus as String, preferredStyle: UIAlertControllerStyle.alert)
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
       // JLToast.makeText("Note Added successfully" as String).show()
                let alert = UIAlertController(title: "Add notes", message: "Note added successfully" as String, preferredStyle: UIAlertControllerStyle.alert)
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

