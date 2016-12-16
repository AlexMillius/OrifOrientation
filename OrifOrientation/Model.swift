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
}

struct Profession {
    let nom:String
    let duréeFormation:Int //En année
    let lien:NSURL
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
