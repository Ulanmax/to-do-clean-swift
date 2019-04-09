import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
    private let coreDataStack = CoreDataStack()
    private let todoRepository: Repository<ToDoItem>

    public init() {
        todoRepository = Repository<ToDoItem>(context: coreDataStack.context)
    }

    public func makeToDoUseCase() -> Domain.ToDoUseCase {
        return ToDoUseCase(repository: todoRepository)
    }
}
