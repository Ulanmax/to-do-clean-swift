import UIKit
import Domain

protocol ToDoListNavigator {
    func toCreateToDoItem()
    func toToDoItem(_ todoItem: ToDoItem)
    func toToDoList()
}

class DefaultToDoListNavigator: ToDoListNavigator {
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let services: UseCaseProvider

    init(services: UseCaseProvider,
         navigationController: UINavigationController,
         storyBoard: UIStoryboard) {
        self.services = services
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
    
    func toToDoList() {
        let vc = storyBoard.instantiateViewController(ofType: ToDoListViewController.self)
        vc.viewModel = ToDoListViewModel(useCase: services.makeToDoUseCase(),
                                      navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }

    func toCreateToDoItem() {
        let navigator = DefaultCreateToDoNavigator(navigationController: navigationController)
        let viewModel = CreateToDoViewModel(createToDoUseCase: services.makeToDoUseCase(),
                navigator: navigator)
        let vc = storyBoard.instantiateViewController(ofType: CreateToDoViewController.self)
        vc.viewModel = viewModel
        let nc = UINavigationController(rootViewController: vc)
        navigationController.present(nc, animated: true, completion: nil)
    }

    func toToDoItem(_ todoItem: ToDoItem) {
        let navigator = DefaultEditToDoNavigator(navigationController: navigationController)
        let viewModel = EditToDoViewModel(toDoItem: todoItem, useCase: services.makeToDoUseCase(), navigator: navigator)
        let vc = storyBoard.instantiateViewController(ofType: EditToDoViewController.self)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
