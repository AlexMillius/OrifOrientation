//
//  ViewController.swift
//  OrifOrientation
//
//  Created by Alex Millius on 16.12.16.
//  Copyright © 2016 TumTum. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Test de connection à la base de donnée
        var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").setValue(["username": "testChablabla"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

