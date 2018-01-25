//
//  ForgetPasswordViewController.swift
//  ATChat
//
//  Created by komal on 3/24/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit
//import Parse
class ForgetPasswordViewController: UIViewController {
    var hud: MBProgressHUD?
//MARK: outlets
    @IBOutlet var btnsuboutfor: UIButton!
    @IBOutlet var txtforgeteid: UITextField!

//Application life cycle did load
 override func viewDidLoad() {
        super.viewDidLoad()
        self.setupemailField()
         }
    override func viewWillAppear(_ animated: Bool) {
    }
//MARK: Textfield set up
    
    func setupemailField() {
        let imageView = UIImageView()
        let leftV = UIView()
        txtforgeteid.attributedPlaceholder = NSAttributedString(string: "Email id",
                                                        attributes: [NSForegroundColorAttributeName: UIColor.black])
        leftV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let image = UIImage(named: "ic_email-1.png")
        imageView.image = image
        leftV.addSubview(imageView)
        txtforgeteid.leftView = leftV
        txtforgeteid.leftViewMode = UITextFieldViewMode.always
    }
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
    override func viewDidLayoutSubviews() {
        btnsuboutfor.layer.cornerRadius = 12
        btnsuboutfor.layer.masksToBounds = true
    }
//MARK: Back button action
@IBAction func backbutton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
    func wsforgetpassword(){
        
        if ConnectionCheck.isConnectedToNetwork() {
            hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.label.text = "Loading"
            let postString = "email_id=\(txtforgeteid.text!)"
            let paramData = postString.data(using: .utf8)
            ApiCall.sharedInstance.requestPostMethod(apiUrl: "http://216.55.169.45/~chatt/master/api/ws_forgotpwd", params: paramData!)
            {
                (success, responseData) in
                print(responseData ?? AnyObject.self)
                var dataArr = responseData ?? AnyObject.self as! NSArray
                var strStatus=dataArr.value(forKey: "status") as! NSString
                var data = dataArr.object(forKey: "data") as? NSDictionary
                var strMessage=dataArr.value(forKey: "message") as! NSString
                if(strStatus.lowercased=="error")
                {
                    DispatchQueue.main.async{
                        self.hud?.hide(animated: true)
                        //JLToast.makeText(strStatus as String).show()
                        let alert = UIAlertController(title: "Forgot password", message: "Enter valid email Id", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                else{
                    DispatchQueue.main.async{
                        //JLToast.makeText(strStatus as String).show()
                        self.hud?.hide(animated: true)
                        let alert = UIAlertController(title: "Forgot Password", message: "Password Reset Request Sent" as String, preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            self.present(nextViewController, animated:true, completion:nil)
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
//MARK: forgetpassword button action
    @IBAction func btnforgetsub(_ sender: AnyObject) {
        if (txtforgeteid.text! == ""){
            //  JLToast.makeText("please enter first name").show()
            let alert = UIAlertController(title: "Forgot Password", message: "Please enter Email Address", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else{
            wsforgetpassword()
            
        }
    }
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
