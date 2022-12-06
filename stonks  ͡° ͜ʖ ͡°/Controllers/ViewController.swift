//
//  ViewController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var firstCurr = UIButton()
    var secondCurr = UIButton()
    
    var actions1: [UIAction] = []
    var actions2: [UIAction] = []
    
    var tableView = UITableView()
    
    var netContr = NetworkController()
    
    func setCircleLayer(for view: UIView) {
            
            let CircleLayer = CAShapeLayer()
            let center = CGPoint (x: view.frame.size.width / 2, y: view.frame.size.height / 2)
            let circleRadius = view.frame.size.height / 2
            let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 4), clockwise: true)
            CircleLayer.path = circlePath.cgPath
            view.layer.mask = CircleLayer
            view.contentMode = .scaleAspectFill
           
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = C.colors.background
        
        
        self.netContr.fetchJSON(urlStr: self.netContr.baseURL) { (result) in
            switch result {
            case .success(let data): self.netContr.parse(JSON: data)
            case .failure(let error): print(error)
            }
        }
        
        
        
        configureButtons()

        //        configureTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
        
        for curr in netContr.currencies {
            let atrib = [NSAttributedString.Key.font: UIFont(name: "Courier New", size: 22)!]
            
            let action1 = UIAction(title: curr.code.uppercased(), image: UIImage(named: curr.code.lowercased()), handler: { (action1) in
                self.firstCurr.setAttributedTitle(NSAttributedString(string: action1.title, attributes: atrib), for: .normal)
                self.firstCurr.setImage(action1.image, for: .normal)
                self.firstCurr.configuration?.imagePlacement = .leading

                self.firstCurr.imageView?.snp.makeConstraints({ make in
                    make.height.width.equalTo(50)
                    make.centerY.equalToSuperview()
                    make.left.equalTo(20)
                })
                self.firstCurr.setNeedsUpdateConfiguration()
            })
            actions1.append(action1)
            
            let action2 = UIAction(title: curr.code.uppercased(), image: UIImage(named: curr.code.lowercased()), handler: { (action2) in
                self.secondCurr.setAttributedTitle(NSAttributedString(string: action2.title, attributes: atrib), for: .normal)
                self.secondCurr.setImage(action2.image, for: .normal)
                self.secondCurr.configuration?.imagePlacement = .trailing
                self.secondCurr.imageView?.snp.makeConstraints({ make in
                    make.height.width.equalTo(50)
                    make.centerY.equalToSuperview()
                    make.right.equalTo(-20)
                })
                self.secondCurr.setNeedsUpdateConfiguration()
            })
            actions2.append(action2)
        }
        
        
        
        configureButtons()
                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPopOver" {
            if let view = segue.destination as? CollectionViewController {
                view.popoverPresentationController?.delegate = self
                view.preferredContentSize = CGSize(width: 160, height: 100)
                view.delegate = self
            }
        }
    }
    
    func configureButtons() {
        
        view.addSubview(firstCurr)
        view.addSubview(secondCurr)
        
        firstCurr.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height-80)-(view.frame.height/12)), left: 20, bottom: view.frame.height/12, right: (view.frame.width/2)+20))
        }
        
        secondCurr.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height-80)-(view.frame.height/12)), left: (view.frame.width/2)+20, bottom: view.frame.height/12, right: 20))
        }
        
        
        var config = UIButton.Configuration.filled()
        config.title = "1"
        config.titlePadding = 10
        
        config.image = UIImage(systemName: "hand.tap")
        config.imagePlacement = .trailing
        config.imagePadding = 10
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
        
        config.baseForegroundColor = C.text.color.mainText
        config.baseBackgroundColor = C.colors.background
        config.background.strokeColor = C.colors.cellsMain
        config.background.strokeWidth = 2
        config.cornerStyle = .capsule
        config.buttonSize = .large
        config.attributedTitle?.font = UIFont(name: "Courier New", size: 22)
//        config.showsActivityIndicator = true
        
        firstCurr.configuration = config
        secondCurr.configuration = config
        
        
        
        firstCurr.menu = UIMenu(children: actions1)
        secondCurr.menu = UIMenu(children: actions2)
        
        firstCurr.showsMenuAsPrimaryAction = true
        secondCurr.showsMenuAsPrimaryAction = true
        
        
        secondCurr.configuration?.baseBackgroundColor = firstCurr.configuration?.baseForegroundColor
        secondCurr.configuration?.baseForegroundColor = firstCurr.configuration?.baseBackgroundColor
        secondCurr.configuration?.imagePlacement = .leading
        secondCurr.configuration?.attributedTitle = "2"
        secondCurr.configuration?.attributedTitle?.font = UIFont(name: "Courier New", size: 22)
        secondCurr.configuration?.image = UIImage(systemName: "hand.tap.fill")
        
        
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

//MARK: - PassDataDelegate
extension ViewController: PassDataDelegate {
    func passData(_ data: String) {
        //        titleLabel.text = "Your hobby is \(data)!"
    }
}

//MARK: - UIPopoverPresentationControllerDelegate
extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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


