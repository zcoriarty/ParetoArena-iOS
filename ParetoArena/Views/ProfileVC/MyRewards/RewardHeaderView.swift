//
// RewardHeaderView.swift
// Pareto
//
//
import UIKit
class RewardHeaderView: UICollectionReusableView {
    // MARK: - Outlets
    @IBOutlet var backview: UIView!
    // MARK: - Cycles
    override func draw(_ rect: CGRect) {
        backview.layer.cornerRadius = 15
        backview.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
