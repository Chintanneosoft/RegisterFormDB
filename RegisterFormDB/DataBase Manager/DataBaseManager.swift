//
//  DataBaseManager.swift
//  RegisterFormDB
//
//  Created by Neosoft on 09/10/23.
//

import UIKit

class DataBaseManager: NSObject {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveUserData(userData: UsersInfo) -> String? {
        var userDataInfo = UserData(context: context)
        userDataInfo.firstName = userData.firstName
        userDataInfo.lastName = userData.lastName
        userDataInfo.email = userData.email
        userDataInfo.phoneNumber = userData.phoneNumber
        userDataInfo.password = userData.password
        userDataInfo.confirmPassword = userData.confirmPassword
        userDataInfo.education = userData.education
        userDataInfo.dob = userData.dob
        userDataInfo.profilePic =  userData.profilePic
        userDataInfo.gender = userData.gender
        do{
            try context.save()
            return nil
        } catch {
            return error.localizedDescription
        }
    }
    
    func getUserData() -> [UserData]?{
        do{
            let userData = try context.fetch(UserData.fetchRequest())
            return userData
        } catch {
            return nil
        }
    }
    
    func deleteUserData(user: UserData) -> String?{
        do{
            context.delete(user)
            try context.save()
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}
