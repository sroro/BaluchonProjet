//
//  CurrencyViewController.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 17/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    
let currencyService = CurrencyService()
    
     override func viewDidLoad() {
           super.viewDidLoad()
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    
    @IBOutlet weak var amountTextField: UITextField!
 
    @IBAction func validateButton(_ sender: UIButton) {
        currencyService.getExchange(devise: "USD") { result in
            switch result {
            case .failure(_):
                self.alertVC()
            case .success(let exchangeRate):
                
                guard let amontUnwrapped = self.amountTextField.text else { return }
                
                // convertie et deballe l'entrée utilisateur en double
                guard let amountDouble = Double(amontUnwrapped) else { return }
                
                // multiplie taux de change avec entrée utilisateur et le convertie en string pour l'afficher dans le label
                self.amountChangeLabel.text = ("\(String(exchangeRate * amountDouble)) $")
                
            }
            
        }
        amountTextField.resignFirstResponder()
        
    }
    
    
    
    
    @IBOutlet weak var amountChangeLabel: UILabel!
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        amountTextField.resignFirstResponder()
    }
    
    
    
    // MARK: - méthodes
    
    func alertVC () {   
        let alertVC = UIAlertController(title: "Error", message: "Taux de change impossible", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil)) 
        present(alertVC, animated: true, completion: nil)
    }
    

    // gérer le clavier
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}
