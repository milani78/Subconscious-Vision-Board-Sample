//
//  PECCustomLabel.swift
//  PECRealityProgramming
//
//  Created by Inga on 4/25/17.
//  Copyright © 2017 Inga. All rights reserved.
//

import UIKit

open class PECCustomLabel: UILabel {

    @IBInspectable open var characterSpacing: CGFloat = 1 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSKernAttributeName, value: self.characterSpacing, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
        
    }

}
