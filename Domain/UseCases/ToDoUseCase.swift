import Foundation
import RxSwift

public protocol ToDoUseCase {
    func todoItems() -> Observable<[ToDoItem]>
    func save(todoItem: ToDoItem) -> Observable<Void>
    func delete(todoItem: ToDoItem) -> Observable<Void>
}
