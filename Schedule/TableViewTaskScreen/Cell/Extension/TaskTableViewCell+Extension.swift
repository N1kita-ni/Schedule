//
//  TaskTableViewCell+Extension.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/26/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import UIKit

extension TableViewTaskCell {
    
    func setTaskConstraintsInCell() {
//        addSubview(viewInCell)
//        NSLayoutConstraint.activate([
//            viewInCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            viewInCell.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//            viewInCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            viewInCell.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
//            ])
//
        addSubview(labelInViewInCell)
        NSLayoutConstraint.activate([
            labelInViewInCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelInViewInCell.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
