//
//  QuestResultViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/18.
//

import UIKit

import SnapKit
import Then

enum QuestResult {
    case success
    case wrongLocation
    case wrongQR
}

class QuestResultViewController: UIViewController {
    
    //MARK: - Properties
    
    let rootView = QuestResultView()
    var result: QuestResult? = nil
    var placeInformation: RegisteredPlaceInfo?
    var superViewControlller: UIViewController? = nil
    
    init(result: QuestResult, superViewController: UIViewController? = nil, placeInfo: RegisteredPlaceInfo) {
        super.init(nibName: nil, bundle: nil)
        
        self.result = result
        self.superViewControlller = superViewController
        self.placeInformation = placeInfo
        rootView.configureView(result: result)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
    }
    
}


extension QuestResultViewController {
    
    //MARK: - @objc Func
    
    @objc private func dismissPopup() {
        guard let result else { return }
        guard let tabBarController = presentingViewController as? UITabBarController else { return }
        switch result {
        case .success:
            dismiss(animated: false)
            guard let homeViewController = tabBarController.viewControllers?[0] as? HomeViewController else { return }
            // homeViewController에서 로티 움직이게 설정
            guard let categoryString = placeInformation?.placeCategory.uppercased() else {
                print("placeInformation.placeCategory is nil")
                return
            }
            homeViewController.categoryString = categoryString
            tabBarController.selectedIndex = 0
        case .wrongLocation:
            dismiss(animated: false)
        case .wrongQR:
            dismiss(animated: false)
        }
        
    }
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        rootView.goToHomeButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
    }
    
    
    //MARK: - Func
    
    
}
