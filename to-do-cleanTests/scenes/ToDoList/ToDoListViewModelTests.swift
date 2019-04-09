@testable import to_do_clean
import Domain
import XCTest
import RxSwift
import RxCocoa
import RxBlocking

enum TestError: Error {
  case test
}

class ToDoViewModelTests: XCTestCase {

  var toDoUseCase: ToDoListUseCaseMock!
  var toDoListNavigator: ToDoListNavigatorMock!
  var viewModel: ToDoListViewModel!

  let disposeBag = DisposeBag()

  override func setUp() {
    super.setUp()

    toDoUseCase = ToDoListUseCaseMock()
    toDoListNavigator = ToDoListNavigatorMock()

    viewModel = ToDoListViewModel(useCase: toDoUseCase,
                               navigator: toDoListNavigator)
  }

  func test_transform_triggerInvoked_postEmited() {
    // arrange
    let trigger = PublishSubject<Void>()
    let input = createInput(trigger: trigger)
    let output = viewModel.transform(input: input)

    // act
    output.toDoList.drive().disposed(by: disposeBag)
    trigger.onNext(())

    // assert
    XCTAssert(toDoUseCase.toDoList_Called)
  }


  func test_transform_sendPost_trackFetching() {
    // arrange
    let trigger = PublishSubject<Void>()
    let output = viewModel.transform(input: createInput(trigger: trigger))
    let expectedFetching = [true, false]
    var actualFetching: [Bool] = []

    // act
    output.fetching
      .do(onNext: { actualFetching.append($0) },
          onSubscribe: { actualFetching.append(true) })
      .drive()
      .disposed(by: disposeBag)
    trigger.onNext(())

    // assert
    XCTAssertEqual(actualFetching, expectedFetching)
  }

  func test_transform_postEmitError_trackError() {
    // arrange
    let trigger = PublishSubject<Void>()
    let output = viewModel.transform(input: createInput(trigger: trigger))
    toDoUseCase.toDoList_ReturnValue = Observable.error(TestError.test)

    // act
    output.toDoList.drive().disposed(by: disposeBag)
    output.error.drive().disposed(by: disposeBag)
    trigger.onNext(())
    let error = try! output.error.toBlocking().first()

    // assert
    XCTAssertNotNil(error)
  }

  func test_transform_triggerInvoked_mapToDoListToViewModels() {
    // arrange
    let trigger = PublishSubject<Void>()
    let output = viewModel.transform(input: createInput(trigger: trigger))
    toDoUseCase.toDoList_ReturnValue = Observable.just(createToDoList())

    // act
    output.toDoList.drive().disposed(by: disposeBag)
    trigger.onNext(())
    let toDoList = try! output.toDoList.toBlocking().first()!

    // assert
    XCTAssertEqual(toDoList.count, 2)
  }

  func test_transform_selectedToDoItemInvoked_navigateToToDo() {
    // arrange
    let select = PublishSubject<IndexPath>()
    let output = viewModel.transform(input: createInput(selection: select))
    let toDoList = createToDoList()
    toDoUseCase.toDoList_ReturnValue = Observable.just(toDoList)

    // act
    output.toDoList.drive().disposed(by: disposeBag)
    output.selectedToDo.drive().disposed(by: disposeBag)
    select.onNext(IndexPath(row: 1, section: 0))

    // assert
    XCTAssertTrue(toDoListNavigator.toToDo_toDo_Called)
    XCTAssertEqual(toDoListNavigator.toToDo_toDo_ReceivedArguments, toDoList[1])
  }

  func test_transform_createToDoInvoked_navigateToCreateToDo() {
    // arrange
    let create = PublishSubject<Void>()
    let output = viewModel.transform(input: createInput(createToDoTrigger: create))
    let toDoList = createToDoList()
    toDoUseCase.toDoList_ReturnValue = Observable.just(toDoList)

    // act
    output.toDoList.drive().disposed(by: disposeBag)
    output.createToDo.drive().disposed(by: disposeBag)
    create.onNext(())

    // assert
    XCTAssertTrue(toDoListNavigator.toCreateToDo_Called)
  }

  private func createInput(trigger: Observable<Void> = Observable.just(()),
                           createToDoTrigger: Observable<Void> = Observable.never(),
                           selection: Observable<IndexPath> = Observable.never())
    -> ToDoListViewModel.Input {
        
      return ToDoListViewModel.Input(
        trigger: trigger.asDriverOnErrorJustComplete(),
        createToDoTrigger: createToDoTrigger.asDriverOnErrorJustComplete(),
        selection: selection.asDriverOnErrorJustComplete())
  }

  private func createToDoList() -> [ToDoItem] {
    return [
        ToDoItem(body: "body 1", title: "title 1", uid: "uid 1", userId: "userId 1", createdAt: "date", completed: false),
      ToDoItem(body: "body 2", title: "title 2", uid: "uid 2", userId: "userId 2", createdAt: "date", completed: false)
    ]
  }
}
