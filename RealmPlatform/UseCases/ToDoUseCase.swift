import Foundation
import Domain
import RxSwift
import Realm
import RealmSwift

final class ToDoUseCase<Repository>: Domain.ToDoUseCase where Repository: AbstractRepository, Repository.T == ToDoItem {

    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func todoItems() -> Observable<[ToDoItem]> {
        return repository.queryAll()
    }
    
    func save(todoItem: ToDoItem) -> Observable<Void> {
        return repository.save(entity: todoItem)
    }

    func delete(todoItem: ToDoItem) -> Observable<Void> {
        return repository.delete(entity: todoItem)
    }
}
