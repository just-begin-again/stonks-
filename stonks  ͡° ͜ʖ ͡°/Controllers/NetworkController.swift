//
//  NetworkController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import Foundation

class NetworkController {
    
    let baseURL = "https://www.cbr-xml-daily.ru/latest.js"
    var currencies = [Currency]()
    
    func parse(JSON: Data) {
        
        let decoder = JSONDecoder()
        let currenciesWR = try? decoder.decode(CurrenciesWR.self, from: JSON)
        
        if currenciesWR != nil {
            for (key, value) in currenciesWR!.rates! {
                currencies.append(Currency(code: key, rateToRub: value))
            }
        }
        print(currencies)
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
