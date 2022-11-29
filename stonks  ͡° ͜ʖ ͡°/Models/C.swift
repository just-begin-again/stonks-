//
//  C.swift
//  stonks͡° ͜ʖ ͡°
//
//  Created by Roman Sushkevich on 11/29/22.
//

import UIKit

struct C {
    
    static let cellIdentifier = "reusableCell"
    
    struct net {
        static let urlStr = "https://www.cbr-xml-daily.ru/latest.js"
        
        private init() {}
    }
    
    struct colors {
        static let background = UIColor(hex: "F9F7F7")
        static let accent = UIColor(hex: "173e6f")
        static let secondary = UIColor(hex: "3F72AF")
        
        static let cellsMain = UIColor(hex: "CDD3E0")
        
        static var outline: UIColor {accent}
        
        private init() {}
    }
    
    struct text {
        
        struct size {
            static let cells = 25
            static let heading = 40
            static let subheading = 30
            
            private init() {}
        }
        
        struct color {
            static var cuttedOutText = UIColor(hex: "F9F7F7")
            static var accentText = UIColor(hex: "173e6f")
            static var secondaryText = UIColor(hex: "3F72AF")
            
            private init() {}
        }
        
        struct font {
            static let main = "VoxRoundWide-Light"
            static let alt = "Hurme"
            
            private init() {}
        }
        private init() {}
    }
    
    private init() {}
}
