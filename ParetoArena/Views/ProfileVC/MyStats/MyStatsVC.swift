//
// ProfileVC.swift
// Pareto
//

// MARK: - Interface of user's info

import InitialsImageView
import SDWebImageSVGCoder
import UIKit
import MessageUI
import Foundation

class MyStatsVC: BaseVC {
    
    // MARK: - IBOutlets
//    @IBOutlet var myFunds: UILabel!
    @IBOutlet var showProfileToggle: UISwitch!
    @IBOutlet var popupView: UIView!
    private  let loader: Loader = .fromNib()
    
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
        }
    }
    
    // MARK: - Variables
//    var cellTypes: [CellType] = [.profileHeadCell, .bank, .favStockCell]

    private let viewModel = ProfileViewModel()
    var tableViewData: [String: String] = [:]
    var detailsArray: [String] = []

    
    private var bankConnected = false {
        didSet {
            DispatchQueue.main.async {
                if self.bankConnected {
                    USER.shared.accountAdded = true
//                    self.cellTypes.remove(at: 1)
//                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        
        
//        getAcctDetails()
        viewModel.recipientBank()
        viewModel.bindViewModelToController = {
            self.bankConnected = true
        }
        
//        tableView.register(UITableViewCell.self,
//                           forCellReuseIdentifier: "AcctDetailsCell")
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getAcctDetails()

    }

    // MARK: - Actions
    @IBAction func toggleSwitch(_ sender: UISwitch) {
    }
    

    
    @IBAction func addFunds(_ sender: Any) {
        if USER.shared.accountAdded {
            TransactionRouter().route(to: AddFundVC.identifier, from: self, parameters: nil, animated: true)
        } else {
            TransactionRouter().route(to: PlaidIntroVC.identifier, from: self, parameters: nil, animated: true)
        }
    }
    
    
    // MARK: - Helpers
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bankConnectedFunc),
            name: Notification.bankConnected,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bankDisConnectedFunc),
            name: Notification.bankDisConnected,
            object: nil)
    }
    
    @objc func bankConnectedFunc() {
        self.bankConnected = true
    }
    
    @objc func bankDisConnectedFunc() {
        USER.shared.accountAdded = false
        self.bankConnected = false
//        cellTypes.insert(.bank, at: 1)
//        tableView.reloadData()
    }
    
    func getAcctDetails() {
        let url = EndPoint.kServerBase + EndPoint.TradingView
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: nil, requestType: .get, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            print(resp!)
            self.detailsArray = []
            if let jsonObject = resp as? [String: Any] {
                
                let cashTransferable = Double(jsonObject["cash_transferable"] as! Substring) ?? 0.0
                
                let cashWithdrawable = Double(jsonObject["cash_withdrawable"] as? String ?? "0.0") ?? 0.0
                
                let buyingPower = Double(jsonObject["buying_power"] as? String ?? "0.0") ?? 0.0
                
                let pendingTransferIn = Double(jsonObject["pending_transfer_in"] as? String ?? "0.0") ?? 0.0
                
                let lastDaytradeCount = Double(jsonObject["last_daytrade_count"] as? String ?? "0.0") ?? 0.0
                
                let effectiveBuyingPower = Double(jsonObject["effective_buying_power"] as? String ?? "0.0") ?? 0.0
                
                self.tableViewData["Cash Transferable"] = String(format: "%.2f", cashTransferable)
                self.tableViewData["Cash Withdrawable"] = String(format: "%.2f", cashWithdrawable)
                self.tableViewData["Buying Power"] = String(format: "%.2f", buyingPower)
                self.tableViewData["Pending Transfer In Amount"] = String(format: "%.2f", pendingTransferIn)
                self.tableViewData["Daytrades Used"] = String(format: "%.2f", lastDaytradeCount)
                self.tableViewData["Effective Buying Power"] = String(format: "%.2f", effectiveBuyingPower)
                
                self.detailsArray = Array(self.tableViewData.keys)
                self.tableView.reloadData()
                
            } else {
                self.view.makeToast("Server Error")
            }
        }) { error in
            print(error)
            self.view.makeToast(error)
        }
    }
    
    
    
    
}

extension MyStatsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcctDetailsCell", for: indexPath)
        let cellValue = tableViewData[self.detailsArray[indexPath.row]]
        let cellContents = "\(String(describing: cellValue))"

        cell.textLabel?.text = cellContents
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return detailsArray[section]
    }
}




enum CellType {
    case welcome
    case bank
    case giveAway
    case invite
    case reward
    case scratch
    case stockHeader
    case stock
    case stockSubHeader
    case favStockCell
    case stockHeadCell
    case stockCell
}


