//
//  ZCMenuPresentationer.swift
//  ZCWeChat
//
//  Created by Cusen on 2016/10/29.
//  Copyright © 2016年 zcs. All rights reserved.
//

import UIKit


class ZCMenuPresentationer : NSObject {
    
}

extension ZCMenuPresentationer : UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        return ZCMenuPresentationController(presentedViewController: presented,
                                            presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentedAnimation()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentedAnimation()
    }
}


typealias FrameTransformer = (_ finalFrame: CGRect, _ containerFrame: CGRect) -> CGRect

class PresentedAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animate(transitionContext) { finalFrame, _ in
            var initialFrame = finalFrame
            initialFrame.origin.y = 0 - initialFrame.size.height
            return initialFrame
        }
    }
    
    func animate(_ transitionContext: UIViewControllerContextTransitioning, transform: FrameTransformer) {
        let containerView = transitionContext.containerView
        
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        let isPresenting: Bool = (toViewController?.presentingViewController == fromViewController)
        
        let animatingVC = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
        let initialFrameForVC = transform(finalFrameForVC, containerView.frame)
        
        let initialFrame = isPresenting ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresenting ? finalFrameForVC : initialFrameForVC
        
        let duration = transitionDuration(using: transitionContext)
        
        if isPresenting {
            containerView.addSubview(toView!)
        }
        
        animatingView?.frame = initialFrame
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 300.0, initialSpringVelocity: 5.0, options: .allowUserInteraction, animations: {
            
            animatingView?.frame = finalFrame
            
            }, completion: { (value: Bool) in
                
                if !isPresenting {
                    fromView?.removeFromSuperview()
                }
                
                let wasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCancelled)
                
        })
    }
}

class ZCMenuPresentationController: UIPresentationController {
    
    lazy var chromeView:UIView = {
        let chromeView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        tap.delegate = self
        chromeView.addGestureRecognizer(tap)
        
        chromeView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(CGFloat(0.5))
        return chromeView
    }()
    
    override func presentationTransitionWillBegin() {
        chromeView.frame = containerView!.bounds
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, at: 0)
        
        if let coordinator = presentedViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { context in
                self.chromeView.alpha = 1.0
                }, completion: nil)
            
        } else {
            chromeView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { context in
                self.chromeView.alpha = 0.0
                }, completion: nil)
            
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds
        
        let size = self.size(forChildContentContainer: presentedViewController,
                             withParentContainerSize: containerBounds.size)
        
        let center = containerView!.center
        let origin: CGPoint = CGPoint(x: center.x - 50, y: containerBounds.origin.y + 64)
        
        
        presentedViewFrame.size = size
        presentedViewFrame.origin = origin
        
        return presentedViewFrame
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = 100
        let height = 150
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    override func containerViewWillLayoutSubviews() {

        chromeView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    // MARK: Actions
    
    func chromeViewTapped(gesture: UIGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}

extension ZCMenuPresentationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
