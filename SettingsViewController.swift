//
//  SettingsViewController.swift
//  ATChat
//
//  Created by komal on 3/22/17.
//  Copyright © 2017 komal. All rights reserved.
//
import UIKit
class SettingsViewController: UIViewController {
//MARK: OUTLET
    @IBOutlet var btnaboutusout: UIButton!
    @IBOutlet var btntermsout: UIButton!
    @IBOutlet var btnchngout: UIButton!
//MARK: Application life cycle didload
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        setNavigationBarItem()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func btnaction(_ sender: AnyObject) {
    }
    @IBAction func btnterms(_ sender: AnyObject) {
    }
//MARK: Update profile button action
    @IBAction func btnUpdateprofile(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
        //   self.present(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
//MARK: Change Password button action
    @IBAction func btnchangeaction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        //   self.present(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        
    }
    
    @IBAction func btnversion(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VersionViewController") as! VersionViewController
        //   self.present(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func setNavigationBarItem() {
        self.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        self.addLeftBarButtonWithImage((UIImage(named:"menu")?.withRenderingMode(.alwaysOriginal))!)
        //self.addRightBarButtonWithImage((UIImage(named:"ic_search")?.withRenderingMode(.alwaysOriginal))!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
}
extension SettingsViewController : SlideMenuControllerDelegate {
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
