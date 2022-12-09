//
//  ViewController.swift
//  stonks  ͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let atrib = [NSAttributedString.Key.font: UIFont(name: "Courier New", size: 22)!]
    let atribBold = [NSAttributedString.Key.font: UIFont(name: "Courier New Bold", size: 22)!]
    
    var firstCurr = UIButton()
    var secondCurr = UIButton()
    
    var firstTextField = UITextField(frame: CGRect(x: 80, y: UIScreen.main.bounds.height, width: 0, height: 0))
    var resultButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var expandCurrButt = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var swapButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var actions1: [UIAction] = []
    var actions2: [UIAction] = []
    
    var tableView = UITableView()
    var isTableExpanded = false
    
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
        
        configureTextField()
        configureButtons()
        //configureTableView()
        configureNestedMenusAndAnimation()
        configureButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func convert() {
        if firstTextField.text != nil && firstTextField.text != "" {
            
            let animResultButton = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.linear, animations: { [weak self] in
                self?.resultButton.snp.makeConstraints { make in
                    self?.view.addSubview(self!.resultButton)
                    self!.resultButton.isHidden = false
                    self!.resultButton.layer.opacity = 1.0
                    make.centerY.equalTo(self!.firstTextField.snp.centerY)
                }
                
                self?.view.layoutIfNeeded()
            })
            
            let animExpandButton = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.linear, animations: { [weak self] in
                self?.expandCurrButt.snp.makeConstraints { make in
                    self?.view.addSubview(self!.expandCurrButt)
                    self!.expandCurrButt.isHidden = false
                    self!.expandCurrButt.layer.opacity = 1.0
                    make.centerX.equalToSuperview()
                }
                
                self?.view.layoutIfNeeded()
            })
            
            let secondToFirstRate =  netContr.currenciesDict[secondCurr.titleLabel!.text!]! / netContr.currenciesDict[firstCurr.titleLabel!.text!]!
            let amount = Double(firstTextField.text!)!
            
            self.resultButton.setAttributedTitle(NSAttributedString(string: (amount * secondToFirstRate).formattedWithSeparator, attributes: self.atribBold), for: .normal)
            
            
            self.resultButton.titleLabel?.numberOfLines = 1
            if (resultButton.titleLabel?.text!.count)! > 10 {
                
                //                resultButton.configuration?.attributedTitle?.font = UIFont(name: "Courier New Bold", size: 14)
                resultButton.titleLabel?.adjustsFontSizeToFitWidth = true
                resultButton.titleLabel?.minimumScaleFactor = 0.2
            }
            
            firstTextField.resignFirstResponder()
            
            animResultButton.startAnimation()
            animExpandButton.startAnimation()
        }
    }
    
    func configureButtons() {
        
        view.addSubview(firstCurr)
        view.addSubview(secondCurr)
        view.addSubview(resultButton)
        view.addSubview(swapButton)
        view.addSubview(expandCurrButt)
        
        firstCurr.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height-80)-(view.frame.height/12)), left: 20, bottom: view.frame.height/12, right: (view.frame.width/2)+20))
        }
        
        secondCurr.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height-80)-(view.frame.height/12)), left: (view.frame.width/2)+20, bottom: view.frame.height/12, right: 20))
        }
        
        resultButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height-80)-(view.frame.height/24)), left: (view.frame.width/2)+20, bottom: view.frame.height/12, right: 20))
            
        }
        
        swapButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(secondCurr.snp.top).offset(-10)
        }
        
        expandCurrButt.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height+20)-(view.frame.height/12)), left: 20, bottom: view.frame.height/48, right: 20))
            
        }
        
        var swapConfig = UIButton.Configuration.filled()
        swapConfig.image = UIImage(systemName: "arrow.left.arrow.right")
        swapConfig.imagePlacement = .bottom
        swapConfig.baseBackgroundColor = .clear
        swapConfig.baseForegroundColor = C.colors.cellsMain
        swapButton.imageView?.snp.makeConstraints({ make in
            make.width.equalTo(50)
            make.height.equalTo(50)
        })
        swapButton.configuration = swapConfig
        swapButton.isHidden = true
        swapButton.layer.opacity = 0
        swapButton.addTarget(self, action: #selector(self.swapPressed), for: .touchUpInside)
        
        
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
        
        
        var resultConfig = UIButton.Configuration.filled()
        resultConfig.title = "result"
        resultConfig.titlePadding = 10
        
        
        resultConfig.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4)
        
        resultConfig.baseForegroundColor = C.colors.background
        resultConfig.baseBackgroundColor = C.text.color.mainText
        
        
        resultConfig.cornerStyle = .capsule
        resultConfig.buttonSize = .large
        resultConfig.attributedTitle?.font = UIFont(name: "Courier New Bold", size: 22)
        resultButton.configuration = resultConfig
        resultButton.isHidden = true
        resultButton.layer.opacity = 0
        resultButton.isUserInteractionEnabled = false
        
        expandCurrButt.configuration = resultConfig
        expandCurrButt.configuration?.title = "show the rest"
        expandCurrButt.configuration?.attributedTitle?.font = UIFont(name: "Courier New Bold", size: 16)
        expandCurrButt.isHidden = true
        expandCurrButt.layer.opacity = 0
        expandCurrButt.addTarget(self, action: #selector(self.expandPressed), for: .touchUpInside)
        
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
    
    func configureTextField() {
        view.addSubview(firstTextField)
        firstTextField.layer.opacity = 0
        
        firstTextField.delegate = self
        firstTextField.keyboardType = .decimalPad
        firstTextField.textColor = C.colors.cellsMain
        
        firstTextField.backgroundColor = C.colors.background
        firstTextField.attributedPlaceholder = NSAttributedString(string: "enter amount", attributes: atrib)
        firstTextField.font = UIFont(name: "Courier New Bold", size: 18)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Convert", style: .plain, target: self,
                                     action: #selector(convert))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        firstTextField.inputAccessoryView = toolBar
        
    }
    
    func configureNestedMenusAndAnimation() {
        
        let anim = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.linear, animations: { [weak self] in
            self?.firstCurr.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: (((self?.view.frame.height)!-80)-((self?.view.frame.height)!/6)), left: 20, bottom: (self?.view.frame.height)!/6, right: ((self?.view.frame.width)!/2)+20))
            }
            
            
            self?.view.layoutIfNeeded()
        })
        
        let anim2 = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.linear, animations: { [weak self] in
            self?.secondCurr.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: (((self?.view.frame.height)!-80)-((self?.view.frame.height)!/6)), left: ((self?.view.frame.width)!/2)+20, bottom: (self?.view.frame.height)!/6, right: 20))
            }
            self?.view.layoutIfNeeded()
        })
        
        let animTextField = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.linear, animations: { [weak self] in
            
            self?.firstTextField.layer.opacity = 1
            
            
            self?.firstTextField.snp.makeConstraints({ make in
                make.width.equalTo(self!.firstCurr)
                make.centerX.equalTo(self!.firstCurr)
                make.top.equalTo(self!.firstCurr.snp.bottom).offset(10)
                make.height.equalTo(self!.firstCurr.frame.height/2)
            })
            
            self?.view.layoutIfNeeded()
        })
        
        let animSwapButton = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.linear, animations: { [weak self] in
            
            self?.swapButton.layer.opacity = 1
            self?.swapButton.isHidden = false
            
            
            self?.view.layoutIfNeeded()
        })
        
        for curr in netContr.currencies {
            
            let action1 = UIAction(title: curr.code.uppercased(), image: UIImage(named: curr.code.lowercased()), handler: { (action1) in
                self.firstCurr.setAttributedTitle(NSAttributedString(string: action1.title, attributes: self.atrib), for: .normal)
                self.firstCurr.setImage(action1.image, for: .normal)
                self.firstCurr.configuration?.imagePlacement = .leading
                
                self.firstCurr.imageView?.snp.makeConstraints({ make in
                    make.height.width.equalTo(50)
                    make.centerY.equalToSuperview()
                    make.left.equalTo(20)
                    
                })
                
                self.firstCurr.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((self.view.frame.height-80)-(self.view.frame.height/8)), left: 20, bottom: self.view.frame.height/8, right: (self.view.frame.width/2)+20))
                }
                
                self.firstCurr.setNeedsUpdateConfiguration()
                anim.startAnimation()
                if self.firstCurr.titleLabel?.text != "1" && self.secondCurr.titleLabel?.text != "2" {
                    animTextField.startAnimation()
                    animSwapButton.startAnimation()
                }
            })
            
            actions1.append(action1)
            
            let action2 = UIAction(title: curr.code.uppercased(), image: UIImage(named: curr.code.lowercased()), handler: { (action2) in
                self.secondCurr.setAttributedTitle(NSAttributedString(string: action2.title, attributes: self.atrib), for: .normal)
                self.secondCurr.setImage(action2.image, for: .normal)
                self.secondCurr.configuration?.imagePlacement = .trailing
                self.secondCurr.imageView?.snp.makeConstraints({ make in
                    make.height.width.equalTo(50)
                    make.centerY.equalToSuperview()
                    make.right.equalTo(-20)
                })
                self.secondCurr.setNeedsUpdateConfiguration()
                anim2.startAnimation()
                if self.firstCurr.titleLabel?.text != "1" && self.secondCurr.titleLabel?.text != "2" {
                    animTextField.startAnimation()
                    animSwapButton.startAnimation()
                }
            })
            actions2.append(action2)
        }
    }
    
   
    
    @objc func swapPressed() {
        
        //не пойму почему если снова обращаемся к непрозрачности и ставим хоть какое-то значение, то анимация скипается
        //устал, судя по всему, позже посижу с дебагом
//        func fadeOut(view : UIView, delay: TimeInterval) {
//
//            let animationDuration = 0.3
//
//            UIView.animate(withDuration: animationDuration, delay: delay, options: [UIView.AnimationOptions.beginFromCurrentState], animations: {
//
//                view.alpha = 0
//
//            }, completion: nil)
//
//        }
//
//        func fadeIn(view : UIView, delay: TimeInterval) {
//
//            let animationDuration = 0.6
//
//            UIView.animate(withDuration: animationDuration, delay: delay, options: [UIView.AnimationOptions.beginFromCurrentState], animations: {
//
//                view.alpha = 1
//
//            }, completion: nil)
//
//        }
//
//
//        fadeOut(view: firstCurr, delay: 0)
//        fadeOut(view: secondCurr, delay: 0)
//
        let tempCurrTitle = self.firstCurr.currentAttributedTitle
        let tempCurrImageName = self.firstCurr.currentImage
        
        self.firstCurr.setAttributedTitle(self.secondCurr.currentAttributedTitle, for: .normal)
        self.firstCurr.setImage(self.secondCurr.currentImage, for: .normal)

        self.secondCurr.setAttributedTitle(tempCurrTitle, for: .normal)
        self.secondCurr.setImage(tempCurrImageName, for: .normal)
        
//        fadeIn(view: firstCurr, delay: 0.3)
//        fadeIn(view: secondCurr, delay: 3)

        firstTextField.text = nil
        firstTextField.attributedPlaceholder = NSAttributedString(string: "enter amount", attributes: atrib)
        firstTextField.font = UIFont(name: "Courier New Bold", size: 18)

        let animFadeResultButton = UIViewPropertyAnimator(duration: 0.3, curve: UIView.AnimationCurve.linear, animations: { [weak self] in
            self!.resultButton.layer.opacity = 0
            self?.view.layoutIfNeeded()
        })

        animFadeResultButton.startAnimation()
        
    }
    @objc func expandPressed() {
        
        configureTableView()
        
        if isTableExpanded {
            
            tableView.layer.opacity = 0
            
            firstCurr.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height-80)-(view.frame.height/12)), left: 20, bottom: view.frame.height/12, right: (view.frame.width/2)+20))
            }
            
            secondCurr.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height-80)-(view.frame.height/12)), left: (view.frame.width/2)+20, bottom: view.frame.height/12, right: 20))
            }
            
            resultButton.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height-80)-(view.frame.height/24)), left: (view.frame.width/2)+20, bottom: view.frame.height/12, right: 20))
                
            }
            
            swapButton.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.centerX.equalToSuperview()
                make.centerY.equalTo(secondCurr.snp.top).offset(-10)
            }
            
            expandCurrButt.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: ((view.frame.height+20)-(view.frame.height/12)), left: 20, bottom: view.frame.height/48, right: 20))
                
            }
        } else {
            
            tableView.layer.opacity = 1
            
            firstCurr.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: view.safeAreaInsets.top+40, left: 20, bottom: (view.frame.height/3)+(view.safeAreaInsets.top+334), right: (view.frame.width/2)+20))
            }
            
            secondCurr.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: view.safeAreaInsets.top+40, left: (view.frame.width/2)+20, bottom: (view.frame.height/3)+(view.safeAreaInsets.top+334), right: 20))
            }
            
            resultButton.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: view.safeAreaInsets.top+131, left: (view.frame.width/2)+20, bottom: (view.frame.height/3)+(view.safeAreaInsets.top+374), right: 20))
                
            }
            
            swapButton.snp.makeConstraints { make in
                make.width.equalTo(50)
                make.height.equalTo(50)
                make.centerX.equalToSuperview()
                make.centerY.equalTo(secondCurr.snp.top).offset(-10)
            }
            
            expandCurrButt.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: view.safeAreaInsets.top+200, left: 20, bottom: view.safeAreaInsets.top+501, right: 20))
                
            }
        }
        
        isTableExpanded = !isTableExpanded
        
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


//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        convert()
        firstTextField.font = UIFont(name: "Courier New Bold", size: 22)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstTextField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let typedText = textField.text {       // What have we typed in?
            var dotCount = 0
            for c in typedText {  // count dot or comma
                if String(c) == "." || String(c) == "," {  dotCount += 1  }
            }
            if dotCount >= 2 {    // remove last typed
                textField.text = String(typedText.dropLast())
            }
        }
    }
}


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showPopOver" {
//            if let view = segue.destination as? CollectionViewController {
//                view.popoverPresentationController?.delegate = self
//                view.preferredContentSize = CGSize(width: 160, height: 100)
//                view.delegate = self
//            }
//        }
//    }
