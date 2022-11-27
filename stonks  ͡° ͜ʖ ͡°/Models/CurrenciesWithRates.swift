//
//  CurrenciesWithRates.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import Foundation

struct CurrenciesWR: Decodable {
    let rates: [String: Double]?
    
    var currencies: [String]?
    mutating func addCurr(from keys: String) {
        if rates != nil {
            for key in rates!.keys {
                currencies?.append(key)
            }
        }
    }
    
    var ratesToRub: [Double]?
    mutating func addRates(from values: Double) {
        if rates != nil {
            for value in rates!.values {
                ratesToRub?.append(value)
            }
        }
    }
}
