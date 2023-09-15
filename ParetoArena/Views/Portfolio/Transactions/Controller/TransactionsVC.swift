//
//  TransactionsVC.swift
//  Pareto
//

// MARK: - Show transactions list

import SSSpinnerButton
import UIKit
class TransactionsVC: BaseVC {
    // MARK: - Outlets
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblAccountNo: UILabel!
    @IBOutlet var lblBal: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var changeBank: UIButton!
    // MARK: - Vars
    private var transactionViewModel: TransactionViewModel!
    private let transactionRouter = TransactionRouter()
    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        Addobservers()
        setNavigation()
        
        
        // navigation bar
        navigationBar.title = "Transactions"
        if let navBar = self.navigationController?.navigationBar {
            // Set the title color to red
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTransactions()
        setNavigation()
//        setupTab()
    }
    

    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    // MARK: - Actions
    @IBAction func DeleteBank(_ sender: Any) {
        let popup: DeleteBankView = .fromNib()
        popup.setView()
        popup.removed = {
            self.setView()
            self.view.makeToast("Account has been removed successfully!")
        }
        UIApplication.shared.windows.first!.addSubview(popup)
    }


    private func Addobservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bankDisConnectedFunc),
            name: Notification.bankDisConnected,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bankConnectedFunc),
            name: Notification.bankConnected,
            object: nil)
    }
    @objc func bankConnectedFunc() {
        setView()
    }

    @objc func bankDisConnectedFunc() {
        setView()
    }
    @IBAction func AddFunds(_ sender: Any) {
        if USER.shared.accountAdded {
            transactionRouter.route(to: AddFundVC.identifier, from: self, parameters: nil, animated: true)
        } else {
            transactionRouter.route(to: PlaidIntroVC.identifier, from: self, parameters: nil, animated: true)
        }
    }
    // MARK: - Helpers
    private func setView() {
        if let name = USER.shared.accountDetail?.nickname, let number = USER.shared.accountDetail?.bank_account_number, number != "" {
            let codedNum = "****\(String(number.suffix(4)))"
            self.lblAccountNo.text = codedNum
            lblName.text = name
            lblName.isHidden = false
            lblAccountNo.isHidden = false
            btnDelete.isUserInteractionEnabled = true
        } else {
            lblName.isHidden = true
            lblAccountNo.isHidden = true
            btnDelete.isUserInteractionEnabled = false
        }
    }
    private func getTransactions() {
        transactionViewModel = TransactionViewModel()
        let loader: Loader = .fromNib()
        loader.setView(hasLoader: true)
        transactionViewModel.getTransactions()
        transactionViewModel.getTotalBalance()
        UserDefaults.standard.setValue("$0", forKey: "balance")
        transactionViewModel.balance = { amount in
            let currentRatio: Double! = Double(amount)
            let str = String(format: "%.2f", currentRatio)
            self.lblBal.text = "$ \(str) USD"
            UserDefaults.standard.setValue(str, forKey: "balance")
        }
        transactionViewModel.bindTransactionViewModelToController = {
            loader.removeFromSuperview()
            self.lblNoData.isHidden = self.transactionViewModel.transactions.count > 0
            self.tableView.isHidden = !self.lblNoData.isHidden
            self.tableView.reloadData()
        }
    }
    private func setNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let yourBackImage = UIImage(named: "backGray")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return  dateFormatter.string(from: date!)
    }
}

// MARK: - Tableview delegate and datasource

extension TransactionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        92
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactionViewModel.transactions.count
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0.5)
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.identifier, for: indexPath) as! TransactionCell
        let date = self.convertDateFormater(transactionViewModel.transactions[indexPath.row].created_at)
        cell.lblTitle.text = date
        cell.lblSubTitle.text = transactionViewModel.transactions[indexPath.row].subTitle
        cell.lblAmount.text = transactionViewModel.transactions[indexPath.row].amountStr
        print(cell.lblAmount.text)
        let isCredit = transactionViewModel.transactions[indexPath.row].isCredit
        cell.icon.image = isCredit ? UIImage(systemName: "creditcard.circle")?.withTintColor(._appColorSecondary, renderingMode: .alwaysOriginal) : UIImage(systemName: "creditcard.circle")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        if transactionViewModel.transactions[indexPath.row].status == "CANCELED"{
            cell.lblSubTitle.text = "Funds Canceled"
            cell.lblSubTitle.textColor = .red
        } else {
            cell.lblSubTitle.textColor = UIColor(red: 208 / 255, green: 210 / 255, blue: 211 / 255, alpha: 1.0)
            cell.lblSubTitle.text = transactionViewModel.transactions[indexPath.row].subTitle
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = transactionViewModel.transactions[indexPath.row]
        transactionRouter.route(to: FundsAddedVC.identifier, from: self, parameters: ["amount": item.amount, "time": item.created_at.formattedTime, "status": item.status], animated: true)
    }
}
