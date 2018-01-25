//
//  AboutChattViewController.swift
//  ATChat
//
//  Created by komal on 3/22/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit
//this is my new change
class AboutChattViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem()
        txtvwaboutchat.isUserInteractionEnabled = false
        txtvwaboutchat.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping

        // Do any additional setup after loading the view.
    }
   
    @IBOutlet var txtvwaboutchat: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
           }
    override func viewDidLayoutSubviews() {
      //  txtvwaboutchat.setContentOffset(CGPoint.zero, animated: false)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



override func setNavigationBarItem() {
    
    
    self.title = "About Chatt"
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
extension AboutChattViewController : SlideMenuControllerDelegate {
    
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

