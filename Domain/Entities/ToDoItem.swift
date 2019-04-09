import Foundation

public struct ToDoItem: Codable {
    public let body: String
    public let title: String
    public let uid: String
    public let userId: String
    public let createdAt: String
    public let completed: Bool

    public init(body: String,
                title: String,
                uid: String,
                userId: String,
                createdAt: String,
                completed: Bool
        ) {
        self.body = body
        self.title = title
        self.uid = uid
        self.userId = userId
        self.createdAt = createdAt
        self.completed = completed
    }

    public init(body: String, title: String) {
        self.init(body: body, title: title, uid: NSUUID().uuidString, userId: "5", createdAt: String(round(Date().timeIntervalSince1970 * 1000)), completed: false)
    }

    private enum CodingKeys: String, CodingKey {
        case body
        case title
        case uid
        case userId
        case createdAt
        case completed
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        body = try container.decode(String.self, forKey: .body)
        title = try container.decode(String.self, forKey: .title)

        if let createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt) {
            self.createdAt = "\(createdAt)"
        } else {
            createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        }

        if let userId = try container.decodeIfPresent(Int.self, forKey: .userId) {
            self.userId = "\(userId)"
        } else {
            userId = try container.decode(String.self, forKey: .userId)
        }

        if let uid = try container.decodeIfPresent(Int.self, forKey: .uid) {
            self.uid = "\(uid)"
        } else {
            uid = try container.decodeIfPresent(String.self, forKey: .uid) ?? ""
        }
        
        completed = try container.decode(Bool.self, forKey: .completed)
    }
}

extension ToDoItem: Equatable {
    public static func == (lhs: ToDoItem, rhs: ToDoItem) -> Bool {
            return lhs.uid == rhs.uid &&
                lhs.title == rhs.title && 
                lhs.body == rhs.body &&
                lhs.userId == rhs.userId &&
                lhs.createdAt == rhs.createdAt &&
                lhs.completed == rhs.completed
    }
}
