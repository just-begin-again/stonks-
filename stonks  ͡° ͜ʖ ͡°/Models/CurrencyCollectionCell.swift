//
//  CurrencyCollectionCell.swift
//  stonks͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 12/6/22.
//

import UIKit
import SnapKit

class CurrencyCollectionCell: UICollectionViewCell {
    var currencyCellView = UIView()
    var backView = UIView()
    
    var flagView = UIView()
    var flagImageView = UIImageView()
    var currencyLabelView = UIView()
    var numberLabel = UILabel()
    var currencyLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureViews()
    }
    
    func configureViews() {
        self.addSubview(currencyCellView)
        
        //currencCellView
        currencyCellView.addSubview(backView)
        currencyCellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //backView
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        }
        backView.frame.size.height = 60
        backView.addSubview(flagView)
        backView.addSubview(currencyLabelView)
        
        //flagView
        flagView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-30)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        //currencyLabelView
        currencyLabelView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalTo(flagView.snp.trailing)
        }
        
        flagView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.33)
        }
        
        flagView.addSubview(flagImageView)
        
        //flagImageView
        flagImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        currencyLabelView.addSubview(currencyLabel)
        currencyLabelView.addSubview(numberLabel)
        
        
        //currencyLabel
        currencyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-35)
            make.top.bottom.equalToSuperview()
            
        }
        
        //numberLabel
        numberLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
//        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        
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
    
    func toggleSelected() {
        if (isSelected) {
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
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5
            
            frame.size.height -= 5
            
            super.frame = frame
        }
    }
    
}
