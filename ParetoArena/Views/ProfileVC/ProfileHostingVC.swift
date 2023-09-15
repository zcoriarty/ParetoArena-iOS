//
//  ProfileHostingVC.swift
//  Pareto
//
//  Created by Zachary Coriarty on 3/21/23.
//

import Foundation
import UIKit
import SwiftUI


class ProfileHostingVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        let profileViewController = ProfileViewController()
        addChild(profileViewController)
        profileViewController.didMove(toParent: self) // add this line
        

        
        view.addSubview(profileViewController.view)
        profileViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            profileViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

