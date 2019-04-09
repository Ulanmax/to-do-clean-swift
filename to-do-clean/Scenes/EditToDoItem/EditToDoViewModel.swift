import Domain
import RxSwift
import RxCocoa

final class EditToDoViewModel: ViewModelType {
    private let toDoItem: ToDoItem
    private let useCase: ToDoUseCase
    private let navigator: EditToDoNavigator

    init(toDoItem: ToDoItem, useCase: ToDoUseCase, navigator: EditToDoNavigator) {
        self.toDoItem = toDoItem
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let editing = input.editTrigger.scan(false) { editing, _ in
            return !editing
        }.startWith(false)

        let saveTrigger = editing.skip(1) //we dont need initial state
                .filter { $0 == false }
                .mapToVoid()
        let titleAndDetails = Driver.combineLatest(input.title, input.details)
        let toDoItem = Driver.combineLatest(Driver.just(self.toDoItem), titleAndDetails) { (toDoItem, titleAndDetails) -> ToDoItem in
            return ToDoItem(body: titleAndDetails.1, title: titleAndDetails.0, uid: toDoItem.uid, userId: toDoItem.userId, createdAt: toDoItem.createdAt, completed: toDoItem.completed)
        }.startWith(self.toDoItem)
        let editButtonTitle = editing.map { editing -> String in
            return editing == true ? "Save" : "Edit"
        }
        let saveToDoItem = saveTrigger.withLatestFrom(toDoItem)
                .flatMapLatest { toDoItem in
                    return self.useCase.save(todoItem: toDoItem)
                            .trackError(errorTracker)
                            .asDriverOnErrorJustComplete()
                }

        let deleteToDoItem = input.deleteTrigger.withLatestFrom(toDoItem)
            .flatMapLatest { toDoItem in
                return self.useCase.delete(todoItem: toDoItem)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.do(onNext: {
                self.navigator.toToDoList()
            })

        return Output(editButtonTitle: editButtonTitle,
                save: saveToDoItem,
                delete: deleteToDoItem,
                editing: editing,
                toDoItem: toDoItem,
                error: errorTracker.asDriver())
    }
}

extension EditToDoViewModel {
    struct Input {
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let title: Driver<String>
        let details: Driver<String>
    }

    struct Output {
        let editButtonTitle: Driver<String>
        let save: Driver<Void>
        let delete: Driver<Void>
        let editing: Driver<Bool>
        let toDoItem: Driver<ToDoItem>
        let error: Driver<Error>
    }
}
