//
//  GJDesignable.swift
//  Contacts
//
//  Created by Pawan on 02/03/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

@IBDesignable
class GJDesignableView: UIView {
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    @IBInspectable var shadowOffset : CGSize = CGSize(width: 0, height: 0){
        didSet{
            self.layer.shadowOffset = self.shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity : Float = 0{
        didSet{
            self.layer.shadowOpacity = self.shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius : CGFloat = 0{
        didSet{
            self.layer.shadowRadius = self.shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black{
        didSet{
            self.layer.shadowColor = self.shadowColor.cgColor
        }
    }
    
    @IBInspectable var gradientColor1: UIColor = UIColor.white{
        didSet{
            self.setGradient()
        }
    }
    
    @IBInspectable var gradientColor2: UIColor = UIColor.white{
        didSet{
            self.setGradient()
        }
    }
    
    @IBInspectable var gradientStartPoint: CGPoint = .zero{
        didSet{
            self.setGradient()
        }
    }
    
    @IBInspectable var gradientEndPoint: CGPoint = CGPoint(x: 0, y: 1){
        didSet{
            self.setGradient()
        }
    }
    
    private func setGradient()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [self.gradientColor1.cgColor, self.gradientColor2.cgColor]
        gradientLayer.startPoint = self.gradientStartPoint
        gradientLayer.endPoint = self.gradientEndPoint
        gradientLayer.frame = self.bounds
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer
        {
            topLayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

@IBDesignable
class GJDesignableButton: UIButton {
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}

@IBDesignable
class GJDesignableImageView: UIImageView {
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}

@IBDesignable
class GJDesignableCollectionViewCell: UICollectionViewCell {
    @IBInspectable var borderColor : UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            self.layer.cornerRadius = self.cornerRadius
        }
    }
}
