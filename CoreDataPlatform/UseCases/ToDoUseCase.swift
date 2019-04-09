import Foundation
import Domain
import RxSwift

final class ToDoUseCase<Repository>: Domain.ToDoUseCase where Repository: AbstractRepository, Repository.T == ToDoItem {
    
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    
    func todoItems() -> Observable<[ToDoItem]> {
        return repository.query(with: nil, sortDescriptors: [ToDoItem.CoreDataType.createdAt.descending()])
    }
    
    func save(todoItem: ToDoItem) -> Observable<Void> {
        return repository.save(entity: todoItem)
    }
    
    func delete(todoItem: ToDoItem) -> Observable<Void> {
        return repository.delete(entity: todoItem)
    }
}
