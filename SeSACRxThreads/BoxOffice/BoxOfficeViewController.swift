//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by 최승범 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BoxOfficeViewController: UIViewController {
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    private let viewModel = BoxOffiecViewModel()
    
    private let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()

    }
    
    
    func bind() {
        
        let recentText = PublishSubject<String>()
        
        
        
        
        let input = BoxOffiecViewModel.Input(recentText: recentText,
                                             searchButtonTap: searchBar.rx.searchButtonClicked,
                                             searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: BoxOfficeTableViewCell.identifier,
                                         cellType: BoxOfficeTableViewCell.self)) {row,element,cell in
                cell.appNameLabel.text = element.movieNm
            }.disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.modelSelected(String.self),
            tableView.rx.itemSelected
        )
        .debug()
        .map { "검색어는 \($0.0)"}
        .subscribe(with: self) { owner, value in
            recentText.onNext(value)
        }.disposed(by: disposeBag)
    }
    
    func createObservable() {
        let random = Observable<Int>.create { value in
            
            let result = Int.random(in: 1...100)
            
            if result >= 1 && result <= 45 {
                value.onNext(result)
            } else {
                value.onCompleted()
            }
            
            return Disposables.create()
        }
        
        random.subscribe(with: self) { owner, value in
            print("random \(value)")
        }.disposed(by: disposeBag)
    }
    
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.backgroundColor = .systemCyan
        tableView.rowHeight = 100
        tableView.register(BoxOfficeTableViewCell.self,
                           forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
