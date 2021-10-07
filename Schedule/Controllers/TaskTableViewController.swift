//
//  MakeTaskViewController.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/25/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import UIKit
import UserNotifications

final class TaskTableViewController: UITableViewController {
    
    private var scheduleModel = ModelRealm()
    private let idCellTask = "taskCell"
    
    private let cellNameArray = [["Date", "Time"],
                         ["Main Task", "Location"],
                         ["Difficalt", "Importanse"]]
    
    private let headerNameArray = ["Date And Time", "Task", "Importanse and difficalts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        title = "Create Task"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewTaskCell.self, forCellReuseIdentifier: idCellTask)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
        
    }
    
    deinit {
        print("djghd")
    }
    
    @objc private func saveButton() {
        if scheduleModel.scheduleName.isEmpty {
            alertForNameNecessarily(text: "Input main task")
        } else {
            RealmManager.shared.saveScheduleModel(model: scheduleModel)
            scheduleModel = ModelRealm() // обновление модели чтобы не падало
            tableView.reloadData()
        }
    }
    
    private func alertDate(label: UILabel, complitionHandler: @escaping (Date) ->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Input date", message: nil, preferredStyle: .actionSheet)
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            // datePicker.locale = NSLocale(localeIdentifier: "ru_RU") as Locale
            alert.view.addSubview(datePicker)
            
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let dateString = dateFormatter.string(from: datePicker.date)
                let date = datePicker.date
                complitionHandler(date)
                label.text = dateString
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
            datePicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func alertTime(label: UILabel, complitionHandler: @escaping (Date) ->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Input time", message: nil, preferredStyle: .actionSheet)
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            // datePicker.locale = NSLocale(localeIdentifier: "ru_RU") as Locale
            // datePicker.date.description(with: .current)
            alert.view.addSubview(datePicker)
            
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let timeString = dateFormatter.string(from: datePicker.date)
                let timeSchedule = datePicker.date
                complitionHandler(timeSchedule)
                
                label.text = timeString
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
            
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
            datePicker.heightAnchor.constraint(equalToConstant: 160).isActive = true
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
            
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func alerForName(label: UILabel, name: String, placeholder: String, complitionHandler: @escaping ((String) -> ())) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: name, message: nil, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default) { [weak self] (action) in
                let alertTF = alert.textFields?.first
                guard let text = alertTF?.text else { return }
                if text.isEmpty || text.first == " " {
                    self?.alertForNameNecessarily(text: "The string can't start with a space or be empty")
                } else if text.count > 17 {
                    self?.alertForNameNecessarily(text: "Input lover 17 characters")
                } else {
                    let corrextText = text.trimmingCharacters(in: NSCharacterSet.whitespaces)
                    label.text = corrextText
                    complitionHandler(corrextText)
                }
            }
            
            alert.addTextField(configurationHandler: { (alertTF) in
                alertTF.placeholder = placeholder
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private  func alertForNameNecessarily(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension TaskTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1,2: return 2
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCellTask, for: indexPath) as? TableViewTaskCell
        cell?.cellConfigure(text: cellNameArray[indexPath.section][indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0,1,2: return headerNameArray[section]
        default: return " "
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 200
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? TableViewTaskCell
        switch indexPath {
        case [0,0]: return alertDate(label: (cell?.labelInViewInCell ?? UILabel()), complitionHandler: { [weak self] (date) in
            self?.scheduleModel.scheduleDate = date
        })
        case [0,1]: return alertTime(label: (cell?.labelInViewInCell ?? UILabel()), complitionHandler: { [weak self] (time) in
            self?.scheduleModel.scheduleTime = time
        })
        case [1,0]: return alerForName(label: (cell?.labelInViewInCell ?? UILabel()), name: "Name for main task", placeholder: "Enter name task") { [weak self] text in
            self?.scheduleModel.scheduleName = text
            }
        case [1,1]: return alerForName(label: (cell?.labelInViewInCell ?? UILabel()), name: "Location", placeholder: "Enter location") { [weak self] location in
            self?.scheduleModel.sceduleLocation = location
            }
        case [2,0]: return alerForName(label: (cell?.labelInViewInCell ?? UILabel()), name: "Difficult", placeholder: "Difficult") {
            [weak self] difficult in
            self?.scheduleModel.scheduleDifficult = difficult
            }
        case [2,1]: return alerForName(label: (cell?.labelInViewInCell ?? UILabel()), name: "Importance", placeholder: "Importance") {
            [weak self] importance in
            self?.scheduleModel.scheduleImportance = importance
            }
        default:
            print("kljsdf")
        }
    }
}
