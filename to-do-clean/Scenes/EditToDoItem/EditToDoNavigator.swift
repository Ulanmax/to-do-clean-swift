import Foundation
import UIKit
import Domain

protocol EditToDoNavigator {
    func toToDoList()
}

final class DefaultEditToDoNavigator: EditToDoNavigator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toToDoList() {
        navigationController.popViewController(animated: true)
    }
}
