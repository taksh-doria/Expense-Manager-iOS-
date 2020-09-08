//
//  ViewController.swift
//  Expense Manager
//
//  Created by Taksh on 12/08/20.
//  Copyright © 2020 Taksh Doria. All rights reserved.
//

import UIKit
import CoreData

class ExpenseViewController: UIViewController {


    @IBOutlet weak var searchbar: UISearchBar!
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    var expense_data:[Expense]?
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        searchbar.delegate=self
        tableview.delegate=self
        tableview.dataSource=self
        super.viewDidLoad()
         let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor=UIColor(named: "#A6808C")
        navigationItem.title="Previous Expenses"
        tableview.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "expense_item")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        loadItem()
    }
    @IBAction func addPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constant.Expense.expense_segue, sender: self)
    }
}
// MARK: -- Tableview datasource and delegate methods add data to view
extension ExpenseViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let expense=expense_data
        {
            return expense.count
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "expense_item", for: indexPath) as! CustomTableViewCell
        if let data=expense_data?[indexPath.row]
        {
            cell.title.text=data.exp_description
            cell.subtitle.text="\(String(describing: data.date!))"
            print(data.amount)
            cell.price.text="\(data.amount)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            if let data=expense_data
                  {
                   context.delete(data[indexPath.row])
                              self.expense_data?.remove(at: indexPath.row)
                              tableView.deleteRows(at: [indexPath], with: .automatic)
                              do
                              {
                                try context.save()
                                let controller=UIAlertController(title: "Deleted Succesfully", message: nil, preferredStyle: .alert)
                                let action=UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
                                controller.addAction(action)
                                self.present(controller, animated: true, completion: nil)
                              }
                          catch
                          {
                              print("error")
                          }
                          loadItem()
                   }
        }
    }
}

//MARK:: methods to load data from data base
extension ExpenseViewController
{
    func loadItem(request:NSFetchRequest<Expense>=Expense.fetchRequest())
    {
        print("loading items")
        do{
            self.expense_data=try self.context.fetch(request)
        }
        catch
        {
            print("error")
        }
        tableview.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let avc=segue.destination as! AddExpenseController
        avc.evc=self
    }
}
//MARK: search bar methods
extension ExpenseViewController:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0
        {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else
        {
            let request:NSFetchRequest<Expense> = Expense.fetchRequest()
            let predicate=NSPredicate(format: "exp_description contains %@", searchBar.text!)
            request.predicate=predicate
            request.sortDescriptors=[NSSortDescriptor(key: "exp_description", ascending: true)]
            loadItem(request: request)
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Expense> = Expense.fetchRequest()
        let predicate=NSPredicate(format: "exp_description contains %@", searchBar.text!)
        request.predicate=predicate
        request.sortDescriptors=[NSSortDescriptor(key: "exp_description", ascending: true)]
        loadItem(request: request)
    }
}
