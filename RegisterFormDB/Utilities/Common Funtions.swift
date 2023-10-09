//
//  Common Funtions.swift
//  RegisterFormDB
//
//  Created by Neosoft on 07/10/23.
//

import UIKit

extension UIViewController{
    func showAlert(msg:String){
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
