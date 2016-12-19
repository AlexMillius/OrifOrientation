//
//  DataViewController.swift
//  OrifOrientation
//
//  Created by Mohamed Lee on 16.12.16.
//  Copyright © 2016 TumTum. All rights reserved.
//

import UIKit
import Firebase

class DataViewController: UIViewController {
    
    @IBOutlet weak var professionTblView: UITableView!
    
    var userSetting:Assuré = Assuré()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(userSetting)
        loadProfessions(settings: userSetting)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadProfessions(settings:Assuré){
        var sansTitreDeFormations = [Profession]()
        var afps = [Profession]()
        var cfcs = [Profession]()
        var brevets = [Profession]()
        var diplômes = [Profession]()
        var maitrises = [Profession]()
        
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        func castDataFromFormation( professions:inout [Profession],rawProfessionsData:AnyObject){
            
            //Check que les données brutes soient un array et downcast si c'est le cas
            if rawProfessionsData is NSArray {
                let rawProfessions = rawProfessionsData as! NSArray
                //Loop les rawProfessions
                for profession in rawProfessions {
                    var tempProfession = Profession()
                    //Check si les professions sont des dictionaire et les downcast si c'est le cas
                    if profession is NSDictionary {
                        let prof = profession as! NSDictionary
                        //Affecte les key-value en fonction des données
                        for (key,value) in prof {
                            if key is String {
                                let keyString = key as! String
                                switch keyString {
                                    case "ageMin": tempProfession.ageMinimum = value as! Int
                                    case "expNec": tempProfession.expérienceNécessaire = value as? Int
                                    case "mgym": tempProfession.mGymnasialeNécessaire = value as! Bool
                                    case "dureeForm": tempProfession.duréeFormation = value as! Int
                                    case "nom": tempProfession.nom = value as! String
                                    case "mpti": tempProfession.mptiNécessaire = value as! Bool
                                case "nivNecess": tempProfession.niveauFormationNécessaire = NivProf(rawValue: value as! String)
                                    case "lien": tempProfession.lien = NSURL(fileURLWithPath: value as! String)
                                default: break
                                }
                            }
                        }
                    }
                    //Affecte la profession au groupe correspondant
                    professions.append(tempProfession)
                }
            }
        }
        
        ref.child("Formations").observeSingleEvent(of: .value, with: { (snapshot) in
           
            // obtenir toutes les données des formations dans un dictionnaire
            let formationsParGroupe = snapshot.value as? NSDictionary
            //print(formationsParGroupe)
            
            // séparé les données en AFC/CFC/Brevet/Diplôme/Maitrise ou autre
            if let formationsGroupée = formationsParGroupe {
                
                for (nomNiveauFormation, formations) in formationsGroupée {
                    //print(nomNiveauFormation,formations)
                    
                    if nomNiveauFormation is String {
                        
                        let nivForm = nomNiveauFormation as! String
                        
                        switch nivForm{
                        case "AFP": castDataFromFormation(professions: &afps, rawProfessionsData: formations as AnyObject)
                        case "CFC": castDataFromFormation(professions: &cfcs, rawProfessionsData: formations as AnyObject)
                        case "Brevet": castDataFromFormation(professions: &brevets, rawProfessionsData: formations as AnyObject)
                        case "Diplome": castDataFromFormation(professions: &diplômes, rawProfessionsData: formations as AnyObject)
                        case "Maitrise": castDataFromFormation(professions: &maitrises, rawProfessionsData: formations as AnyObject)
                        default: castDataFromFormation(professions: &sansTitreDeFormations, rawProfessionsData: formations as AnyObject)
                        }
                    }
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
