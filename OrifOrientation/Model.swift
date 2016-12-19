//
//  Model.swift
//  OrifOrientation
//
//  Created by Millius Alex on 16.12.16.
//  Copyright © 2016 TumTum. All rights reserved.
//

import Foundation

struct Assuré {
    var age:Int = 10
    var mpti:Bool = false
    var mGymnasiale:Bool = false
    var niveauProfInit:NivProf = NivProf.scolarité
    var niveauProfAutorise:NivProf = NivProf.scolarité
    var duréeMaxFormation:Int = 3 //En années
}

struct Profession {
    var duréeFormation:Int = 0 //En année
    var mptiNécessaire:Bool = false
    var mGymnasialeNécessaire:Bool = false
    var niveauFormationNécessaire:NivProf = .scolarité
    var expérienceNécessaire:Int? = 0 //En année //TODO
    var ageMinimum:Int = 1
    var nom:String = ""
    var lien:NSURL = NSURL(fileURLWithPath: "")
}

enum NivProf:String {
    case scolarité
    case afp
    case cfc
    case brevet
    case diplôme
    case maitrise
    
    var niv: Int {
        switch self {
        case .scolarité: return 0
        case .afp: return 1
        case .cfc: return 2
        case .brevet: return 3
        case .diplôme: return 4
        case .maitrise: return 5
        }
    }
}
