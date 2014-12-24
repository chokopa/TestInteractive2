//
//  BViewController.swift
//  TestInteractive
//
//  Created by shinsuke.tomita@bizreach.co.jp on 2014/12/24.
//  Copyright (c) 2014年 shinsuke.tomita@bizreach.co.jp. All rights reserved.
//

import UIKit

class BViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}