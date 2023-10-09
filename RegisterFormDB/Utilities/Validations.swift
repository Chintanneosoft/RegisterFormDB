//
//  Validations.swift
//  RegisterFormDB
//
//  Created by Neosoft on 07/10/23.
//

import UIKit

class Validations: NSObject {
    
    func registerValidation(firstName: String?, lastName: String?, email: String?, password: String?, confirmPassword: String?, mobileNumber: String?, education: String?, dob: String?) -> String?{
        
        guard firstName != "" && lastName != "" && password != "" && confirmPassword != "" && email != "" && mobileNumber != "" && education != "" && dob != "" else {
            return "Please fill the required fields"
        }
        
        guard firstName!.count > 3 && containsOnlyCharacters(firstName!) == true else {
            return "Enter a valid first name"
        }
        
        guard lastName!.count > 3 && containsOnlyCharacters(lastName!) == true else {
            return "Enter a valid last name"
        }
        
        guard validateEmail(email ?? "") == true else {
            return "Enter a valid email id"
        }
        
        guard password!.count >= 8 && containsOnlyAllowedCharacters(password!) == true && containsOneNumberAndOneSpecialChar(password!) == true else {
            return "Enter a valid password"
        }
        
        guard password! == confirmPassword! else {
            return "Password does not match Confirm Password"
        }
        
        guard mobileNumber!.count == 10 && containsOnlyNumbers(mobileNumber!) == true else {
            return "Enter a valid mobile number"
        }
        
        return nil
    }
    
    func containsOnlyCharacters(_ input: String) -> Bool {
        let characterSet = CharacterSet.letters
        return input.rangeOfCharacter(from: characterSet.inverted) == nil
    }
    
    func containsOnlyAllowedCharacters(_ input: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()_+")
        let inputCharacterSet = CharacterSet(charactersIn: input)
        return allowedCharacterSet.isSuperset(of: inputCharacterSet)
    }
    
    func containsOneNumberAndOneSpecialChar(_ input: String) -> Bool {
        let numberRegex = ".*\\d.*"
        let specialCharRegex = ".*[^A-Za-z0-9].*"
        
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        let specialCharPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharRegex)
        
        let containsNumber = numberPredicate.evaluate(with: input)
        let containsSpecialChar = specialCharPredicate.evaluate(with: input)
        
        return containsNumber && containsSpecialChar
    }
    
    func containsOnlyNumbers(_ input: String) -> Bool {
        let numericCharacterSet = CharacterSet.decimalDigits
        let inputCharacterSet = CharacterSet(charactersIn: input)
        return numericCharacterSet.isSuperset(of: inputCharacterSet)
    }
    
    func validateEmail(_ input: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: input)
    }
    
}
