//
//  AddExpenseController.swift
//  Expense Manager
//
//  Created by Taksh on 12/08/20.
//  Copyright © 2020 Taksh Doria. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift

class AddExpenseController: UIViewController {

    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    var evc:ExpenseViewController?
    @IBOutlet weak var expense_description: UITextField!
    @IBOutlet weak var expense_amount: UITextField!
    @IBOutlet weak var pickerview: UIPickerView!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var expense_note: UITextField!
    var type:String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        pickerview.dataSource=self
        pickerview.delegate=self
        // Do any additional setup after loading the view.
    }
    @IBAction func save(_ sender:UIButton)
    {
        print(datepicker.date)
        if let description=expense_description.text, let amount=expense_amount.text ,let exp_type=type
        {
            print(amount)
            print(description)
            print(exp_type)
            print(datepicker.date)
            let expense_obj=Expense(context: context)
            expense_obj.date=datepicker.date
            expense_obj.amount=Double(Int(amount)!)
            expense_obj.expense_type=exp_type
            expense_obj.note=expense_note.text!
            expense_obj.exp_description=expense_description.text!
            print("before saving")
            do
            {
                print("inside do block")
                try self.context.save()
                print("saved succesfully")
                self.view.makeToast("Saved Succesfully!")
            }
            catch
            {
                let controller=UIAlertController(title: "Error!", message: "unable to save the data", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
            }
            self.evc!.loadItem()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension AddExpenseController:UIPickerViewDataSource,UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constant.Expense.expense_type.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constant.Expense.expense_type[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type=Constant.Expense.expense_type[row]
    }
}
