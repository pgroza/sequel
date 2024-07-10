//
//  QuestMapListButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/10.
//

import UIKit

import SnapKit
import Then

class QuestMapListButton: UIButton {
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImageView, title: String) {
        self.init(frame: .zero)
        
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.offroad(style: .iosBtnSmall)
            outgoing.foregroundColor = UIColor.primary(.white)
            return outgoing
        }
        
        var filledConfiguration = UIButton.Configuration.filled()
        filledConfiguration.title = title
        filledConfiguration.baseForegroundColor = .main(.main2)
        filledConfiguration.contentInsets = .init(top: 9, leading: 21, bottom: 9, trailing: 21)
        filledConfiguration.imagePadding = 10
        self.configuration = filledConfiguration
    }
    
    
}
