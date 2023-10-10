//
//  ViewController.swift
//  Registration Form Assignment
//
//  Created by Neosoft1 on 28/07/23.
//

import UIKit

//MARK: - ViewController
class RegistrationVC: BaseViewController{
    
    //MARK: - IBOutlets
    @IBOutlet var containerViews: [UIView]!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfPhoneNo: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var tfEducation: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var maleRadio: UIButton!
    @IBOutlet weak var femaleRadio: UIButton!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var viewEducation: UIView!
    @IBOutlet weak var registerScrollView: UIScrollView!
    
    let datePicker = UIDatePicker()
    let educationPickerView = UIPickerView()
    let dataBaseManager = DataBaseManager()
    var userInfo = UsersInfo()
    var imgSelected: Bool = false
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitDelegates()
        setDateSelector()
        setEducationSelector()
        setUI()
    }
    
    //MARK: - Setup Functions
    func setUI(){
        for v in containerViews{
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.black.cgColor
        }
        profileImg.layer.cornerRadius = profileImg.bounds.width/2
        mainScrollView = registerScrollView
    }
    
    func setInitDelegates(){
        tfFirstName.becomeFirstResponder()
        tfFirstName.delegate = self
        tfLastName.delegate = self
        tfPhoneNo.delegate = self
        tfEmail.delegate = self
        tfPassword.delegate = self
        tfConfirmPassword.delegate = self
        tfEducation.delegate = self
        tfDOB.delegate = self
        
        tfEducation.inputView = educationPickerView
        tfDOB.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        educationPickerView.dataSource = self
        educationPickerView.delegate = self
    }
    
    func setDateSelector(){
        let dateSelector = UITapGestureRecognizer(target: self, action: #selector(dateSelection(sender:)))
        viewDOB.isUserInteractionEnabled = true
        viewDOB.addGestureRecognizer(dateSelector)
        datePicker.maximumDate = Date()
        datePicker.contentHorizontalAlignment = .left
        datePicker.preferredDatePickerStyle = .inline
    }
    
    func setEducationSelector(){
        let educationSelector = UITapGestureRecognizer(target: self, action: #selector(educationSelection(sender:)))
        viewEducation.isUserInteractionEnabled = true
        viewEducation.addGestureRecognizer(educationSelector)
        tfEducation.text = Educations.allCases[0].rawValue 
    }
    
    func alertOptions(){
        let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default,handler: { handler in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default,handler: { handler in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default,handler: { handler in
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.sourceType = .camera
            image.delegate = self
            self.present(image, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.delegate = self
            self.present(image, animated: true,completion:nil)
        }
    }
    
    func saveUserData(){
        userInfo.firstName = tfFirstName.text ?? ""
        userInfo.lastName = tfLastName.text ?? ""
        userInfo.email = tfEmail.text ?? ""
        userInfo.phoneNumber = tfPhoneNo.text ?? ""
        userInfo.password = tfPassword.text ?? ""
        userInfo.confirmPassword = tfConfirmPassword.text ?? ""
        userInfo.education = tfEducation.text ?? ""
        userInfo.dob = tfDOB.text ?? ""
        userInfo.profilePic = profileImg.image?.pngData() ?? Data()
        userInfo.gender = maleRadio.isSelected ? "M" : "F"
        if let saveResult = dataBaseManager.saveUserData(userData: userInfo){
            showAlert(msg: saveResult)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - @objc Functions
    @objc func dateChange(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.tfDOB.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc func dateSelection(sender: UITapGestureRecognizer) {
        tfDOB.isEditing ? tfDOB.resignFirstResponder():tfDOB.becomeFirstResponder()
    }
    
    @objc func educationSelection(sender: UITapGestureRecognizer) {
        tfEducation.isEditing ? tfEducation.resignFirstResponder():tfEducation.becomeFirstResponder()
    }

    //MARK: - IBActions
    @IBAction func radioTapped(_ sender: UIButton) {
        maleRadio.isSelected = (sender == maleRadio)
        femaleRadio.isSelected = (sender == femaleRadio)
    }
    
    @IBAction func btnProflieTapped(_ sender: UIButton) {
        alertOptions()
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        if(!(maleRadio.isSelected || femaleRadio.isSelected)) {
            showAlert(msg: "Select Gender")
        } else if !imgSelected{
            showAlert(msg: "Select Image")
        } else {
            let validation = Validations()
            if let validityResult = validation.registerValidation(firstName: tfFirstName.text, lastName: tfLastName.text, email: tfEmail.text, password: tfPassword.text, confirmPassword: tfConfirmPassword.text, mobileNumber: tfPhoneNo.text, education: tfEducation.text, dob: tfDOB.text){
                showAlert(msg: validityResult)
            } else {
                saveUserData()
            }
        }
    }
}

//MARK: - TextField Delegate
extension RegistrationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField{
        case tfFirstName:
            tfLastName.becomeFirstResponder()
        case tfLastName:
            tfPhoneNo.becomeFirstResponder()
        case tfPhoneNo:
            tfEmail.becomeFirstResponder()
        case tfPassword:
            tfConfirmPassword.becomeFirstResponder()
        case tfConfirmPassword:
            tfEducation.becomeFirstResponder()
        case tfEducation:
            tfDOB.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
//MARK: - PickerView Datasource Functions
extension RegistrationVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Educations.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Educations.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let education = Educations.allCases
        tfEducation.text = education[row].rawValue
    }
}

//MARK: - ImagePickerController Delegate
extension RegistrationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editingImg = info[.editedImage] as? UIImage{
            self.profileImg.image = editingImg
            self.imgSelected = true
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
