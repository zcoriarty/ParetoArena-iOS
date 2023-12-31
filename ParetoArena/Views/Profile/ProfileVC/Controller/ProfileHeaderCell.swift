//
//  ProfileHeaderCell.swift
//  Pareto
//
//

import UIKit

class ProfileHeaderCell: UIView {
    // MARK: - Outlets
    @IBOutlet var lblName: UILabel!
    @IBOutlet var username: UILabel!
//    @IBOutlet var lblBio: UILabel!
    @IBOutlet var profileImage: UIImageView!
    // MARK: - Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        if lblName != nil { // Profile Header case
            lblName.text = USER.shared.details?.user?.fullName
        }
        if username != nil { // Profile Header case
            username.text = USER.shared.details?.user?.username
        }
//        lblBio.text = USER.shared.details?.user?.bio

        self.profileImage.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
        self.profileImage.layer.masksToBounds = false
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
        self.profileImage.clipsToBounds = true
        let avatar = USER.shared.details?.user?.avatar ?? ""

        self.profileImage.getImage(url: EndPoint.kServerBase + "file/users/"+avatar, placeholderImage: nil) { _ in
            self.profileImage.contentMode = .scaleAspectFill
        } failer: { _ in
            self.profileImage.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
        }
    }
//    @IBAction func socialMedia(_ sender: UIButton) {
//        var url = ""
//        switch sender.tag {
//        case 0 :
//            url = USER.shared.details?.user?.facebookUrl ?? ""
//
//        case 1:
//            url = USER.shared.details?.user?.twitterUrl ?? ""
//        default:
//            url = USER.shared.details?.user?.instagramUrl ?? ""
//        }
//
//        if url != "", let urlStr = URL(string: url) {
//            UIApplication.shared.open(urlStr)
//        }
//    }
    
}
