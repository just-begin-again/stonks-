//
//  ViewController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var tableView = UITableView()

    var netContr = NetworkController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = C.colors.background
        
        self.netContr.fetchJSON(urlStr: self.netContr.baseURL) { (result) in
            switch result {
            case .success(let data): self.netContr.parse(JSON: data)
            case .failure(let error): print(error)
            }
        }
        
        configureTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = C.colors.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: view.frame.height/3, left: 0, bottom: 0, right: 0))
        }
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: C.cellIdentifier)
        
    }
    
}
    
//MARK: - DataSource Methods
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return netContr.currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currency = netContr.currencies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier, for: indexPath) as! CurrencyCell
        
        cell.setupApperance()
        
        cell.flagImageView.image = UIImage(named: currency.code.lowercased())
        
        let numberStr = (String(format: "%.2f", (1.0/currency.rateToRub))).replacingOccurrences(of: ".", with: ".")
        
        cell.currencyLabel.text = "\(currency.code.uppercased())"
        cell.numberLabel.text = numberStr
        
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
}


