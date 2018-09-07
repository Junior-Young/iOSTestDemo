//
//  testSwiftViewController.swift
//  newDemo
//
//  Created by 杨俊杰 on 2018/9/3.
//  Copyright © 2018 杨俊杰. All rights reserved.
//

import UIKit

class testSwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Swift"
        self.view.backgroundColor = UIColor.white
        self.setupRightNavigationItem()
    }

    func setupRightNavigationItem() {
        let BtnItem = UIBarButtonItem.init(title: "OC", style: .done, target: self, action: #selector(self.gotoOC))
        self.navigationItem.rightBarButtonItem = BtnItem

    }
    
    @objc func gotoOC() {
        let nextVC = testFromSwiftViewController.init();
        navigationController?.pushViewController(nextVC, animated: true)
        
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
