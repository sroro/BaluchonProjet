//
//  UIViewController+Alert.swift
//  Baluchon
//
//  Created by Rodolphe Schnetzer on 01/06/2020.
//  Copyright © 2020 Rodolphe Schnetzer. All rights reserved.
//

import UIKit

// on a rajouter une func à la class UIViewController pour ecrire qu'une fois la func 
extension UIViewController {
    /// gère l'alerte si problème de reseau
        func alert() {
           let alertVC = UIAlertController(title: "Error", message: "Erreur réseau", preferredStyle: .actionSheet)
           alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
           present(alertVC , animated: true, completion: nil)
       }
}
