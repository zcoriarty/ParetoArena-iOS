//
// GiveAwayHeaderCell.swift
// Pareto
//
//
import UIKit
class GiveAwayHeaderCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet var lblName: UILabel!
    @IBOutlet var backview: UIView!
    // MARK: - Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        if lblName != nil { // Profile Header case
            lblName.text = USER.shared.details?.user?.fullName
        }
        backview.layer.cornerRadius = 15
        backview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
