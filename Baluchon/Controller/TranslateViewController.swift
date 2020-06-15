//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 19/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

final class TranslateViewController: UIViewController {
   private let translate = TranslateService()
   private var target = "en"
   private var languages = [("en","Anglais"),("de","Allemande"),("es","Espagnol"),("it", "Italien"),("ar","Arabe")] // utilisation un tableau de tuples
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBOutlet private weak var languagePicker: UIPickerView!
    @IBOutlet private weak var textToTranslate: UITextView!
    
    @IBOutlet private weak var textTranslate: UITextView!
    @IBAction private func dismissKeyboardGesture(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }
    
    @IBAction private func validateButton(_ sender: UIButton) {
        guard let text = textToTranslate.text else { return }
        translate.getTranslate(text: text, target: target  ) { result in
            switch result {
            case .failure(_):
                self.alert()
            case .success(let translateData):
                self.textTranslate.text = translateData.data.translations[0].translatedText
                
            }
        }
        textToTranslate.resignFirstResponder()
    }
    //MARK: -- Méthodes PickerView
    
    //MARK: - Méthodes

    // monter la vue de l'ecran de la taille du clavier
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // baisser la vue de l'ecran
    @objc
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

 //MARK: - Méthodes PickerView

extension TranslateViewController :  UIPickerViewDelegate , UIPickerViewDataSource {
   
      //Gère le nbr de colonne dans le picker
      func numberOfComponents(in pickerView: UIPickerView) -> Int {
          return 1
      }
      //Gère le nbr d'elmt a afficher
      func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return languages.count
      }
      // gère quoi afficher dans le picker
      func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return languages[row].1 // .1 accède a la 2e valeur dans le tuple
          
      }
      // accède a la scd valeur du tuple et le met dans la var target qui est utiliser dans la closure getTranslate
      func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          let languageSelected = languages[row]
          target = languageSelected.0 //.0 accède a la 2e valeur dans le tuple
      }
    
}
