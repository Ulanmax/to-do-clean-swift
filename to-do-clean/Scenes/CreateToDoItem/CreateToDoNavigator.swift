//
// Created by sergdort on 19/02/2017.
// Copyright (c) 2017 sergdort. All rights reserved.
//


import Foundation
import UIKit
import Domain

protocol CreateToDoNavigator {

    func toToDoList()
}

final class DefaultCreateToDoNavigator: CreateToDoNavigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toToDoList() {
        navigationController.dismiss(animated: true)
    }
}
