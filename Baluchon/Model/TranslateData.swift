//
//  TranslateData.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 25/05/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import Foundation


// MARK: - Welcome
// use Decodable for decode Json
struct TranslateData: Decodable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Decodable {
    let translatedText: String
}
