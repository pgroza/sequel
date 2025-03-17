//
//  MemoryLightGradientView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/17/25.
//

import UIKit

final class MemoryLightGradientView: UIView {
        
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupStyle()
    }
}

private extension MemoryLightGradientView {
    
    //MARK: - Layout
    
    func setupStyle() {
        roundCorners(cornerRadius: bounds.width / 2)
    }
}

extension MemoryLightGradientView {
    func setupGradientBlurView(pointColorCode: String, baseColorCode: String) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(hexCode: pointColorCode)?.cgColor ?? UIColor(),
            UIColor(hexCode: baseColorCode)?.cgColor ?? UIColor()
        ]
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.2  )
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [0.0, 1.0]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
