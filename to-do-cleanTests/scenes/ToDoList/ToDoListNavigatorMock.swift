@testable import to_do_clean
import Domain
import RxSwift

class ToDoListNavigatorMock: ToDoListNavigator {

  var toToDoList_Called = false

  func toToDoList() {
    toToDoList_Called = true
  }

  var toCreateToDo_Called = false

  func toCreateToDoItem() {
    toCreateToDo_Called = true
  }

  var toToDo_toDo_Called = false
    
  var toToDo_toDo_ReceivedArguments: ToDoItem?

  func toToDoItem(_ toDoItem: ToDoItem) {
    toToDo_toDo_Called = true
    toToDo_toDo_ReceivedArguments = toDoItem
  }
  
}
