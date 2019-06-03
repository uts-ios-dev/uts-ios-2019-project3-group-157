//
//  HistoryViewController.swift
//  GetApp
//
//  Created by Shadman Mahmood on 3/6/19.
//  Copyright © 2019 uts. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var histories:[History]=[]
    var length:Int=0
    var requestArray:[String]=[]
    var i:Int=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaults.standard.removeObject(forKey: "requests")
        if let saved = UserDefaults.standard.value(forKey: "requests") as?[String: String]?{
            
            for (_,value) in saved ?? [:] {
                print(value)
                requestArray.append(value)
                //var value=saved!.values
                //print(value)
                
            }
            histories=createArray()
            tableView.delegate=self
            tableView.dataSource=self
            
        }
        
        
        
        
        
        
        
        
        
        
        /*
         func createArray()->[History]{
         
         }
         */
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let saved = UserDefaults.standard.value(forKey: "requests") as?[String: String]?{
            
            for (_,value) in saved ?? [:] {
                print(value)
                requestArray.append(value)
                //var value=saved!.values
                //print(value)
                
            }
            histories=createArray()
            tableView.delegate=self
            tableView.dataSource=self
            
        }
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let saved = UserDefaults.standard.value(forKey: "requests") as?[String: String]?{
            
            for (_,value) in saved ?? [:] {
                print(value)
                requestArray.append(value)
                //var value=saved!.values
                //print(value)
                
            }
            histories=createArray()
            tableView.delegate=self
            tableView.dataSource=self
            
        }
        
        
        
        
    }
    
    func createArray()->[History]{
        
        
        
        var tempHistory:[History]=[]
        length=requestArray.count
        print(length)
        while(i<length){
            let requestString=requestArray[i]
            
            //var history="history"+String(i)
            let history=History(request:requestString)
            
            print(requestString)
            tempHistory.append(history)
            i=i+1
        }
        
        return tempHistory
    }
    
    
    
    
    // Do any additional setup after loading the view.
}




extension HistoryViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(histories.count)
        return histories.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let history=histories[indexPath.row]
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        
        cell.setHistory(history:history)
        
        return cell
    }
    
    
}
