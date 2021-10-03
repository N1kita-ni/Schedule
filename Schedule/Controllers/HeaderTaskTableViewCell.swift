//
//  HeaderTaskTableViewCell.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/28/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import UIKit

class HeaderTaskTableViewCell: UITableViewHeaderFooterView {

    let headerLabel = UILabel(text: "Header", font: UIFont(name: "Avenir Next", size: 14), alignment: .left)
        
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setConstr()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstr() {
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
            ])
    }
}
