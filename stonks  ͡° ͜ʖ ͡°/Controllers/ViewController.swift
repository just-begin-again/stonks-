//
//  ViewController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit

class ViewController: UIViewController {

    let baseURL = "https://www.cbr-xml-daily.ru/latest.js"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchJSON(urlStr: baseURL) { (result) in
            switch result {
            case .success(let data): self.parse(JSON: data)
            case .failure(let error): print(error)
            }
        }
        
    }

    private func parse(JSON: Data) {
        do {
            let decoder = JSONDecoder()
            let currenciesWR = try decoder.decode(CurrenciesWR.self, from: JSON)
        } catch {
            print("decoding failed")
        }
    }
    
    private func fetchJSON(urlStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
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

