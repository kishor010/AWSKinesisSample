//
//  ViewController.swift
//  AWSKinesisTrial
//
//  Created by Apple on 25/07/18.
//  Copyright © 2018 Kishor. All rights reserved.
//

import UIKit
import AWSKinesis

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventManager().sendToDataStream()
        EventManager().sendAWSEvent()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

