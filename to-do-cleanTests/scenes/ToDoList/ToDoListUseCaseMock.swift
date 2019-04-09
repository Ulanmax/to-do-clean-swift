@testable import to_do_clean
import RxSwift
import Domain

class ToDoListUseCaseMock: Domain.ToDoUseCase {

  var toDoList_ReturnValue: Observable<[ToDoItem]> = Observable.just([])
  var toDoList_Called = false

  func todoItems() -> Observable<[ToDoItem]> {
    toDoList_Called = true
    return toDoList_ReturnValue
  }
    
    func save(todoItem: ToDoItem) -> Observable<Void> {
        toDoList_Called = true
        return Observable.just(())
    }
    
    func delete(todoItem: ToDoItem) -> Observable<Void> {
        toDoList_Called = true
        return Observable.just(())
    }
}
