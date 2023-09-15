//
//  FundsAddedVC.swift
//  Pareto
//
//

import UIKit

import SwiftUI

struct TransactionStatusView: View {
    @State private var progress: CGFloat = 0.0
    
    let transactionAmount: String
    let time: String
    let status: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Transaction Amount: \(transactionAmount)")
                .font(.headline)
            
            Text("Time: \(time)")
                .font(.subheadline)
            
            HStack {
                Text("Status: \(status)")
                    .font(.subheadline)
                
                Spacer()
                
                if status == "COMPLETE" {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if status == "CANCELED" {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            
            ProgressView(value: progress)
                .progressViewStyle(CustomProgressViewStyle(color: status == "COMPLETE" ? .green : .red))
                .onAppear {
                    if status == "COMPLETE" {
                        progress = 1.0
                    } else if status == "CANCELED" {
                        progress = 0.5
                    }
                }
            
            HStack {
                Text("Initiated")
                    .font(.caption)
                
                Spacer()
                
                Text("Completed")
                    .font(.caption)
                    .opacity(status == "COMPLETE" ? 1.0 : 0.5)
                
                Spacer()
                
                Text("Cancelled")
                    .font(.caption)
                    .opacity(status == "CANCELED" ? 1.0 : 0.5)
            }
        }
        .padding()
    }
}

struct CustomProgressViewStyle: ProgressViewStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .accentColor(color)
    }
}





class FundsAddedVC: BaseVC {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblDepositCom: UILabel!
    @IBOutlet var lblavailtoTrade: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var imgRound: UIImageView!
    @IBOutlet var imgBar: UIImageView!
    @IBOutlet var lblCancel: UILabel!
    @IBOutlet var lblIntiate: UILabel!
    @IBOutlet var middleBar: UIImageView!
    @IBOutlet var startBar: UIImageView!
    @IBOutlet var startRound: UIImageView!
    var amount  = ""
    var time = ""
    var status  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAmount.text = "$\(amount) Added"
        lblTime.text = time
        let upperStatus = status.uppercased()

        if upperStatus == "COMPLETE" {
            startBar.tintColor = UIColor(named: "Pareto Blue")
            startRound.tintColor = UIColor(named: "Pareto Blue")
            middleBar.tintColor = UIColor(named: "Pareto Blue")
            imgBar.tintColor = UIColor(named: "Pareto Blue")
            imgRound.tintColor = UIColor(named: "Pareto Blue")
            lblIntiate.textColor = .label
            lblCancel.textColor = .label
            lblDepositCom.textColor = .label
        } else if upperStatus == "CANCELED" {
            startBar.tintColor = UIColor(named: "Pareto Blue")
            startRound.tintColor = UIColor(named: "Pareto Blue")
            middleBar.tintColor = .red
            imgBar.tintColor = .red
            imgRound.tintColor = .red
            lblIntiate.textColor = .label
            lblCancel.textColor = .systemBackground
            lblDepositCom.textColor = .label
        }
    }

    @IBAction func addFundsPressed(_ sender: UIButton) {
        let upperStatus = status.uppercased()
        if upperStatus == "COMPLETE" {
            FundsAddedRouter().route(to: "back", from: self, parameters: nil, animated: true)
        } else if upperStatus == "CANCELED" {
            self.lblAmount.text = "$\(amount) Canceled"
            self.lblTitle.text = "Funds Canceled"
            self.lblDepositCom.text = "Deposit Canceled"
            self.lblavailtoTrade.text = ""
            self.imgRound.image = #imageLiteral(resourceName: "circleBlue")
            self.imgBar.image = #imageLiteral(resourceName: "BarBlue")
        } else {
            FundsAddedRouter().routeToParent(to: "back", from: self, parameters: nil, animated: true)
        }
    }
}
