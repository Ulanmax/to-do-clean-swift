//
//  Application.swift
//  to-do-clean
//
//  Created by Maks Niagolov on 08/04/2019.
//  Copyright © 2019 Maksim Niagolov. All rights reserved.
//

import Foundation
import Domain
import CoreDataPlatform
import RealmPlatform

final class Application {
    static let shared = Application()
    
    private let coreDataUseCaseProvider: Domain.UseCaseProvider
    private let realmUseCaseProvider: Domain.UseCaseProvider
    
    private init() {
        self.coreDataUseCaseProvider = CoreDataPlatform.UseCaseProvider()
        self.realmUseCaseProvider = RealmPlatform.UseCaseProvider()
    }
    
    func configureMainInterface(in window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cdNavigationController = UINavigationController()
        cdNavigationController.tabBarItem = UITabBarItem(title: "CoreData",
                                                         image: UIImage(named: "database"),
                                                         selectedImage: nil)
        let cdNavigator = DefaultToDoListNavigator(services: coreDataUseCaseProvider,
                                                navigationController: cdNavigationController,
                                                storyBoard: storyboard)
        
        let rmNavigationController = UINavigationController()
        rmNavigationController.tabBarItem = UITabBarItem(title: "Realm",
                                                         image: UIImage(named: "database"),
                                                         selectedImage: nil)
        let rmNavigator = DefaultToDoListNavigator(services: realmUseCaseProvider,
                                                navigationController: rmNavigationController,
                                                storyBoard: storyboard)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            cdNavigationController,
            rmNavigationController
        ]
        window.rootViewController = tabBarController
        
        cdNavigator.toToDoList()
        rmNavigator.toToDoList()
    }
}
