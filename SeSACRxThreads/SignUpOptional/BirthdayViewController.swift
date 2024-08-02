//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import RxSwift
import RxCocoa
import SnapKit

/*
 화면 진입시 오늘 날짜 데이트 피커와 레이블에 보여주기
 데이트 피커에서 선택한 날짜로 나이 계산했을 때, 만 17세 이상이 아니라면 infoLabel에 만 17세 이상만 가입 가능하다고 보여주기
 글자 빨간색, 버튼 lightGray 클릭 안됨
 조건 만족되면 "가입 가능한 나이입니다" 텍스트와 파란 글씨로 변경, 버튼은 파란색
 클릭시 완료 alert
 */

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    private let date = BehaviorRelay(value: Date())
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
    
        bind()
    }
    
    private func bind() {
        
        birthDayPicker.rx.date
            .bind(to: date)
            .disposed(by: disposeBag)
        
        date.bind(with: self) { owner, value in
            let component = Calendar.current.dateComponents([.year,.month,.day], from: value)
            
            owner.yearLabel.text = "\(component.year!) 년"
            owner.monthLabel.text = "\(component.month!) 월"
            owner.dayLabel.text = "\(component.day!) 일"
        }
        .disposed(by: disposeBag)
        
        date.map {
            Calendar.current.dateComponents([.year], from: $0, to: Date()).year! >= 17
        }.bind(with: self) { owner, value in
            owner.infoLabel.text = value ? "가입 가능한 나이입니다." : "만 17세 이상만 가입 가능합니다."
        }
        .disposed(by: disposeBag)
        
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
        
    }

    private func showAlert() {
        
        let profileAlert = UIAlertController(title: "완료",
                                             message: "완~료",
                                             preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인",
                                          style: .cancel)
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .default)
        
        profileAlert.addAction(confirmAction)
        profileAlert.addAction(cancelAction)
        
        self.present(profileAlert,
                     animated: false)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
        
        birthDayPicker.date = Date()
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
