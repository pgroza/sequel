//
//  QuestMapViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import UIKit

import NMapsMap
import SnapKit
import Then

class QuestMapViewController: UIViewController {
    
    //MARK: - UI Properties
    
    private let rootView = QuestMapView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
    }
    
}


extension QuestMapViewController {
    
    //MARK: - @objc
    
    @objc private func pushQuestListViewController() {
        print(#function)
    }
    
    @objc private func pushPlaceListViewController() {
        print(#function)
    }
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        rootView.questListButton.addTarget(self, action: #selector(pushQuestListViewController), for: .touchUpInside)
        rootView.placeListButton.addTarget(self, action: #selector(pushPlaceListViewController), for: .touchUpInside)
    }
    
}
