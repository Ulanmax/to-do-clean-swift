import QueryKit
import Domain
import RealmSwift
import Realm

final class RMToDo: Object {
    @objc dynamic var completed: Bool = false
    @objc dynamic var uid: String = ""
    @objc dynamic var userId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var createdAt: String = ""

    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension RMToDo {
    static var title: Attribute<String> { return Attribute("title")}
    static var body: Attribute<String> { return Attribute("body")}
    static var userId: Attribute<String> { return Attribute("userId")}
    static var uid: Attribute<String> { return Attribute("uid")}
    static var createdAt: Attribute<String> { return Attribute("createdAt")}
    static var completed: Attribute<Bool> { return Attribute("completed")}
}

extension RMToDo: DomainConvertibleType {
    func asDomain() -> ToDoItem {
        return ToDoItem(body: body,
                        title: title,
                        uid: uid,
                        userId: userId,
                        createdAt: createdAt,
                        completed: completed)
    }
}

extension ToDoItem: RealmRepresentable {
    func asRealm() -> RMToDo {
        return RMToDo.build { object in
            object.uid = uid
            object.userId = userId
            object.title = title
            object.body = body
            object.createdAt = createdAt
            object.completed = completed
        }
    }
}
