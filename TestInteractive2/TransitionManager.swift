//
//  TransitionManager.swift
//  TestInteractive2
//
//  Created by shinsuke.tomita@bizreach.co.jp on 2014/12/24.
//  Copyright (c) 2014年 shinsuke.tomita@bizreach.co.jp. All rights reserved.
//

import UIKit

class TransitionManager: UIPercentDrivenInteractiveTransition {
    
    private var presenting = true
    private var interactive = false
    
    private var enterPanGesture: UIPanGestureRecognizer!
    
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesture = UIPanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action:"handleOnstagePan:")
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
        }
    }
    
    private var exitPanGesture: UIPanGestureRecognizer!
    
    var menuViewController: UIViewController! {
        didSet {
            self.exitPanGesture = UIPanGestureRecognizer()
            self.exitPanGesture.addTarget(self, action:"handleOffstagePan:")
            self.menuViewController.view.addGestureRecognizer(self.exitPanGesture)
        }
    }
    
    func handleOnstagePan(pan: UIPanGestureRecognizer){
        // how much distance have we panned in reference to the parent view?
        let translation = pan.translationInView(pan.view!)
        
        // do some math to translate this to a percentage based value
        let d =  translation.y / CGRectGetWidth(pan.view!.bounds) * -0.5
        println("\(translation.y), \(d)")
        
        // now lets deal with different states that the gesture recognizer sends
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            // set our interactive flag to true
            self.interactive = true
            
            // trigger the start of the transition
            self.sourceViewController.performSegueWithIdentifier("tobsegue", sender: self)
            break
            
        case UIGestureRecognizerState.Changed:
            // update progress of the transition
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            // return flag to false and finish the transition
            self.interactive = false
            if(d > 0.2){
                // threshold crossed: finish
                self.finishInteractiveTransition()
            }
            else {
                // threshold not met: cancel
                self.cancelInteractiveTransition()
            }
        }
    }
    
    func handleOffstagePan(pan: UIPanGestureRecognizer){
        
        let translation = pan.translationInView(pan.view!)
        let d =  translation.y / CGRectGetWidth(pan.view!.bounds) * 0.5
        println("\(translation.y), \(d)")
        switch (pan.state) {
            
        case UIGestureRecognizerState.Began:
            self.interactive = true
            //self.menuViewController.performSegueWithIdentifier("dismissMenu", sender: self)
            self.menuViewController.dismissViewControllerAnimated(true, completion: nil)
            break
            
        case UIGestureRecognizerState.Changed:
            self.updateInteractiveTransition(d)
            break
            
        default: // .Ended, .Cancelled, .Failed ...
            self.interactive = false
            if(d > 0.1){
                self.finishInteractiveTransition()
            }
            else {
                self.cancelInteractiveTransition()
            }
        }
    }
}

extension TransitionManager: UIViewControllerAnimatedTransitioning {

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let h = UIScreen.mainScreen().bounds.height
        let offScreenOver = CGAffineTransformMakeTranslation(0, h * -1)
        let offScreenUnder = CGAffineTransformMakeTranslation(0, h)
        
        toView.transform = self.presenting ? offScreenUnder : offScreenOver
        container.addSubview(toView)
        container.addSubview(fromView)
        
        let duration = self.transitionDuration(transitionContext)
        
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: nil, animations: {
            
            // slide fromView off either the left or right edge of the screen
            // depending if we're presenting or dismissing this view
            fromView.transform = self.presenting ? offScreenOver : offScreenUnder
            toView.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                
                if(transitionContext.transitionWasCancelled()){
                    transitionContext.completeTransition(false)
                } else {
                    transitionContext.completeTransition(true)
                }
        })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.75
    }
}

extension TransitionManager: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // these methods are the perfect place to set our `presenting` flag to either true or false - voila!
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}

extension TransitionManager: UIViewControllerInteractiveTransitioning {
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // if our interactive flag is true, return the transition manager object
        // otherwise return nil
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
}