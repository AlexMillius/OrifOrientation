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
    @IBOutlet weak var annéesMaxFormationStepper: UIStepper!
    @IBOutlet weak var annéesMaxFormationLbl: UILabel!
    @IBOutlet weak var niveauMinFormationPicker: UIPickerView!
    

    let pickerData = [["10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65"],[NivProf.scolarité.rawValue,NivProf.afp.rawValue,NivProf.cfc.rawValue,NivProf.brevet.rawValue,NivProf.diplôme.rawValue,NivProf.maitrise.rawValue],[NivProf.scolarité.rawValue,NivProf.afp.rawValue,NivProf.cfc.rawValue,NivProf.brevet.rawValue,NivProf.diplôme.rawValue,NivProf.maitrise.rawValue]]
    
    let nivFormationData = [NivProf.scolarité.rawValue,NivProf.afp.rawValue,NivProf.cfc.rawValue,NivProf.brevet.rawValue,NivProf.diplôme.rawValue,NivProf.maitrise.rawValue]
    
    var userSetting:Assuré = Assuré()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Test de connection à la base de donnée
        /*var ref: FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("professions").child("testChild").setValue(["username": "testChablabla"])*/
        
        userDataPicker.delegate = self
        userDataPicker.dataSource = self
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: enable search button ?
    func checkIfSearchCanBegin() {
        
    }
    
    //MARK: UI Mooved
    
    @IBAction func annéesMaxStepperChanged(_ sender: UIStepper) {
        userSetting.duréeMaxFormation = Int(sender.value)
        annéesMaxFormationLbl.text = "\(userSetting.duréeMaxFormation)"
    }
    
    @IBAction func mptiToggled(_ sender: UISwitch) {
        if sender.isOn {
            userSetting.mpti = true
        } else {
            userSetting.mpti = false
        }
        checkIfSearchCanBegin()
    }
    
    @IBAction func myGymnasialeToggled(_ sender: UISwitch) {
        if sender.isOn {
            userSetting.mGymnasiale = true
        } else {
            userSetting.mGymnasiale = false
        }
        checkIfSearchCanBegin()
    }


    //MARK: PickerView Delegate and DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return pickerData.count
        } else {
            return 1
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return pickerData[component].count
        } else {
            return nivFormationData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return pickerData[component][row]
        } else {
            return nivFormationData[row]
        }
        
    }
    
    var age = Int()
    var formationInitial:NivProf = NivProf.scolarité
    var formationAutorisée:NivProf = NivProf.scolarité
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            switch component {
            case 0: self.age = row + 10
            case 1:
                switch row {
                case 0: self.formationInitial = NivProf.scolarité
                case 1: self.formationInitial = NivProf.afp
                case 2: self.formationInitial = NivProf.cfc
                case 3: self.formationInitial = NivProf.brevet
                case 4: self.formationInitial = NivProf.diplôme
                case 5: self.formationInitial = NivProf.maitrise
                default: break
                }
            case 2:
                switch row {
                case 0: self.formationAutorisée = NivProf.scolarité
                case 1: self.formationAutorisée = NivProf.afp
                case 2: self.formationAutorisée = NivProf.cfc
                case 3: self.formationAutorisée = NivProf.brevet
                case 4: self.formationAutorisée = NivProf.diplôme
                case 5: self.formationAutorisée = NivProf.maitrise
                default: break
                }
            default: break
            }
            userSetting.age = age
            userSetting.niveauProfInit = formationInitial
            userSetting.niveauProfAutorise = formationAutorisée
            checkIfSearchCanBegin()
        } else {
            switch row {
            case 0: userSetting.nivFormationMinimumAffichée = NivProf.scolarité
            case 1: userSetting.nivFormationMinimumAffichée = NivProf.afp
            case 2: userSetting.nivFormationMinimumAffichée = NivProf.cfc
            case 3: userSetting.nivFormationMinimumAffichée = NivProf.brevet
            case 4: userSetting.nivFormationMinimumAffichée = NivProf.diplôme
            case 5: userSetting.nivFormationMinimumAffichée = NivProf.maitrise
            default: break
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dataView" {
            let destinationVC = segue.destination as! DataViewController
            destinationVC.userSetting = self.userSetting
        }
    }
}

