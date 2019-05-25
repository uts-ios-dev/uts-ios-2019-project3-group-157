//
//  ViewController.swift
//  GetApp
//
//  Created by Evgeniya Yureva on 25/5/19.
//  Copyright © 2019 uts. All rights reserved.
//

import UIKit
import Foundation

class NewRequestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var requestType: UITextField!
    @IBOutlet weak var requestUrl: UITextField!
    
    @IBOutlet weak var request_key_1: UITextField!
    @IBOutlet weak var request_value_1: UITextField!
    @IBOutlet weak var request_key_2: UITextField!
    @IBOutlet weak var request_value_2: UITextField!
    @IBOutlet weak var request_key_3: UITextField!
    @IBOutlet weak var request_value_3: UITextField!
    
    
    @IBOutlet weak var header_key_1: UITextField!
    @IBOutlet weak var header_value_1: UITextField!
    @IBOutlet weak var header_key_2: UITextField!
    @IBOutlet weak var header_value_2: UITextField!
    
    @IBOutlet weak var jsonField: UITextView!
    @IBOutlet weak var sendRequestButton: UIButton!
    
    let requestTypes = ["GET", "POST", "PUT", "DELETE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsonField.layer.cornerRadius = 5
        jsonField.layer.masksToBounds = true
        
        sendRequestButton.layer.cornerRadius = 5
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        requestType.inputView = pickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return requestTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return requestTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestType.text = requestTypes[row]
    }


}

