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
    var duréeFormation:Int = 0 //En année
    var mptiNécessaire:Bool = false
    var mGymnasialeNécessaire:Bool = false
    var niveauFormationNécessaire:NivProf? = .aucun
    var expérienceNécessaire:Int? = 0 //En année
    var ageMinimum:Int = 1
    var nom:String = ""
    var lien:NSURL = NSURL(fileURLWithPath: "")
}

enum NivProf:String {
    case aucun
    case afp
    case cfc
    case brevet
    case diplôme
    case maitrise
}
