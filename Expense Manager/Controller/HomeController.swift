//
//  HomeController.swift
//  Expense Manager
//
//  Created by Taksh on 29/08/20.
//  Copyright © 2020 Taksh Doria. All rights reserved.
//

import UIKit
import Charts
import CoreData

class HomeController: UIViewController {

    let colors=[UIColor(named: "color1")!,UIColor(named: "color2")!,UIColor(named: "color3")!,UIColor(named: "color4")!]
    let conetext=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    var data:[Expense]?
    @IBOutlet weak var piechartview: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        piechartview.noDataText="no data available"
        piechartview.centerText="Statistics"
        loadItems()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadItems()
    }
    
    func loadItems()
      {
        let request:NSFetchRequest<Expense>=Expense.fetchRequest()
        do
        {
            data=try conetext.fetch(request)
            loadChart()
        }
        catch{
            print("error")
        }
      }
    func loadChart()
    {
        if let expensedata=data
        {
            var piedata:PieChartDataSet=PieChartDataSet()
            piedata.colors=colors
            for d in expensedata
            {
                piedata.addEntryOrdered(PieChartDataEntry(value: d.amount, label: d.expense_type))
            }
            let piedata1=PieChartData(dataSet: piedata)
            piechartview.data=piedata1
        }
    }
}
