//
//  ViewController.swift
//  OrifOrientation
//
//  Created by Alex Millius on 16.12.16.
//  Copyright © 2016 TumTum. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var userDataPicker: UIPickerView!
    @IBOutlet weak var startSearchBtn: UIButton!
    @IBOutlet weak var mptiSwitch: UISwitch!
    @IBOutlet weak var mpGymnasialeSwitch: UISwitch!
    

    let pickerData = [["10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65"],[NivProf.aucun.rawValue,NivProf.afp.rawValue,NivProf.cfc.rawValue,NivProf.brevet.rawValue,NivProf.diplôme.rawValue,NivProf.maitrise.rawValue],[NivProf.aucun.rawValue,NivProf.afp.rawValue,NivProf.cfc.rawValue,NivProf.brevet.rawValue,NivProf.diplôme.rawValue,NivProf.maitrise.rawValue]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Test de connection à la base de donnée
        /*var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").setValue(["username": "testChablabla"])*/
        
        userDataPicker.delegate = self
        userDataPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: PickerView Delegate and DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //DO Something
    }
    
}

