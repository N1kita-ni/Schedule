//
//  TableViewCell+Extension.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/25/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import UIKit

extension TableViewCell {
    
    func setConstraintsTableViewCell() {
        
        let mainStackView = UIStackView(arrangedSubviews: [taskName, location],
                                    axis: .horizontal,
                                    spacing: 10,
                                    distribution: .fillEqually)
        self.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainStackView.heightAnchor.constraint(equalToConstant: 30)
            
            ])
        
        self.addSubview(time)
        NSLayoutConstraint.activate([
            time.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            time.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            time.widthAnchor.constraint(equalToConstant: 50),
            time.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        let secondaryStackView = UIStackView(arrangedSubviews: [complexityType, importanceType],
                                             axis: .horizontal,
                                             spacing: 5,
                                             distribution: .fillEqually)
        addSubview(secondaryStackView)
        NSLayoutConstraint.activate([
            secondaryStackView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 1),
            secondaryStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            secondaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            secondaryStackView.leadingAnchor.constraint(equalTo: time.trailingAnchor, constant: 50)
            ])
        
    }
}
