//
//  AViewController.swift
//  TestInteractive
//
//  Created by shinsuke.tomita@bizreach.co.jp on 2014/12/24.
//  Copyright (c) 2014年 shinsuke.tomita@bizreach.co.jp. All rights reserved.
//

import UIKit

class AViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.transitionManager.sourceViewController = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.identifier)
        let toViewController = segue.destinationViewController as UIViewController
        toViewController.transitioningDelegate = self.transitionManager
        self.transitionManager.menuViewController = toViewController
    }
}