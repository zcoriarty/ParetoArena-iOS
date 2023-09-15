////
////  ProfileRouter.swift
////  Pareto
////
////
//
//import UIKit
//
//class ProfileRouter: UIViewController, Router{
//    func route(to routeID: String, from context: UIViewController, parameters: Any?, animated: Bool) {
//        switch routeID {
//        case EditProfileVC.identifier:
//            if let vController = UIStoryboard.profile.instantiateViewController(withIdentifier: "editprofile") as? UINavigationController {
//                vController.modalPresentationStyle = .fullScreen
//                context.present(vController, animated: true, completion: nil)
//            }
//        case NotificationsVC.identifier:
//            if let vController = UIStoryboard.profile.instantiateViewController(withIdentifier: "notificationsSBView") as? UINavigationController {
////                vController.modalPresentationStyle = .fullScreen
//                context.present(vController, animated: true, completion: nil)
//            }
//        default:
//            self.view.makeToast("Invalid Input")
//        }
//        
//    }
//}
