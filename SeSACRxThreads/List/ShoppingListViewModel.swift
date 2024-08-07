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
    
//    struct Input {
//        let addText: ControlProperty<String>
//        let addButtonTap: ControlEvent<Void>
//        let toggleCheckBox: ControlEvent<Void>
//        let toggleStarButton: ControlEvent<Void>
//    }
    
    enum Input {
        case addTodoList(String)
        case toggleCheckBox(Int)
        case toggleStarButton(Int)
        case recommendClicked(String)
    }
//    
    
//    struct Output {
//        let todoList: Observable<[ShoppingList]>
//        let recommendList: Observable<[String]>
//    }
    enum Output {
        case addTodoList
        case changeListState(Int)
    }
    
    var input = PublishSubject<Input>()
    var output = PublishSubject<Output>()
    private var data = [ShoppingList]()
    var list = BehaviorSubject(value: [ShoppingList]())
    private var todoList = BehaviorSubject(value: [ShoppingList]())
    let recoList = BehaviorSubject(value: [
                "키보드",
                "책",
                "마우스",
                "헤드셋",
                "공책",
                "간식",
                "저녁"
            ])
    
    private let disposeBag = DisposeBag()
    
    
    init() {
        
        bind()
    }
//    
//    func transform(input: Input) -> Output {
//        
//        var list = BehaviorSubject(value: todoList)
//        let recoList = BehaviorSubject(value: [
//            "키보드",
//            "책",
//            "마우스",
//            "헤드셋",
//            "공책",
//            "간식",
//            "저녁"
//        ])
//        
//        input.addButtonTap
//            .withLatestFrom(input.addText)
//            .subscribe(with: self) { owner, value in
//                owner.data.append(ShoppingList(title: value))
//                
//            }.disposed(by: disposeBag)
//        let todoList = Observable.just(data)
//        return Output(todoList: todoList,
//                      recommendList: recoList)
//    }
    
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
            case .recommendClicked(let newElement):
                owner.data.append(ShoppingList(title: newElement))
                owner.list.onNext(owner.data)
                owner.output.onNext(.addTodoList)
            }
        }.disposed(by: disposeBag)
    }
    
}
