//
//  ProjectViewController.swift
//  ATChat
//
//  Created by komal on 3/22/17.
//  Copyright © 2017 komal. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       setNavigationBarItem()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setNavigationBarItem() {
        self.title = "Project"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
        
        self.addLeftBarButtonWithImage((UIImage(named:"ic_drawer")?.withRenderingMode(.alwaysOriginal))!)
        self.addRightBarButtonWithImage((UIImage(named:"ic_search")?.withRenderingMode(.alwaysOriginal))!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }

}
extension ProjectViewController : SlideMenuControllerDelegate {
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

    
