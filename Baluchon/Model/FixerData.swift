//
//  FixerData.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 28/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation

// data recover on postman and decode with quicktype
struct FixerData: Decodable {
   
    let rates: [String:Double]
}
