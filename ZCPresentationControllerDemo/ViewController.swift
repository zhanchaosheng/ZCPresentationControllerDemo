//
//  ViewController.swift
//  ZCPresentationControllerDemo
//
//  Created by Cusen on 2016/10/30.
//  Copyright © 2016年 Zcoder. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var costomPresentedView:ZCMenuViewController = {
        let costomView = ZCMenuViewController()
        return costomView
    }()
    
    lazy var presentedVC:UIViewController = {
        let presentedVC = UIViewController()
        presentedVC.view.backgroundColor = #colorLiteral(red: 0.5374136567, green: 0.5318768024, blue: 1, alpha: 1)
        presentedVC.modalPresentationStyle = .popover
        return presentedVC
    }()

    @IBAction func doneBarItemClicked(_ sender: UIBarButtonItem) {
        if let popover = presentedVC.popoverPresentationController {
            popover.barButtonItem = sender
            popover.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            popover.delegate = self
            present(presentedVC, animated: true, completion: nil)
        }
    }

    @IBAction func presentedBtnClicked(_ sender: UIButton) {
        if let popVC = presentedVC.popoverPresentationController {
            popVC.sourceView = view
            popVC.sourceRect = sender.frame
            popVC.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            popVC.delegate = self
            present(presentedVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func costomPresentedBtnClicked(_ sender: UIButton) {
        // 自定义PresentationController转场动画
        costomPresentedView.showMenuView(self)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension ViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none //设置为none可以让iPhone上显示效果与iPad上的一样
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        // 给presentedView添加导航条
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ViewController.dismissPopView))
        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismissPopView() {
        presentedVC.dismiss(animated: true, completion: nil)
    }
}

extension UIPopoverPresentationController {
    // 改变presentedView的size
    override open func containerViewWillLayoutSubviews() {
        
        let width = CGFloat(100)
        let height = CGFloat(150)
        
        var frame = presentedView!.frame
        
        // 位置根据实际需求调整
        var x = frame.origin.x + 20
        var y = sourceRect.origin.y - 30
        if sourceRect == CGRect.zero {
            x = frame.origin.x + (frame.size.width - width)
            y = frame.origin.y
        }
        
        frame.size = CGSize(width: width, height: height)
        frame.origin = CGPoint(x: x, y: y)
        
        presentedView!.frame = frame
        
    }
    
}
