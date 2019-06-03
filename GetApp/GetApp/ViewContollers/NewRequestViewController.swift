//
//  ViewController.swift
//  GetApp
//
//  Created by Evgeniya Yureva on 25/5/19.
//  Copyright © 2019 uts. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class NewRequestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var requestType: UITextField!
    @IBOutlet weak var requestUrl: UITextField!
    
    @IBOutlet weak var request_key_1: UITextField!
    @IBOutlet weak var request_value_1: UITextField!
    @IBOutlet weak var request_key_2: UITextField!
    @IBOutlet weak var request_value_2: UITextField!
    @IBOutlet weak var request_key_3: UITextField!
    @IBOutlet weak var request_value_3: UITextField!
    
    @IBOutlet weak var parametersEncodingType: UITextField!
    
    @IBOutlet weak var header_key_1: UITextField!
    @IBOutlet weak var header_value_1: UITextField!
    @IBOutlet weak var header_key_2: UITextField!
    @IBOutlet weak var header_value_2: UITextField!
    
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var responseTextView: UITextView!
    
    @IBOutlet weak var cloudProxySwitch: UISwitch!
    
    let requestTypes = ["GET", "POST", "PUT", "DELETE"]
    let contentRequestTypes = ["POST", "PUT"]
    let parametersEncodingDisplayed = ["json", "urlencoded"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parametersEncodingType.isHidden = true
        
        sendRequestButton.layer.cornerRadius = 5
        responseTextView.layer.cornerRadius = 5
        
        let requestTypePickerView = UIPickerView()
        requestTypePickerView.tag = 1
        requestTypePickerView.delegate = self
        
        requestType.inputView = requestTypePickerView
        
        let parametersPicker = UIPickerView()
        parametersPicker.tag = 2
        parametersPicker.delegate = self
        
        parametersEncodingType.inputView = parametersPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return requestTypes.count
        } else {
            return parametersEncodingDisplayed.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return requestTypes[row]
        } else {
            return parametersEncodingDisplayed[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            requestType.text = requestTypes[row]
        
            if (requestType.text == "POST") {
                parametersEncodingType.isHidden = false
            }
            else {
                parametersEncodingType.isHidden = true
            }
        } else {
            parametersEncodingType.text = parametersEncodingDisplayed[row]
        }
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        
        guard let url = requestUrl.text, !url.isEmpty else {
            self.showMessage(title: "Error", message: "URL field should not be empty.")
            return;
        }
        
        let request = Request(uri: url, method: requestType.text!)
        
        if (request_key_1.text! != "") { request.setParameter(name: request_key_1.text!, value: request_value_1.text!) }
        if (request_key_2.text! != "") { request.setParameter(name: request_key_2.text!, value: request_value_2.text!) }
        if (request_key_3.text! != "") { request.setParameter(name: request_key_3.text!, value: request_value_3.text!) }
        
        if (header_key_1.text! != "") { request.setHeader(name: header_key_1.text!, value: header_value_1.text!) }
        if (header_key_2.text! != "") { request.setHeader(name: header_key_2.text!, value: header_value_2.text!) }
        
        let ctx = getContext()
        
        let encodingType = parametersEncodingType.text!
        let requestEncodable = contentRequestTypes.contains(requestType.text!)
        
        if requestEncodable && encodingType == "json" {
            if let localCtx = ctx as? LocalExecutionContext {
                localCtx.encoding = JSONEncoding.default
            }
            request.encoding="json"
        }
        
        ctx.run(request: request, callback: self.requestCallback)
    }
    
    func getContext() -> ExecutionContext {
        if cloudProxySwitch.isOn {
            return RemoteExecutionContext()
        }
        return LocalExecutionContext()
    }
    
    func requestCallback(result: ExecutionResult) {
        
        guard let response = result.response else {
            showMessage(title: "Error", message: "Error has occured while parsing the responce. Check your request parameters.")
            return
        }
        
        var message = "responseCode: " + String(response.getResponseCode()) + "\n"
        
        if result.success {
            message += "body: " + response.getBody()
            
        }
        else {
            message += "error message: " + result.message
        }
        
        addDataToHistory(response: response)
        
        responseTextView.text = message;
        //self.showMessage(title: "Your request responce:", message: message)
    }
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addDataToHistory(response: Response!) {
        let storedDefaults = UserDefaults.standard
        
        let uid = NSUUID().uuidString
        let uri = response.getUri()
        let code = String(response.getResponseCode())
        let body = response.getBody()
        let dictionaryValue = [uri, code, body]
        
        let existingRequests = storedDefaults.dictionary(forKey: "requests")
        var requestsDictionary = existingRequests as? Dictionary<String, Array<String>> ?? Dictionary<String, Array<String>>()
        requestsDictionary[uid] = dictionaryValue
        
        storedDefaults.set(requestsDictionary, forKey: "requests")
    }
}

