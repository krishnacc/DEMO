//
//  RegistrationViewController.swift
//  ATChat
//
//  Created by komal on 3/23/17.
//  Copyright © 2017 komal. All rights reserved.
//
import UIKit
class RegistrationViewController: UIViewController ,UIImagePickerControllerDelegate,UITextFieldDelegate, UINavigationControllerDelegate,UIScrollViewDelegate{
//MARK: OUTLETS
    var hud: MBProgressHUD?
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmailId: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    @IBOutlet var imgViewPicker: UIImageView!
    @IBOutlet var subout: UIButton!
    var pickerView = UIImagePickerController()
     //var containerView = UIView()
//MARK: Application life cycle didload
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmailId.delegate = self
        //txtphoneno.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        self.setupFirstnameTxtField()
        self.setupLastnameTxtField()
        self.setupEmailidTxtField()
        self.setupPassTxtField()
        self.setupConfirmTxtField()
        imgViewPicker.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePick)))
        imgViewPicker.isUserInteractionEnabled = true
        pickerView.delegate = self
}
   override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidAppear(_ animated: Bool) {
        imgViewPicker.layer.cornerRadius = imgViewPicker.frame.size.width/2
        // imgViewPicker.layer.cornerRadius = imgViewPicker.frame.size.width
        imgViewPicker.clipsToBounds = true
       // imgViewPicker.layer.masksToBounds = true
        imgViewPicker.layer.borderColor = UIColor.black.cgColor
        imgViewPicker.layer.borderWidth = 1
    }
//MARK: textfiend should return delegate method
    func textFieldShouldReturn (_ textField: UITextField) -> Bool{
    if ((textField == txtFirstName)){
    txtLastName.becomeFirstResponder();
}
      else if (textField == txtLastName){
          txtEmailId.becomeFirstResponder();
     }
     else if (textField == txtEmailId){
         txtPassword.becomeFirstResponder();
    }
   else if (textField == txtPassword){
           txtConfirmPassword.becomeFirstResponder()
    }
    else if (textField == txtConfirmPassword)
        {        textField.resignFirstResponder()

        }
     
        textField.resignFirstResponder()
        
    return true
  }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == txtFirstName){
      
        }
        else if(textField == txtLastName){
        }
        else if(textField == txtEmailId){
          
        }
        else if(textField == txtPassword)
        {
                  }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    //MARK: Back button action
    @IBAction func Backactn(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
//MARK: Textfield set up
    func setupFirstnameTxtField() {
        let imageView = UIImageView()
        let leftV = UIView()
        txtFirstName.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        leftV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let image = UIImage(named: "ic_email.png")
        imageView.image = image
        leftV.addSubview(imageView)
        txtFirstName.leftView = leftV
        txtFirstName.leftViewMode = UITextFieldViewMode.always
    }
    func setupLastnameTxtField() {
        let imageView = UIImageView()
        let leftV = UIView()
        txtLastName.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        leftV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let image = UIImage(named: "ic_email.png")
        imageView.image = image
        leftV.addSubview(imageView)
        txtLastName.leftView = leftV
        txtLastName.leftViewMode = UITextFieldViewMode.always
    }
    func setupEmailidTxtField() {
        let imageView = UIImageView()
        let leftV = UIView()
        txtEmailId.attributedPlaceholder = NSAttributedString(string: "Email",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        leftV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let image = UIImage(named: "ic_email-1.png")
        imageView.image = image
        leftV.addSubview(imageView)
        txtEmailId.leftView = leftV
        txtEmailId.leftViewMode = UITextFieldViewMode.always
    }
    func setupPassTxtField() {
        let imageView = UIImageView()
        let leftV = UIView()
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        leftV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let image = UIImage(named: "ic_password.png")
        imageView.image = image
        leftV.addSubview(imageView)
        txtPassword.leftView = leftV
        txtPassword.leftViewMode = UITextFieldViewMode.always
    }
    func setupConfirmTxtField() {
        let imageView = UIImageView()
        let leftV = UIView()
        txtConfirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.black])
        leftV.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        let image = UIImage(named: "ic_password.png")
        imageView.image = image
        leftV.addSubview(imageView)
        txtConfirmPassword.leftView = leftV
        txtConfirmPassword.leftViewMode = UITextFieldViewMode.always
    }
//MARK: Registration button action with validations
    @IBAction func btnRegsubmit(_ sender: AnyObject) {
        let charSet = CharacterSet.whitespaces
        let trimmedString1: String = txtFirstName.text!.trimmingCharacters(in: charSet)
        let trimmedString2: String = txtLastName.text!.trimmingCharacters(in: charSet)
        let validEmail: Bool = self.validateEmail(email: txtEmailId.text!)
        let validFname: Bool = self.validateFname(fname: txtFirstName.text!)
        let validLname: Bool = self.validateFname(fname: txtLastName.text!)
        if (txtFirstName.text! == ""){
          //  JLToast.makeText("please enter first name").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter first name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (trimmedString1 == ""){
          //  JLToast.makeText("please enter valid first name").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter valid first name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (!validFname){
          //  JLToast.makeText("please enter valid first name").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter valid first name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (checkUserName(txtFirstName.text!) == false){
            
          //  JLToast.makeText("please enter valid first name").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter valid first name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        else if ((txtFirstName.text!.characters.count) < 3 || (txtFirstName.text!.characters.count) > 20 ){
          //  JLToast.makeText("please enter name between 3 to 20 characters").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter name between 3 to 20 characters", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (txtLastName.text! == ""){
           // JLToast.makeText("please enter last name").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter last name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (trimmedString2 == ""){
            //JLToast.makeText("please enter valid last name").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter valid last name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
        else if (!validLname){
           // JLToast.makeText("please enter valid last name").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter valid last name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (checkUserName(txtLastName.text!) == false){
           // JLToast.makeText("please enter valid last name").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter valid last name", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if ((txtLastName.text!.characters.count) < 3 || (txtLastName.text!.characters.count) > 20 ){
           // JLToast.makeText("please enter name between 3 to 20n characters").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter name between 3 to 20n characters", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
        else if (txtEmailId.text! == ""){
            //JLToast.makeText("please enter email id").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter email id", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
        else if (!validEmail){
           // JLToast.makeText("please enter valid email id").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter email id", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if (txtPassword.text! == ""){
            //JLToast.makeText("please enter password").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter password", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if ((txtPassword.text!.characters.count) < 8 || (txtPassword.text!.characters.count) > 15 ){
          //  JLToast.makeText("password should be between 8 to 15 characters").show()
            let alert = UIAlertController(title: "Registration", message: "Password should be between 8 to 15 characters", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else if !(isValidPassword (candidate: (txtPassword.text)!)) || ((txtPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!) {
          //  JLToast.makeText("invalid password").show()
            let alert = UIAlertController(title: "Registration", message: "Invalid password", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
      else if (txtConfirmPassword.text! == ""){
           // JLToast.makeText("please enter confirm password").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter confirm password", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    else if (txtPassword.text != self.txtConfirmPassword.text){
           // JLToast.makeText("please enter same password").show()
            let alert = UIAlertController(title: "Registration", message: "Please enter same password", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
            else if (imgViewPicker.image == nil)
        {
            // JLToast.makeText("Please pick your image").show()
            let alert = UIAlertController(title: "Registration", message: "Please pick your image", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            }
        else{
            wsRegisterUser()
        }
    }
    
//MARK: Function to check user names
    func checkUserName(_ stringName:String) -> Bool {
        var sepcialChar = false
        var temp = false
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        if stringName.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains special characters")
            sepcialChar = true
            
        }
        else {
            temp = true
            
        }
        let phone = stringName.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if phone != "" || sepcialChar == true {
            temp = false
            for chr in stringName.characters {
                if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z") ) {
                    temp = true
                    break
                }
            }
        }
        if temp == true {
            return true
        }
        else {
            return false
        }
        
    }
//MARK: Function to check isvalidpassword
func isValidPassword(candidate: String) -> Bool {
        let passwordRegex = "^[A-Za-z0-9@#$^&!*:-\\\\+]*$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let result1 = passwordTest.evaluate(with: candidate)
        return result1
        
}
//MARK: Function to check email validation
    func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9.]+[A-Za-z_0-9]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
//MARK: Function to validate first name and last name
    func validateFname(fname: String) -> Bool {
        let nameRegex = "^[A-Za-z]+[a-zA-Z0-9'_.-]*$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: fname)
    }
//MARK: function white spaces not allowed in password
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == txtPassword! || textField == txtConfirmPassword!)
        {
            if ((string .rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines)) != nil){
                return false
            }
        }
        else{
        }
        return true
    }
//MARK Registeruser Webservice call
    func wsRegisterUser() {
        if ConnectionCheck.isConnectedToNetwork(){
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.label.text = "Loading"
        let url = URL(string: "http://216.55.169.45/~chatt/master/api/ws_signup")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if (imgViewPicker.image == nil)
        {
            return
        }
        let image_data = UIImagePNGRepresentation(imgViewPicker.image!)
        if(image_data == nil)
        {
            return
        }
        let body = NSMutableData()
        let fname = "test.png"
        let mimetype = "image/png"
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"first_name\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(txtFirstName.text!)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"last_name\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(txtLastName.text!)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"email_id\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(txtEmailId.text!)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"phone_no\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\("8141475385")\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"password\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(txtPassword.text!)\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            DispatchQueue.main.async {
                self.hud?.hide(animated: true)
                guard ((data) != nil), let _:URLResponse = response, error == nil else {
                print("error")
              //    self.hud?.hide(animated: true)
                JLToast.makeText(error as! String).show()
                return
            }
            if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            {
                print(dataString)
                let alert = UIAlertController(title: "Registered", message: "Registered succesfully", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                  //  self.hud?.hide(animated: true)
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.present(nextViewController, animated:true, completion:nil)

            }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                }
            }
        })
        
        task.resume()
        }
        else{
            JLToast.makeText("Check your conncection").show()
            }
    }
//MARK: generateBoundaryString function for wsregistartion call
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
//MARK: imagepicker function
    func imagePick() {
    pickerView.allowsEditing = false
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message:  nil, preferredStyle: .actionSheet)
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            print("Take Photo")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.pickerView.sourceType = .camera
                self.present(self.pickerView, animated: true, completion: { _ in })
            }
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Camera Roll", style: .default) { action -> Void in
            print("Camera Roll")
            self.pickerView.sourceType = .photoLibrary
            self.present(self.pickerView, animated: true, completion: { _ in })
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
//MARK: imagepicker controller
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            imgViewPicker.image = possibleImage

        }
 else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            imgViewPicker.image = possibleImage
        }
        else
        {
            return
        }
        //print(newImage.size)
        dismiss(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


