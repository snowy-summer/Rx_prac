//
//  ShoppingRecommendCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by 최승범 on 8/7/24.
//

import UIKit
import RxSwift
import SnapKit

final class ShoppingRecommendCollectionViewCell: UICollectionViewCell {
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func configure() {
        contentView.addSubview(appNameLabel)
        
        layer.borderWidth = 1
        
        appNameLabel.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
}

