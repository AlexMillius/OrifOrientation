//
//  Model.swift
//  OrifOrientation
//
//  Created by Mohamed Lee on 16.12.16.
//  Copyright © 2016 TumTum. All rights reserved.
//

import Foundation

struct Assuré {
    var age:Int = 10
    var mpti:Bool = false
    var mGymnasiale:Bool = false
    var niveauProfInit:NivProf = NivProf.aucun
    var niveauProfAutorise:NivProf = NivProf.aucun
    var duréeMaxFormation:Int = 3 //En années
}

struct Profession {
    let nom:String
    let lien:NSURL
    let ageMinimum:Int
    let mptiNécessaire:Bool
    let mGymnasialeNécessaire:Bool
    let duréeFormation:Int //En année
    let niveauFormationNécessaire:NivProf?
    let expérienceNécessaire:Int? //En année
}

enum NivProf:String {
    case aucun
    case afp
    case cfc
    case brevet
    case diplôme
    case maitrise
}
