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
    let annéeExpDomaine:Int?
}

struct Profession {
    let nom:String
    let duréeFormation:Int //En année
    let lien:NSURL
}

enum NivProf { 
    case aucun
    case afp
    case cfc
    case brevet
    case diplôme
    case maitrise
}
