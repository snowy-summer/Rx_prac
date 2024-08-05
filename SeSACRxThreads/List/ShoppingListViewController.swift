//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by 최승범 on 8/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingListViewController: UIViewController {
    
    private let searchView = UIView()
    private let searchTextField = UITextField()
    private let addButton = UIButton()
    private let tableView = UITableView()
    
    private let viewModel = ShoppingListViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureUI()
        bind()
    }
    
    private func bind() {
        
        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier,
                                         cellType: ShoppingListTableViewCell.self)) { row, element, cell in
                
                cell.updateContents(element)
                cell.checkboxButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.input.onNext(.toggleCheckBox(row))
                    }.disposed(by: cell.disposeBag)
                
                cell.starButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.viewModel.input.onNext(.toggleStarButton(row))
                    }
                    .disposed(by: cell.disposeBag)
                
            }.disposed(by: disposeBag)
        
        addButton.rx.tap
            .withLatestFrom(searchTextField.rx.text.orEmpty) { _, title in
                return title
            }
            .bind(with: self) { owner, value in
                owner.viewModel.input.onNext(.addTodoList(value))
            }
            .disposed(by: disposeBag)
        
        
        viewModel.output.bind(with: self) { owner, output in
            
            switch output {
                
            case.addTodoList:
                owner.searchTextField.text = ""
                owner.tableView.reloadData()
                
            case .changeListState(let row):
                owner.tableView.reloadRows(at: [IndexPath(row: row, section: 0)],
                                           with: .none)
            }
        }.disposed(by: disposeBag)
            
    }
    
    // MARK: - Configure
    
    private func configureHierarchy() {
        view.addSubview(searchView)
        [searchTextField, addButton].forEach {
            searchView.addSubview($0)
        }
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        searchView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(30)
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.height.equalTo(70)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(40)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.bottom.equalTo(safeArea)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "쇼핑"
        
        searchView.backgroundColor = .lightGray.withAlphaComponent(0.1)
        searchView.layer.cornerRadius = 10
        
        searchTextField.placeholder = "무엇을 구매하실 건가요?"
        
        addButton.setTitle("추가", for: .normal)
        addButton.backgroundColor = .lightGray.withAlphaComponent(0.3)
        addButton.setTitleColor(.black, for: .normal)
        addButton.layer.cornerRadius = 10
        
        tableView.register(ShoppingListTableViewCell.self,
                           forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
        tableView.rowHeight = 44
    }
    
}


struct ShoppingList {
    let date: Date = Date()
    let title: String
    var star: Bool = false
    var done: Bool = false
}
