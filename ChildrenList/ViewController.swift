//
//  ViewController.swift
//  ChildrenList
//
//  Created by Дэлина Дворжецкая on 24.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var personsChildren = [Child]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.alpha = 0
        tableView.alpha = 0
        deleteButton.alpha = 0
    }

    @IBAction func nextButtonPressed() {
        guard let nameIn = nameTF.text, !nameIn.isEmpty else {
            showAlert(title: "Пустое поле", message: "Введите ваше ФИО")
            return
        }
        guard let ageIn = ageTF.text, !ageIn.isEmpty else {
            showAlert(title: "Пустое поле", message: "Введите ваш возраст")
            return
        }
        
        personLabel.text = "\(nameIn), \(ageIn)"
        addButton.alpha = 1
        tableView.alpha = 1
        deleteButton.alpha = 1
    }
    
    @IBAction func addButtonPressed() {
        if personsChildren.count < 5 {
            addChild()
        }
    }
    
    @IBAction func deleteButtonPressed() {
        actionSheet()
    }
}

extension ViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func actionSheet() {
        let actionSheet = UIAlertController(title: "Очистка данных", message: "Вы действительно хотите очистить данные?", preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: "Сбросить данные", style: .default) { _ in
            self.personsChildren.removeAll()
            self.tableView.reloadData()
            
            self.nameTF.text = ""
            self.ageTF.text = ""
            self.personLabel.text = ""
            
            self.addButton.alpha = 0
            self.deleteButton.alpha = 0
        }
        let noAction = UIAlertAction(title: "Отмена", style: .cancel)
        actionSheet.addAction(yesAction)
        actionSheet.addAction(noAction)
        
        present(actionSheet, animated: true)
    }
    
    private func addChild() {
        let alert = UIAlertController(title: "Добавить ребенка", message: nil, preferredStyle: .alert)
        alert.addTextField { (childNameTF) in
            childNameTF.placeholder = "Введите имя"
        }
        alert.addTextField { (childAgeTF) in
            childAgeTF.placeholder = "Введите возраст"
        }
        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            guard let childName = alert.textFields?.first?.text else { return }
            guard let childAge = alert.textFields?[1].text else {return}
            self.personsChildren.append(Child(name: childName, age: childAge))
            self.tableView.reloadData()
            
            if self.personsChildren.count >= 5 {
                self.addButton.alpha = 0
            }
        }
        alert.addAction(addAction)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personsChildren.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        let childInfo = personsChildren[indexPath.row].info
        content.text = childInfo
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        personsChildren.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if personsChildren.count < 5 {
            addButton.alpha = 1
        }
    }
}
