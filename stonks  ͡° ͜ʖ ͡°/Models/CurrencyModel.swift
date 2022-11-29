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
    var isChecked: Bool = false
    var priority: Int
    
    struct Currencies: Codable {
        var results: [Currency]
    }
}
