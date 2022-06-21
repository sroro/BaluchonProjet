//
//  TranslateViewController.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 19/04/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

final class TranslateViewController: UIViewController {
    
    // MARK: - properties
    
    private let translate = TranslateService()
    private var target = "en"
    private var languages = [("en","Anglais"),("de","Allemand"),("es","Espagnol"),("it", "Italien"),("ar","Arabe")] // utilisation un tableau de tuples
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBOutlet & IBActions
    
    @IBOutlet private weak var languagePicker: UIPickerView!
    @IBOutlet private weak var textToTranslate: UITextView!
    @IBOutlet private weak var textTranslate: UITextView!
    @IBAction private func dismissKeyboardGesture(_ sender: UITapGestureRecognizer) {
        textToTranslate.resignFirstResponder()
    }
    
    @IBAction private func validateButton(_ sender: UIButton) {
        guard let text = textToTranslate.text , !text.isEmpty  else {
            alertTranslate()
            return
        }
        translate.getTranslate(text: text, target: target  ) { [weak self] result in
            switch result {
            case .failure(_):
                print("error")
            case .success(let translateData):
                DispatchQueue.main.async {
                    self?.textTranslate.text = translateData.data.translations[0].translatedText
                }
            }
        }
        textToTranslate.resignFirstResponder()
    }
    
    //MARK: - Méthodes
    
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
}

//MARK: - Méthodes PickerView


extension TranslateViewController :  UIPickerViewDelegate , UIPickerViewDataSource {
    
    //Manage the number of columns in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Gmanage the number of elements in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    // gmanage hat show in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].1 // .1 accède a la 2e valeur dans le tuple
        
    }
    // access the scd value of the tuple and put it in the var target which is used in the getTranslate closure
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let languageSelected = languages[row]
        target = languageSelected.0 //.0 accède a la 2e valeur dans le tuple
    }
    
}
