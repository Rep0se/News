//
//  UIView+Extension.swift
//  News
//
//  Created by Alexander Sundiev on 2019-12-19.
//  Copyright © 2019 Alexander Sundiev. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     A convenience method which allows to anchor objects to other objects and views.
     - Parameter top: Top Anchor.
     - Parameter left: Left Anchor.
     - Parameter bottom: Bottom Anchor.
     - Parameter right: Right Anchor.
     */
    func anchorTo(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsTo(top: top, left: left, bottom: bottom, right: right, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0)
    }
    
    /**
     A convenience method which allows to anchor objects to other objects and views with padding constatnts.
     - Parameter top: Top Anchor.
     - Parameter left: Left Anchor.
     - Parameter bottom: Bottom Anchor.
     - Parameter right: Right Anchor.
     - Parameter topPadding: Top Padding.
     - Parameter leftPadding: Left Padding.
     - Parameter bottomPadding: Bottom Padding.
     - Parameter rightPadding: Right Padding.
     */
    func anchorWithConstantsTo(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topPadding: CGFloat = 0, leftPadding: CGFloat = 0, bottomPadding: CGFloat = 0, rightPadding: CGFloat = 0) {
        
        _ = anchor(top, left: left, bottom: bottom, right: right, topPadding: topPadding, leftPadding: leftPadding, bottomPadding: bottomPadding, rightPadding: rightPadding)
    }
    
    /**
     A convenience method which allows to anchor objects to other objects and views with padding constatnts and width/height constants.
     - Parameter top: Top Anchor.
     - Parameter left: Left Anchor.
     - Parameter bottom: Bottom Anchor.
     - Parameter right: Right Anchor.
     - Parameter topPadding: Top Padding.
     - Parameter leftPadding: Left Padding.
     - Parameter bottomPadding: Bottom Padding.
     - Parameter rightPadding: Right Padding.
     - Parameter widthConstant: Width Constant.
     - Parameter heightConstant: Height Constant.
     */
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topPadding: CGFloat = 0, leftPadding: CGFloat = 0, bottomPadding: CGFloat = 0, rightPadding: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topPadding))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftPadding))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightPadding))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}
