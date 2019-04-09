//
//  ToDoItemViewModel.swift
//  to-do-clean
//
//  Created by Maks Niagolov on 08/04/2019.
//  Copyright © 2019 Maksim Niagolov. All rights reserved.
//

import Foundation
import Domain

final class ToDoItemViewModel   {
    let title:String
    let subtitle : String
    let toDoItem: ToDoItem
    init (with toDoItem:ToDoItem) {
        self.toDoItem = toDoItem
        self.title = toDoItem.title.uppercased()
        self.subtitle = toDoItem.body
    }
}
