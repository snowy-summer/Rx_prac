//
//  ShoppingListCell.swift
//  SeSACRxThreads
//
//  Created by 최승범 on 8/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ShoppingListTableViewCell: UITableViewCell {
    
    let checkboxButton = UIButton()
    let titleLabel = UILabel()
    let starButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func updateContents(_ content: ShoppingList) {
        titleLabel.text = content.title
        starButton.setImage(UIImage(systemName: content.star ? "star.fill" : "star"),
                            for: .normal)
        checkboxButton.setImage(UIImage(systemName: content.done ? "checkmark.square" : "square"),
                                for: .normal)
    }
    
    func toggleCheckbox(_ done: Bool) {
        checkboxButton.setImage(UIImage(systemName: done ? "checkmark.square" : "square"),
                                for: .normal)
    }
    
    func toggleStarButton(_ star: Bool) {
        starButton.setImage(UIImage(systemName: star ? "star.fill" : "star"),
                            for: .normal)
    }
    
    // MARK: - Configure
    
    private func configureHierarchy() {
        contentView.addSubview(checkboxButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(starButton)
    }
    
    private func configureUI() {
        
        backgroundColor = .lightGray.withAlphaComponent(0.1)
        layer.cornerRadius = 8
        
        checkboxButton.setImage(UIImage(systemName: "square"),
                                for: .normal)
        checkboxButton.tintColor = .black
        
        starButton.setImage(UIImage(systemName: "star"),
                            for: .normal)
        starButton.tintColor = .black
    }
    
    private func configureLayout() {
        
        checkboxButton.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(20)
            make.centerY.equalTo(contentView)
        }
        
        starButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkboxButton.snp.trailing).offset(20)
            
            make.centerY.equalTo(contentView)
        }
    }
    
}
