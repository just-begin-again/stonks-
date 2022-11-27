//
//  CurrencyModel.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import Foundation

struct Currency: Codable {
    
    var code: String
    var rateToRub: Double
    
    struct Currencies: Codable {
        var results: [Currency]
    }
}
