//
//  FundsAddedRouter.swift
//  Pareto
//
//

import UIKit

class FundsAddedRouter: Router {
    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        context.navigationController?.popViewController(animated: true)
    }
    func routeToParent(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
        context.navigationController?.popToRootViewController(animated: true)
    }
}
