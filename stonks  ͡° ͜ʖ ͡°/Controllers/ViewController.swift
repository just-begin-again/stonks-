//
//  ViewController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit

class ViewController: UIViewController {

    var netContr = NetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        netContr.fetchJSON(urlStr: netContr.baseURL) { (result) in
            switch result {
            case .success(let data): self.netContr.parse(JSON: data)
            case .failure(let error): print(error)
            }
        }
        
    }

   

}

