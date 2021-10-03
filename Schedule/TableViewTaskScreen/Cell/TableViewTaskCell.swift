//
//  TableViewTaskCell.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/26/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import UIKit

class TableViewTaskCell: UITableViewCell {
    
    let labelInViewInCell: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        setTaskConstraintsInCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func setTaskConstraintsInCell() {
        addSubview(labelInViewInCell)
        NSLayoutConstraint.activate([
            labelInViewInCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelInViewInCell.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }

    func cellConfigure(text: String) {
        labelInViewInCell.text = text
    }
}
