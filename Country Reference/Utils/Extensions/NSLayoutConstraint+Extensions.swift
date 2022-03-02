//
//  NSLayoutConstraint+Extensions.swift
//  Country Reference
//
//  Created by Kenan Alizadeh on 01.03.22.
//

import UIKit

extension Array where Element == NSLayoutConstraint {
    func activate() {
        forEach { $0.isActive = true }
    }
}
