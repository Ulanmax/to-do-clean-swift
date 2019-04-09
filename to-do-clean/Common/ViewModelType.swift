//
//  ViewModelType.swift
//  to-do-clean
//
//  Created by Maks Niagolov on 08/04/2019.
//  Copyright © 2019 Maksim Niagolov. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
