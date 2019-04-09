import UIKit
import Domain
import RxSwift
import RxCocoa

class ToDoListViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel: ToDoListViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createToDoButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindViewModel() {
        assert(viewModel != nil)
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = ToDoListViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                       createToDoTrigger: createToDoButton.rx.tap.asDriver(),
                                       selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        
        //Bind ToDoList to UITableView
        output.toDoList.drive(tableView.rx.items(cellIdentifier: ToDoTableViewCell.reuseID, cellType: ToDoTableViewCell.self)) { tv, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
        
        //Connect Create ToDoItem to UI
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        output.createToDo
            .drive()
            .disposed(by: disposeBag)
        output.selectedToDo
            .drive()
            .disposed(by: disposeBag)
    }
}



