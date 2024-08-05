//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by 최승범 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingListViewModel {
    
    enum Input {
        case addTodoList(String)
        case toggleCheckBox(Int)
        case toggleStarButton(Int)
    }
    
    enum Output {
        case addTodoList
        case changeListState(Int)
    }
    
    var input = PublishSubject<Input>()
    var output = PublishSubject<Output>()
    private var data = [ShoppingList]()
    var list = BehaviorSubject(value: [ShoppingList]())
    
    
    private let disposeBag = DisposeBag()
    
    
    init() {
        
        bind()
    }
    
    private func bind() {
        
        input.bind(with: self) { owner, input in
            
            switch input {
            case .addTodoList(let todoName):
                
                owner.data.append(ShoppingList(title: todoName))
                owner.list.onNext(owner.data)
                owner.output.onNext(.addTodoList)
                
            case .toggleCheckBox(let row):
                owner.data[row].done.toggle()
                owner.list.onNext(owner.data)
                owner.output.onNext(.changeListState(row))
                
            case .toggleStarButton(let row):
                owner.data[row].star.toggle()
                owner.list.onNext(owner.data)
                owner.output.onNext(.changeListState(row))
            }
        }.disposed(by: disposeBag)
    }
    
}
