//
//  UserCell.swift
//  RegisterFormDB
//
//  Created by Neosoft on 06/10/23.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEduction: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpUI(){
        userImg.layer.cornerRadius = userImg.bounds.width/2
        userImg.layer.borderWidth = 2
        userImg.layer.borderColor = UIColor.blue.cgColor
    }
    
    func setUpCell(userImg:UIImage,userName:String,education:String){
        self.userImg.image = userImg
        lblName.text = userName
        lblEduction.text = education
    }
}
