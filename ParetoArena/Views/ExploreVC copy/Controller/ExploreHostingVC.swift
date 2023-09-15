//
//  ExploreHostingVC.swift
//  Pareto
//
//  Created by Zachary Coriarty on 4/10/23.
//

import Foundation
import UIKit
import SwiftUI


class ExploreHostingVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        let exploreAppViewController = ExploreViewController()
        addChild(exploreAppViewController)
        exploreAppViewController.didMove(toParent: self) // add this line
        

        
        view.addSubview(exploreAppViewController.view)
        exploreAppViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exploreAppViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            exploreAppViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            exploreAppViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            exploreAppViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        
    }
    
    
}
