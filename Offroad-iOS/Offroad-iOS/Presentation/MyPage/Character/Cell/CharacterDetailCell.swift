//
//  CharacterDetailCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/13/24.
//
import UIKit

import SnapKit

class CharacterDetailCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let containerView = UIView().then {
        $0.backgroundColor = UIColor.primary(.characterSelectBg3)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let characterLabel = UILabel().then {
        $0.text = ""
        $0.textAlignment = .center
        $0.textColor = UIColor.primary(.white)
        $0.font = UIFont.offroad(style: .iosTextContents)
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    private func setupViews() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.home(.homeCharacterName)
        
        contentView.addSubviews(containerView, characterLabel)
        containerView.addSubview(imageView)
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(162)
            make.height.equalTo(214)
        }
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(167)
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(contentView).inset(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(75)
            make.height.equalTo(136)
            make.center.equalToSuperview()
        }
        
        characterLabel.snp.makeConstraints{ make in
            make.top.equalTo(containerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(imageName: String) {
        imageView.image = UIImage(named: imageName)
        
        switch imageName {
        case "character_1":
            contentView.backgroundColor = UIColor.home(.homeCharacterName)
            containerView.backgroundColor = UIColor.primary(.characterSelectBg3)
            characterLabel.text = "카페 방문 시"
        case "character_2":
            contentView.backgroundColor = UIColor.myPage(.getCharacter2)
            containerView.backgroundColor = UIColor.primary(.characterSelectBg2)
            characterLabel.text = "공원 방문 시"
        case "character_3":
            contentView.backgroundColor = UIColor.home(.homeContents1GraphMain)
            containerView.backgroundColor = UIColor.primary(.characterSelectBg1)
            characterLabel.text = "식당 방문 시"
        default:
            contentView.backgroundColor = UIColor.gray
            containerView.backgroundColor = UIColor.darkGray
        }
    }
}

