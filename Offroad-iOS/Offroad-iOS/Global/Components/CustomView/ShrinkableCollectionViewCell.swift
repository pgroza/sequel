//
//  ShrinkableCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/5/25.
//

import UIKit

class ShrinkableCollectionViewCell: UICollectionViewCell, Shrinkable {
    
    //MARK: - Properties
    
    var shrinkScale: CGFloat
    let shrinkingAnimator: UIViewPropertyAnimator = .init(duration: 0.15, curve: .easeOut)
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                shrink(scale: shrinkScale)
            } else {
                restore()
            }
        }
    }
    
    //MARK: - Life Cycle
    
    /// shrinkScale을 0.97로 설정
    ///
    /// `shrinkScale` 속성을 임의로 초기화하고 싶은 경우, 다른 지정생성자인 `init(shrinkScale:)`를 사용하세요.
    override init(frame: CGRect) {
        self.shrinkScale = 0.97
        super.init(frame: frame)
    }
    
    /// `shrinkScale` 속성을 임의의 값으로 초기화하는 지정생성자
    /// - Parameter shrinkScale: 손가락이 버튼에 닿을 때 축소될 비율에 해당하는 속성. 다른 지정생성자인 `init(frame:)`를 사용하는 경우 0.9로 설정됨.
    init(shrinkScale: CGFloat) {
        self.shrinkScale = shrinkScale
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
