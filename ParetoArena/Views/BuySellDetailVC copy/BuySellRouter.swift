//
//  BuySellRouter.swift
//  Pareto
//
//

import UIKit

class BuySellRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        if let vController = UIStoryboard.portfolio.instantiateViewController(withIdentifier: BuyViewController.identifier) as? BuyViewController {
            vController.object = parameters as? CurrentStock
            context.navigationController?.pushViewController(vController, animated: animated)
        }
    }
}
