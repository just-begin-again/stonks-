//
//  ViewController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit

class ViewController: UITableViewController {
    
    
    var netContr = NetworkController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(hex: "F9F7F7")
        
        self.netContr.fetchJSON(urlStr: self.netContr.baseURL) { (result) in
            switch result {
            case .success(let data): self.netContr.parse(JSON: data)
            case .failure(let error): print(error)
            }
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return netContr.currencies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! CurrencyCell
        let currency = netContr.currencies[indexPath.row]
        
        cell.backgroundColor = UIColor(hex: "CDD3E0")
        
        cell.flagImageView.image = UIImage(named: currency.code.lowercased())
        cell.setConstr(to: cell.flagImageView)
        
        cell.currencyLabel.text = " \(1.0/currency.rateToRub) \(currency.code.uppercased())"
        cell.setupApperance(for: cell.currencyLabel)
        cell.currencyCellView.translatesAutoresizingMaskIntoConstraints = false
        
        return cell
    }
    
    
    
    //MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyCell
        cell.currencyLabel.textColor = UIColor(hex: "3F72AF")
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor(hex: "3F72AF").cgColor
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

