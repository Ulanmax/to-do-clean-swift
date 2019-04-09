import Foundation
import Domain
import RxSwift
import RxCocoa

final class ToDoListViewModel: ViewModelType {

    struct Input {
        let trigger: Driver<Void>
        let createToDoTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let fetching: Driver<Bool>
        let toDoList: Driver<[ToDoItemViewModel]>
        let createToDo: Driver<Void>
        let selectedToDo: Driver<ToDoItem>
        let error: Driver<Error>
    }

    private let useCase: ToDoUseCase
    private let navigator: ToDoListNavigator
    
    init(useCase: ToDoUseCase, navigator: ToDoListNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let toDoList = input.trigger.flatMapLatest {
            return self.useCase.todoItems()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { ToDoItemViewModel(with: $0) } }
        }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedToDo = input.selection
            .withLatestFrom(toDoList) { (indexPath, toDoList) -> ToDoItem in
                return toDoList[indexPath.row].toDoItem
            }
            .do(onNext: navigator.toToDoItem)
        let createToDo = input.createToDoTrigger
            .do(onNext: navigator.toCreateToDoItem)
        
        return Output(fetching: fetching,
                      toDoList: toDoList,
                      createToDo: createToDo,
                      selectedToDo: selectedToDo,
                      error: errors)
    }
}
