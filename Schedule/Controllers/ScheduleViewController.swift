//
//  ViewController.swift
//  Schedule
//
//  Created by Никита Ничепорук on 8/21/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import UIKit
import FSCalendar
import SwiftConfettiView
import RealmSwift
import UserNotifications

final class ScheduleViewController: UIViewController {
    
    var calendarHideConstrain: NSLayoutConstraint!
    var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    
    let openHideCalendar: UIButton = {
        let button = UIButton()
        button.setTitle("Open calendar", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let idCell = "cell"
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let confettiView: SwiftConfettiView = {
        let confettiView = SwiftConfettiView()
        confettiView.type = .confetti
        confettiView.intensity = 1.5
        return confettiView
    }()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let localRealm = try! Realm()
    private var scheduleModel: Results<ModelRealm>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        animatedCell()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: idCell)
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20 
        setConstraints() // VC+Constr
        
        openHideCalendar.addTarget(self, action: #selector(changeStateCalendar), for: .touchUpInside)
        
        calendar.scope = .week
        openCloseSwipeCalendar()
        scheduleOnDate(date: Date())
        
        view.addSubview(confettiView)
         print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (permissionGranted, error) in
            if (!permissionGranted) {
                print("Permission denied")
            }
        }
        
    }
    
    @objc private func changeStateCalendar() {
        if calendar.scope == .month {
            calendar.setScope(.week, animated: true)
            openHideCalendar.setTitle("Open calendar", for: .normal)
        } else {
            calendar.setScope(.month, animated: true)
            openHideCalendar.setTitle("Close calendar", for: .normal)
        }
    }
    
    private func openCloseSwipeCalendar() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(closeCalendar))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(openCalendar))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
    }
    
    @objc private func openCalendar() {
        changeStateCalendar()
    }
    
    @objc private func closeCalendar() {
        changeStateCalendar()
    }
    
    @IBAction private func addTaskButton(_ sender: Any) {
        let taskScrenn = TaskTableViewController()
        navigationController?.pushViewController(taskScrenn, animated: true)
    }
    
    private func shareTask(model: ModelRealm) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let activityVC = UIActivityViewController(activityItems: ["Нужно сделать: \(model.scheduleName)", "Где: \(model.sceduleLocation)", "Когда: \(dateFormatter.string(from: model.scheduleDate))", "Во сколько: \(timeFormatter.string(from: model.scheduleTime))"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func scheduleNotification(model: ModelRealm) {
        notificationCenter.getNotificationSettings { [weak self] (settings) in
            DispatchQueue.main.async {
                if(settings.authorizationStatus == .authorized) {
                    let content = UNMutableNotificationContent()
                    content.title = model.scheduleName
                    content.body = model.sceduleLocation
                    content.badge = 1
                    let calendar = Calendar(identifier: .gregorian)
                    let dateComp = calendar.dateComponents([.hour, .minute], from: model.scheduleTime)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    self?.notificationCenter.add(request, withCompletionHandler: { (error) in
                        if error != nil {
                            print("Error " + error.debugDescription)
                            return
                        }
                    })
                    let ac = UIAlertController(title: "Notification schedule", message: "At " + (self?.dateFormatter(date: model.scheduleTime) ?? ""), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    ac.addAction(ok)
                    self?.present(ac, animated: true, completion: nil)
                    
                } else {
                    
                    let ac = UIAlertController(title: "Enabled notification?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default, handler: { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        
                        if UIApplication.shared.canOpenURL(settingsURL) {
                            UIApplication.shared.open(settingsURL, completionHandler: { (_) in })
                        }
                    })
                    ac.addAction(goToSettings)
                    ac.addAction(cancel)
                    self?.present(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func dateFormatter (date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y HH:mm"
        return(formatter.string(from: date))
    }
    
    private func animatedCell() {
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.width
        var delay: Double = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableViewHeight, y: 0)
            UIView.animate(withDuration: 2.0,
                           delay: delay * 0.2,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delay += 1
        }
    }
    
    //    private func createLayer() {
    //        UIView.animate(withDuration: 0.8) {
    //            let layer = CAEmitterLayer()
    //            layer.emitterPosition = CGPoint(x: self.view.center.x,
    //                                            y: -100)
    //            let colors: [UIColor] = [
    //                .red,
    //                .blue,
    //                .yellow,
    //                .purple,
    //                .orange,
    //                .green
    //            ]
    //            let cells: [CAEmitterCell] = colors.compactMap {
    //                let cell = CAEmitterCell()
    //                cell.scale = 0.01
    //                cell.emissionRange = .pi * 2
    //                cell.lifetime = 20
    //                cell.birthRate = 100
    //                cell.velocity = 200
    //                cell.color = $0.cgColor
    //                cell.contents = UIImage(named: "square")?.cgImage
    //                return cell
    //            }
    //            layer.emitterCells = cells
    //            self.view.layer.addSublayer(layer)
    //        }
    //    }
   
    func scheduleOnDate(date: Date) {
        let dateStart = date
        let dateEnd: Date = {
            let componentsDate = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: componentsDate, to: dateStart) ?? Date()
        }()
        
        let predicate = NSPredicate(format: "scheduleDate BETWEEN %@", [dateStart, dateEnd])
        scheduleModel = localRealm.objects(ModelRealm.self).filter(predicate).sorted(byKeyPath: "scheduleTime")
        
        tableView.reloadData()
        animatedCell()
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? TableViewCell
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = UIColor.white.cgColor
        cell?.clipsToBounds = true
        cell?.backgroundColor = #colorLiteral(red: 0.8188039878, green: 0.72494196, blue: 1, alpha: 1)
        let model = scheduleModel[indexPath.row]
        cell?.configuratedCell(model: model)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteRow = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            DatabaseConnection.shared.deleteScheduleModel(model: self?.scheduleModel[indexPath.row] ?? ModelRealm())
            tableView.reloadData()
        }
        
        let shareRow = UIContextualAction(style: .normal, title: "Share") { [weak self] (_, _, _) in
            let model = self?.scheduleModel[indexPath.row]
            self?.shareTask(model: model ?? ModelRealm())
        }
        
        let notification = UIContextualAction(style: .normal, title: "Notif") { [weak self] (_, _, _) in
            let model = self?.scheduleModel[indexPath.row]
            self?.scheduleNotification(model: model ?? ModelRealm())
        }
        shareRow.image = UIImage(named: "export")
        shareRow.backgroundColor = #colorLiteral(red: 0.4171677177, green: 0.500941595, blue: 1, alpha: 1)
        deleteRow.image = UIImage(named: "delete")
        notification.image = UIImage(named: "ringing")
        notification.backgroundColor = #colorLiteral(red: 1, green: 0.7705384644, blue: 0.5898889282, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteRow, shareRow, notification])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complitedTask = UIContextualAction(style: .normal, title: "Success") { [weak self] (_, _, _) in
            self?.confettiView.startConfetti()
            
            let alert = UIAlertController(title: "Congratulation", message: "Success", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self?.confettiView.stopConfetti()
            })
            DatabaseConnection.shared.deleteScheduleModel(model: (self?.scheduleModel[indexPath.row])!)
            tableView.reloadData()
            
            alert.addAction(ok)
            self?.present(alert, animated: true, completion: nil)
        }
        complitedTask.image = UIImage(named: "tick1")
        complitedTask.backgroundColor = #colorLiteral(red: 0.5628719945, green: 0.8161322215, blue: 0.5752952532, alpha: 1)
        return UISwipeActionsConfiguration(actions: [complitedTask])
    }
    
  //  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
//        let degree: Double = 90
//        let rotationAngle = CGFloat(degree * .pi / 180)
//        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
//        cell.layer.transform = rotationTransform
//
//        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
//            cell.layer.transform = CATransform3DIdentity
//        })
//                        let translationForm = CATransform3DTranslate(CATransform3DIdentity, -500, 400, 0)
//                        cell.layer.transform = translationForm
//
//
//                    UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseInOut, animations: {
//                        cell.layer.transform = CATransform3DIdentity
//                    })
  //  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

