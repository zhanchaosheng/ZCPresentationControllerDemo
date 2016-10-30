//
//  ZCMenuViewController.swift
//  ZCWeChat
//
//  Created by Cusen on 2016/10/29.
//  Copyright © 2016年 zcs. All rights reserved.
//

import UIKit

class ZCMenuViewController: UIViewController {

    let zcMenuDelegate = ZCMenuPresentationer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: -
    public func showMenuView(_ presentingViewController:UIViewController) {
        modalPresentationStyle = .custom
        transitioningDelegate = zcMenuDelegate
        presentingViewController.present(self, animated: true, completion: nil)
    }

    func viewTap(gesture: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

