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
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        tableView.backgroundColor = .clear
//        tableView.sectionHeaderHeight = 40
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 70
        
        tableView.backgroundColor = C.colors.background
        
        
        
//        view.backgroundColor = UIColor(hex: "F9F7F7")
        
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
        let currency = netContr.currencies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! CurrencyCell
       
        let radius = cell.backView.frame.height / 2
        cell.backView.layer.cornerRadius = radius
        cell.currencyCellView.layer.cornerRadius = cell.currencyCellView.frame.height / 2
        
        
        
//        cell.flagView.backgroundColor = .clear
        cell.setCircleLayer(for: cell.flagImageView)
        cell.flagImageView.backgroundColor = .red
       
        cell.backView.backgroundColor = UIColor(hex: "CDD3E0")
        cell.currencyLabelView.backgroundColor = UIColor(hex: "CDD3E0")
        cell.backgroundColor = .clear
        
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
//        cell.flagImageView.translatesAutoresizingMaskIntoConstraints = false
//        cell.flagImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        cell.flagImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cell.flagImageView.image = UIImage(named: currency.code.lowercased())
        cell.setCircleLayer(for: cell.flagView)
      
//        cell.flagImageView.sizeToFit()
        
        
        let numberStr = (String(format: "%.2f", (1.0/currency.rateToRub))).replacingOccurrences(of: ".", with: ".")
        
        cell.numberLabel.text = "\(currency.code.uppercased())"
        cell.currencyLabel.text = numberStr
        
        cell.currencyLabel.textColor = UIColor(hex: "F9F7F7")
        cell.currencyLabel.numberOfLines = 1
        cell.currencyLabel.adjustsFontSizeToFitWidth = true
        cell.currencyLabel.minimumScaleFactor = 0.01
//        cell.currencyLabel.font = UIFont.monospacedSystemFont(ofSize: 90, weight: .ultraLight)


        
        //        cell.setupApperance(for: cell.currencyLabel)
        
        return cell
    }
    
    
    
    
    //MARK: - UITableViewDelegate Methods
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let cell = tableView.cellForRow(at: indexPath) as! CurrencyCell
    //        cell.currencyLabel.textColor = UIColor(hex: "3F72AF")
    //        cell.layer.borderWidth = 3.0
    //        cell.layer.borderColor = UIColor(hex: "3F72AF").cgColor
    //
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
}

