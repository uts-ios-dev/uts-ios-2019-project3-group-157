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
    
    var valueInGetUrlField:String="";
    
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
    
    private let networkingClient=NetworkingClient()
    
    let requestTypes = ["GET", "POST", "PUT", "DELETE"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsonField.layer.cornerRadius = 5
        jsonField.layer.masksToBounds = true
        
        sendRequestButton.layer.cornerRadius = 5
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        //sendRequestButton.isEnabled=false
        requestType.inputView = pickerView
       //
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == requestUrl
        {
            let oldStr = requestUrl.text! as NSString
            let newStr = oldStr.replacingCharacters(in: range, with: string) as NSString
            if newStr.length == 0
            {
                
                sendRequestButton.isUserInteractionEnabled = false
                sendRequestButton.isEnabled=false
            }else
            {
                sendRequestButton.isUserInteractionEnabled=true
                sendRequestButton.isEnabled=true
                
            }
        }
        let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@!:/. ").inverted
        //Set maximum length of name to 14 and return if valid set
        
        return range.location < 100 && string.rangeOfCharacter(from: set) == nil
    }
    
    @IBAction func executeRequest(_ sender: Any)
    
    {
        valueInGetUrlField=requestUrl.text ?? "0"
        print(valueInGetUrlField);
        guard let urlToExecute=URL(string:valueInGetUrlField) else{
            return
        }
        networkingClient.execute(urlToExecute){(json,error) in
        if let error=error{
            self.jsonField.text=error.localizedDescription
            
            }
        
        
        else if let json=json {
            self.jsonField.text=json.description
        }
        }
    }

}

