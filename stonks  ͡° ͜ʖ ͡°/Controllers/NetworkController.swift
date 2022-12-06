//
//  NetworkController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import Foundation

class NetworkController {
    
    let baseURL = C.net.urlStr
    var currencies = [Currency]()
    var currenciesDict = [String: Double]()
    
    func parse(JSON: Data) {
        
        let decoder = JSONDecoder()
        let currenciesWR = try? decoder.decode(CurrenciesWR.self, from: JSON)
        
        if currenciesWR != nil {
            currenciesDict = (currenciesWR?.rates)!
            currenciesDict.updateValue(1, forKey: "RUB")
            for (key, value) in currenciesWR!.rates! {
                if key == "USD" {
                    currencies.append(Currency(code: key, rateToRub: value, priority: 3))
                } else if key == "EUR" {
                    currencies.append(Currency(code: key, rateToRub: value, priority: 2))
                } else {
                    currencies.append(Currency(code: key, rateToRub: value, priority: 0))
                }
            }
        }
        currencies.append(Currency(code: "RUB", rateToRub: 1, priority: 1))
        currencies.sort {
            ($0.priority, $1.code) > ($1.priority, $0.code)
        }
        
    }
    
    func fetchJSON(urlStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlStr) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url)
            { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                if let safeData = data {
                    completion(.success(safeData))
                }
            }
            urlSession.resume()
        }
    }
}




