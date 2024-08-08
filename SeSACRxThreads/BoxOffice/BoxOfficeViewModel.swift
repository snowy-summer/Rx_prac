//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by 최승범 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOffiecViewModel {
    
    struct Input {
        let recentText: PublishSubject<String>
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let movieList: PublishSubject<[DailyBoxOfficeList]>
        let recentList: Observable<[String]>
    }
    
    private let movieList = Observable.just(["1","2"])
    private var recentList = ["p"]
    
    private let disposeBag = DisposeBag()
    
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorSubject(value: recentList)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        
        input.recentText
            .subscribe(with: self) { owner, value in
                
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 20240701
                }
                
                return intText
            }
            .map { return  "\($0)"}
            .flatMap { value in
                NetworkManager.shared.callBoxOffice(date: value)
            }
            .debug("aaaaaaaaa")
            .subscribe(with: self, onNext: { owner, value in
                
                boxOfficeList.onNext(value.boxOfficeResult.dailyBoxOfficeList)
                
            }, onError: { owner, error in
                print("error:\(error)")
            }, onCompleted: { owner in
                print("끝")
            }, onDisposed: { owner in
                print("ㄲㄲㄲ끝")
            })
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, value in
                
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        
        
        
        return Output(movieList: boxOfficeList,
                      recentList: recentList)
    }
    
    
}


