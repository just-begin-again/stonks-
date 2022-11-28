//
//  CurrencyCell.swift
//  stonks͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/27/22.
//

import UIKit

class CurrencyCell: UITableViewCell {
    @IBOutlet weak var currencyCellView: UIView!
    
    @IBOutlet weak var flagView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var currencyLabelView: UIView!
    @IBOutlet weak var currencyLabel: UILabel!
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        if (selected) {
    //            currencyLabel.textColor = UIColor(hex: "3F72AF")
    //        } else {
    //            currencyLabel.textColor = UIColor(hex: "F9F7F7")
    //        }
    //    }
    
    func setupApperance(for label: UILabel) {
        //        label.numberOfLines = 1
        //        label.font.withSize(25)
        //        label.adjustsFontSizeToFitWidth = true
        //        label.minimumScaleFactor = 0.01
        //        label.textColor = UIColor(hex: "F9F7F7")
        
    }
    
    func setCircleLayer(for view: UIView) {
        
        let CircleLayer = CAShapeLayer()
        let center = CGPoint (x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        let circleRadius = view.frame.size.height / 2
        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi * 4), clockwise: true)
        CircleLayer.path = circlePath.cgPath
        view.layer.mask = CircleLayer
        view.contentMode = .scaleAspectFill
    }
    
}

//MARK: - Color Hex
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            alpha: Double(a) / 255
        )
    }
}

extension UIImage {
    // image with rounded corners
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
