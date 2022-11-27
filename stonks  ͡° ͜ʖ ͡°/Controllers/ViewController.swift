//
//  ViewController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    var netContr = NetworkController()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        
        view.backgroundColor = UIColor(hex: "F9F7F7")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.netContr.fetchJSON(urlStr: self.netContr.baseURL) { (result) in
                switch result {
                case .success(let data): self.netContr.parse(JSON: data)
                case .failure(let error): print(error)
                }
            }
            self.tableView.reloadData()
            self.view.addSubview(self.tableView)
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return netContr.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as! CurrencyCell
        let currency = netContr.currencies[indexPath.row]
        
        cell.backgroundColor = UIColor(hex: "CDD3E0")
        
        cell.flagImageView.image = UIImage(named: currency.code.lowercased())
        cell.setConstr(to: cell.flagImageView)
        
        cell.currencyLabel.text = " \(1.0/currency.rateToRub) \(currency.code.uppercased())"
        cell.setupApperance(for: cell.currencyLabel)
        cell.currencyCellView.translatesAutoresizingMaskIntoConstraints = false
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyCell
        cell.currencyLabel.textColor = UIColor(hex: "3F72AF")
        cell.layer.borderWidth = 3.0
        cell.layer.borderColor = UIColor(hex: "3F72AF").cgColor
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
