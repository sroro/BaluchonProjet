//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 19/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {
    let translate = TranslateService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBOutlet weak var textToTranslate: UITextView!
    @IBAction func validateButton(_ sender: UIButton) {
        guard let text = textToTranslate.text else { return }
        
        translate.getTranslate(text: text ) { result in
            switch result {
            case .failure(_):
                self.alert()
            case .success(let translateData):
                self.textTranslate.text = translateData.data.translations[0].translatedText
            }
        }
        
        textToTranslate.resignFirstResponder()
    }
    
    @IBOutlet weak var textTranslate: UITextView!
    @IBAction func dismissKeyboardGesture(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }
    
    
    
    //MARK: -- Méthodes
    // monter la vue de l'ecran de la taille du clavier
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // baisser la vue de l'ecran
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    func alert() {
        let alertVC = UIAlertController(title: "Error", message: "Erreur réseau", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertVC , animated: true, completion: nil)
        
    }
}
