//
//  CurrencyCell.swift
//  stonks͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit

class CurrencyCell: UITableViewCell {
    @IBOutlet weak var currencyCellView: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var flagView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyLabelView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    func setupApperance() {
        setShape()
        setColor()
    }
    
    private func setShape() {
        let radius = backView.frame.height / 2
        backView.layer.cornerRadius = radius
        currencyCellView.layer.cornerRadius = currencyCellView.frame.height / 2
        setCircleLayer(for: flagImageView)
        setCircleLayer(for: flagView)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        
        currencyLabel.numberOfLines = 1
        currencyLabel.adjustsFontSizeToFitWidth = true
        currencyLabel.minimumScaleFactor = 0.01
        numberLabel.numberOfLines = 1
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.minimumScaleFactor = 0.01
    }
    
    private func setColor() {
        backView.backgroundColor = C.colors.cellsMain
        currencyLabelView.backgroundColor = C.colors.cellsMain
        backgroundColor = .clear
        
    }
    
    private func setCircleLayer(for view: UIView) {
        
        let CircleLayer = CAShapeLayer()
        let center = CGPoint (x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        let circleRadius = view.frame.size.height / 2
        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 4), clockwise: true)
        CircleLayer.path = circlePath.cgPath
        view.layer.mask = CircleLayer
        view.contentMode = .scaleAspectFill
       
    }
    
    override internal func setSelected(_ selected: Bool, animated: Bool) {
        if (selected) {
            numberLabel.textColor = C.text.color.accentText
            currencyLabel.textColor = C.text.color.accentText
            
            numberLabel.font = UIFont(name: "Courier New Bold", size: 30)
            currencyLabel.font = UIFont(name: "Courier New Bold", size: 30)
            
            setCircleLayer(for: flagImageView)
            setCircleLayer(for: flagView)
            currencyCellView.backgroundColor = C.colors.outline
            flagImageView.backgroundColor = C.colors.outline
    
        } else {
            numberLabel.textColor = C.text.color.cuttedOutText
            currencyLabel.textColor = C.text.color.cuttedOutText
            
            numberLabel.font = UIFont(name: "Courier New", size: 22)
            currencyLabel.font = UIFont(name: "Courier New", size: 22)
            
            currencyCellView.backgroundColor = .clear
            flagImageView.backgroundColor = C.colors.background
            
            setCircleLayer(for: flagImageView)
            setCircleLayer(for: flagView)
        }
    }
    
    override internal func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
    }
    
}
