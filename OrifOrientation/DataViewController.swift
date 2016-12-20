//
//  DataViewController.swift
//  OrifOrientation
//
//  Created by Millius Alex on 16.12.16.
//  Copyright © 2016 TumTum. All rights reserved.
//

import UIKit
import Firebase

class DataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    @IBOutlet weak var professionTblView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statutLbl: UILabel!
    
    @IBOutlet weak var cacheView: UIView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var retourBtnCacheWebView: UIButton!
    @IBOutlet weak var activityIndicatorWebView: UIActivityIndicatorView!
    
    var userSetting:Assuré = Assuré()
    var filteredProfessions = [Profession]()
    var niveauMinAffichageFormation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //défini sur une échelle de 0 à 5 le niveau de formation minimum que l'user veut afficher
        switch userSetting.niveauProfAutorise {
        case .scolarité: niveauMinAffichageFormation = 0
        case .afp: niveauMinAffichageFormation = 1
        case .cfc: niveauMinAffichageFormation = 2
        case .brevet: niveauMinAffichageFormation = 3
        case .diplôme: niveauMinAffichageFormation = 4
        case .maitrise: niveauMinAffichageFormation = 5
        }
        
        filteredProfessions = []
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
        
        func filterFormations(){
            let allFormations = [sansTitreDeFormations,afps,cfcs,brevets,diplômes,maitrises]
            
            var restrictionNiveauFormation = 0
            
            //défini sur une échelle de 0 à 5 le niveau de formation de l'user
            switch userSetting.niveauProfAutorise {
            case .scolarité: restrictionNiveauFormation = 0
            case .afp: restrictionNiveauFormation = 1
            case .cfc: restrictionNiveauFormation = 2
            case .brevet: restrictionNiveauFormation = 3
            case .diplôme: restrictionNiveauFormation = 4
            case .maitrise: restrictionNiveauFormation = 5
            }
            
            var index = 0
            
            while index <= restrictionNiveauFormation {
                for formation in allFormations[index] {
                    //Check que la durée de la formation soit plus petite ou égale à la durée autorisée
                    if formation.duréeFormation <= userSetting.duréeMaxFormation {
                        //Check si le niveau de formation nécessaire est plus petit ou égal au niveau de formation nécessaire
                        if formation.niveauFormationNécessaire.niv <= userSetting.niveauProfInit.niv {
                            //Check que l'âge minium de l'user soit plus grand ou égal à l'âge minimum
                            if formation.ageMinimum <= userSetting.age {
                                //Check que l'assuré ai la maturité nécesaire
                                if formation.mptiNécessaire == userSetting.mpti {
                                    //mpti nécessaire et l'user en a une
                                    print(formation.nom + " avec mpti")
                                    filteredProfessions.append(formation)
                                } else if !formation.mptiNécessaire {
                                    //mpti non nécessaire
                                    if formation.mGymnasialeNécessaire == userSetting.mGymnasiale {
                                        //matu gymnasiale nécessaire et l'user en a une
                                        print(formation.nom + " avec matu et user l'a")
                                        filteredProfessions.append(formation)
                                    } else if !formation.mGymnasialeNécessaire {
                                        //matu gymnasiale non nécessaire et mpti non nécessaire
                                        print(formation.nom + " pas de matu et pas de mpti")
                                        filteredProfessions.append(formation)
                                    }
                                }
                            }
                        }
                    }
                }
                index += 1
            }
            //Recharge la tableView
            DispatchQueue.main.async{
                self.professionTblView.reloadData()
            }
            activityIndicator.isHidden = true
            statutLbl.text = "\(filteredProfessions.count) professions trouvées"
        }
        
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
                                case "nivNecess": tempProfession.niveauFormationNécessaire = NivProf(rawValue: value as! String)!
                                    case "lien": tempProfession.lien = URL(string: value as! String)!
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
                        case "AFP":
                            if self.niveauMinAffichageFormation <= 1 {
                                castDataFromFormation(professions: &afps, rawProfessionsData: formations as AnyObject)
                            }
                        case "CFC":
                            if self.niveauMinAffichageFormation <= 2 {
                                castDataFromFormation(professions: &cfcs, rawProfessionsData: formations as AnyObject)
                            }
                        case "Brevet":
                            if self.niveauMinAffichageFormation <= 3 {
                                castDataFromFormation(professions: &brevets, rawProfessionsData: formations as AnyObject)
                            }
                        case "Diplome":
                            if self.niveauMinAffichageFormation <= 4 {
                                castDataFromFormation(professions: &diplômes, rawProfessionsData: formations as AnyObject)
                            }
                        case "Maitrise":
                            if self.niveauMinAffichageFormation <= 5 {
                                castDataFromFormation(professions: &maitrises, rawProfessionsData: formations as AnyObject)
                            }
                        default: castDataFromFormation(professions: &sansTitreDeFormations, rawProfessionsData: formations as AnyObject)
                        }
                    }
                }
            }
            filterFormations()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: TableView Delegate et datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProfessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Try to get a cell to reuse
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "basicCell")! as UITableViewCell
        
        // Set cell properties
        cell.textLabel?.text = filteredProfessions[indexPath.row].nom
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        // Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cacheView.isHidden = false
        let url = filteredProfessions[indexPath.row].lien
        webView.loadRequest(URLRequest(url: url))
        
        
        /*let url = URL(string: "https://facebook.com")!
        webView.loadRequest(URLRequest(url: url))*/
    }
    
    //MARK: UI Action
    @IBAction func retourCacheViewTapped(_ sender: Any) {
        cacheView.isHidden = true
        activityIndicatorWebView.startAnimating()
    }
    
    //MARK: webView Delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorWebView.stopAnimating()
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
