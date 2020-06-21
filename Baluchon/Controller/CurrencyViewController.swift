//
//  CurrencyViewController.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 17/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

final class CurrencyViewController: UIViewController {
    
    private let currencyService = CurrencyService()
    private var target = "USD"
    private var devise = ["USD" , "AED" , "GBP" , "CAD", "CHF"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var amountChangeLabel: UILabel!
    @IBAction private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    @IBAction private func validateButton(_ sender: UIButton) {
        currencyService.getExchange(devise: target) { result in
            switch result {
            case .failure(_):
                self.alert()
            case .success(let exchangeRate):
                
                guard let amontUnwrapped = self.amountTextField.text else { return }
                
                // converted and unpacks duplicate user input
                guard let amountDouble = Double(amontUnwrapped) else { return }
                
                // multiplies exchange rate with user input and reduces it to 2 digits after comma
                let amountReduce = self.formatResult(result: amountDouble * exchangeRate)
         
                self.amountChangeLabel.text = amountReduce
            }  
        }
        amountTextField.resignFirstResponder()
    }
    
    // MARK: - méthodes
    
    // show or hide keyboard
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // reduce number 2 after comma
    func formatResult(result: Double) -> String! {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        guard let resultFormated = formatter.string(from: NSNumber(value: result)) else { return nil
        }
        return resultFormated
    }
}

extension CurrencyViewController : UIPickerViewDataSource , UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return devise.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return devise[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let test = devise[row]
        target = test
    }
}
