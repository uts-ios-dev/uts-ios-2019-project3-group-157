//
//  HistoryCell.swift
//  GetApp
//
//  Created by Shadman Mahmood on 3/6/19.
//  Copyright © 2019 uts. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

 
    @IBOutlet weak var historyLabel: UILabel!
    
    func setHistory(history:History){
        historyLabel.text=history.request
    }
    
}
