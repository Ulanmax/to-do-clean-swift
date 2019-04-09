//
//  CDPost+CoreDataClass.swift
//  NetworkAndSecurity
//
//  Created by sergdort on 07/01/2017.
//  Copyright © 2017 sergdort. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import Domain
import QueryKit
import RxSwift

extension CDTodo {
    static var title: Attribute<String> { return Attribute("title")}
    static var body: Attribute<String> { return Attribute("body")}
    static var userId: Attribute<String> { return Attribute("userId")}
    static var uid: Attribute<String> { return Attribute("uid")}
    static var createdAt: Attribute<String> { return Attribute("createdAt")}
    static var completed: Attribute<Bool> { return Attribute("completed")}
}

extension CDTodo: DomainConvertibleType {
    func asDomain() -> ToDoItem {
        return ToDoItem(
            body: body!,
            title: title!,
            uid: uid!,
            userId: userId!,
            createdAt: createdAt!,
            completed: completed
        )
    }
}

extension CDTodo: Persistable {
    static var entityName: String {
        return "CDTodo"
    }
}

extension ToDoItem: CoreDataRepresentable {
    typealias CoreDataType = CDTodo
    
    func update(entity: CDTodo) {
        entity.uid = uid
        entity.title = title
        entity.body = body
        entity.userId = userId
        entity.createdAt = createdAt
        entity.completed = completed
    }
}
