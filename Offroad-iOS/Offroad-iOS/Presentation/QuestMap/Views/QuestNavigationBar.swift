//
//  QuestNavigationBar.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/11.
//

import UIKit

import SnapKit
import Then

class QuestNavigationBar: UIView {
    
    enum QuestNavigationView {
        case questMap
        case questQR
    }
    
    
    //MARK: - Properties
    
    
    //MARK: - UI Properties
    
    private let navigationTitleLabel = UILabel()
    private let customBackButton = UIButton()
      
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
}



extension QuestNavigationBar {
    
    
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(navigationTitleLabel, customBackButton)
    }
    
    private func setupLayout() {
        navigationTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26.41)
            make.bottom.equalToSuperview().inset(25.59)
            make.leading.equalToSuperview().inset(24)
        }
        
        customBackButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
    }
    
    private func setupStyle() {
        navigationTitleLabel.do { label in
            label.text = "어디를 탐험해 볼까요?"
            label.font = .offroad(style: .iosSubtitle2Bold)
            label.textAlignment = .left
        }
        
        customBackButton.do { button in
            var configuration = UIButton.Configuration.plain()
            configuration.baseForegroundColor = .primary(.white)
            configuration.image = UIImage(systemName: "chevron.left")
            configuration.imagePlacement = .leading
            configuration.title = "이전 화면"
            
            button.configuration = configuration
        }
        
    }
    
    //MARK: - Func
    
    func changeState(to view: QuestNavigationView) {
        switch view {
        case .questMap:
            self.navigationTitleLabel.isHidden = false
            self.customBackButton.isHidden = true
        case .questQR:
            self.navigationTitleLabel.isHidden = true
            self.customBackButton.isHidden = false
        }
    }
}
