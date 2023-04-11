//
//  UIView+Extension.swift
//  Itunes
//
//  Created by bhoopendra.umrao on 02/09/22.
//

import UIKit

extension UIView {

    /// Show activitiy indicator
    func showIndicator() {
        let indicator = ActivityIndicatorView(forView: self)
        indicator.restorationIdentifier = "activityIndicatorView"
    }

    /// Hide activity indicator
    func hideIndicator() {
        for subview in self.subviews where subview.restorationIdentifier == "activityIndicatorView" {
            subview.removeFromSuperview()
        }
    }
}
