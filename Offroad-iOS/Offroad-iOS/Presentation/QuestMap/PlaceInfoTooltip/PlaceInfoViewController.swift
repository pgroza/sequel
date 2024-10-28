//
//  PlaceInfoViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

class PlaceInfoViewController: UIViewController {
    
    let rootView: PlaceInfoView
    
    init(contentFrame: CGRect) {
        self.rootView = PlaceInfoView(contentFrame: contentFrame)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTargets()
    }
    
}

extension PlaceInfoViewController {
    
    
    //MARK: - @objc Private Func
    
    @objc private func closeButtonTapped() {
        rootView.hideTooltip {
            return
        }
    }
    
    //MARK: - Private Func
    
    private func setupTargets() {
        rootView.tooltip.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
}
