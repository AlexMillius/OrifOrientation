//
//  Model.swift
//  OrifOrientation
//
//  Created by Mohamed Lee on 16.12.16.
//  Copyright © 2016 TumTum. All rights reserved.
//

import Foundation

struct Assuré {
    let age:Int
    let niveauProfInit:NivProf
    let niveauProfAutorise:NivProf
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
