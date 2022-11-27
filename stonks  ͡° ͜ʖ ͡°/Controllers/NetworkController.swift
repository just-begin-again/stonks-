//
//  NetworkController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import Foundation

class NetworkController {
    
    let baseURL = "https://www.cbr-xml-daily.ru/latest.js"
    
    func parse(JSON: Data) {
        do {
            let decoder = JSONDecoder()
            let currenciesWR = try decoder.decode(CurrenciesWR.self, from: JSON)
            print(currenciesWR.rates)
            print(currenciesWR.currencies)
            print(currenciesWR.ratesToRub)
            print("----===========-------============-------========")
        } catch {
            print("decoding failed")
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
