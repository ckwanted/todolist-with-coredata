//
//  ViewController.swift
//  TodoList
//
//  Created by Mario Peñate Fariñas on 31/7/18.
//  Copyright © 2018 ckwanted. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var todos : [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
    }
    
    private func fetchData() {
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        
        do {
            let todos = try PersistenceService.context.fetch(fetchRequest)
            self.todos = todos
            self.tableView.reloadData()
        } catch {
            print("It has not been possible to recover the data")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addTodo(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Content"
        }
        
        let action = UIAlertAction(title: "Create", style: .default) { (_) in
            
            if let title = alert.textFields?.first?.text, let content = alert.textFields?.last?.text {
                
                let todo = Todo(context: PersistenceService.context)
                todo.title = title
                todo.content = content
                
                PersistenceService.saveContext()

                self.todos.append(todo)
                self.tableView.reloadData()
                
            }
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)

        cell.textLabel?.text = self.todos[indexPath.row].title
        cell.detailTextLabel?.text = self.todos[indexPath.row].content
        
        return cell
    }

}
