//
//  TableViewCell.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/25/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import Foundation
import UIKit

final class TableViewCell: UITableViewCell {

    let taskName = UILabel(text: "", font: UIFont(name: "Times New Roman", size: 25), alignment: .left)
    let location: UILabel = UILabel(text: "", font: UIFont(name: "Times New Roman", size: 25), alignment: .right)
    let time = UILabel(text: "", font: UIFont(name: "Times New Roman", size: 25), alignment: .left)
    let complexityType = UILabel(text: "", font: UIFont(name: "Times New Roman", size: 15), alignment: .left)
    let importanceType = UILabel(text: "", font: UIFont(name: "Times New Roman", size: 15), alignment: .left)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        DispatchQueue.main.async { [weak self] in
            self?.setConstraintsTableViewCell()
        }
        selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuratedCell(model: ModelRealm) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        taskName.text = model.scheduleName
        location.text = model.sceduleLocation
        time.text = dateFormatter.string(from: model.scheduleTime)
        complexityType.text = model.scheduleDifficult
        importanceType.text = model.scheduleImportance
    }
}


