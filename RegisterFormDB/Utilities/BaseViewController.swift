//
//  BaseViewController.swift
//  RegisterFormDB
//
//  Created by Neosoft on 07/10/23.
//

import UIKit

class BaseViewController: UIViewController {
    var tapGesture: (Any)? = nil
    var mainScrollView: UIScrollView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setTapGesturesRemoveable()
        addObservers()
    }
    
    func setTapGesturesRemoveable(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - @objc Functions
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.mainScrollView?.contentInset ?? UIEdgeInsets.zero
        contentInset.bottom = keyboardFrame.size.height + 20
        mainScrollView?.contentInset = contentInset
        view.addGestureRecognizer(tapGesture as! UIGestureRecognizer)
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        mainScrollView?.contentInset = contentInset
        view.removeGestureRecognizer(tapGesture as! UIGestureRecognizer)
    }
}
