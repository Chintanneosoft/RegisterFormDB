//
//  ViewController.swift
//  RegisterFormDB
//
//  Created by Neosoft on 06/10/23.
//

import UIKit
import SQLite3
//MARK: - UsersVC
class UsersVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var userListTableView: UITableView!
    
    var userData: [UserData] = []
    let dataBaseManager = DataBaseManager()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
    }
    
    private func setTableView(){
        userListTableView.delegate = self
        userListTableView.dataSource = self
        
        userListTableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    func getUserData(){
        guard let getResult = dataBaseManager.getUserData() else{
            return
        }
        userData = getResult
        userListTableView.reloadData()
    }
    
    //MARK: - IBActions
    @IBAction func btnRegisterTapped(_ sender: UIButton){
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - TableViewDelegate
extension UsersVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell
        guard let userImg = UIImage(data: userData[indexPath.row].profilePic ?? Data()) else{
            return UITableViewCell()
        }
        let userName = (userData[indexPath.row].firstName ?? "") + " " + (userData[indexPath.row].lastName ?? "")
        cell?.setUpCell(
            userImg: userImg,
            userName: userName,
            education: userData[indexPath.row].education ?? "")
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        if editingStyle == .delete {
            let user = userData[indexPath.row]
            let deleteResult = dataBaseManager.deleteUserData(user: user)
            if deleteResult == nil{
                userData.remove(at: indexPath.row)
                tableView.reloadData()
            } else {
                showAlert(msg: deleteResult ?? "")
            }
        }
    }
}
