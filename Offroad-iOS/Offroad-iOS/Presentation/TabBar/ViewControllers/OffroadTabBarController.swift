//
//  OffroadTabBarController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/12.
//

import UIKit

class OffroadTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let centerTabBarItemSideLength: CGFloat = 85
    let tabBarItemWidth: CGFloat = 77
    var originalTabBarHeight: CGFloat = 0
    private var hideTabBarAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    private var showTabBarAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    
    //MARK: - UI Properties
    
    let customOffroadLogoButton = UIButton()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHierarchy()
        setupLayout()
        setupStyle()
        setOffroadViewControllers()
        setTabBarButtons()
        setupButtonsAction()
        setupDelegates()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let screenWidth = UIScreen.current.bounds.width
        guard let itemsCount = tabBar.items?.count else { return }
        
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemWidth = tabBarItemWidth
        self.tabBar.itemSpacing
        = (screenWidth - centerTabBarItemSideLength - (77 * (CGFloat(itemsCount) - 1))) / 4
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        originalTabBarHeight = tabBar.frame.height
        
        let tabBarHeightFromBottomEdge: CGFloat = 96
        var newFrame = tabBar.frame
        newFrame.size.height = tabBarHeightFromBottomEdge
        newFrame.origin.y = view.frame.size.height - tabBarHeightFromBottomEdge
        tabBar.frame = newFrame
    }
    
}

extension OffroadTabBarController {
    
    @objc private func centerTabBarButtonItemTapped() {
        selectedIndex = 1
    }
    
    // MARK: - Layout
    
    private func setupHierarchy() {
        tabBar.addSubview(customOffroadLogoButton)
    }
    
    private func setupLayout() {
        customOffroadLogoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(36)
            make.width.height.equalTo(85)
        }
    }
    
    private func setupStyle() {
        customOffroadLogoButton.do { button in
            button.setImage(.icnTabBarOffroadLogo, for: .normal)
        }
        
        tabBar.clipsToBounds = false
        tabBar.backgroundColor = .sub(.sub4)
        
        tabBar.tintColor = .main(.main1)
        tabBar.unselectedItemTintColor = .main(.main175)
    }
    
    private func setOffroadViewControllers() {
        let mypageNavigationController = UINavigationController(rootViewController: MyPageViewController())
        
        let viewControllersArray: [UIViewController] = [
            HomeViewController(),
            UINavigationController(rootViewController: QuestMapViewController()),
            mypageNavigationController
        ]
        
        setViewControllers(viewControllersArray, animated: false)
        selectedIndex = 0
    }
    
    private func setTabBarButtons() {
        tabBar.items?[0].image = UIImage.icnHome
        tabBar.items?[0].title = "Home"
        
        tabBar.items?[1].image = nil
        tabBar.items?[1].title = nil
        tabBar.items?[1].isEnabled = false
        
        tabBar.items?[2].image = UIImage.icnPerson
        tabBar.items?[2].title = "My"
    }
    
    private func setupDelegates() {
        guard let questMapNavigationController = viewControllers?[1] as? UINavigationController else { return }
        guard let myPageNavigationController = viewControllers?[2] as? UINavigationController else { return }
        questMapNavigationController.delegate = self
        myPageNavigationController.delegate = self
    }
    
    private func disableTabBarInteraction() {
        tabBar.items?.forEach({ item in
            item.isEnabled = false
        })
        customOffroadLogoButton.isUserInteractionEnabled = false
    }
    
    private func enableTabBarInteraction() {
        tabBar.items?.forEach({ item in
            item.isEnabled = true
        })
        customOffroadLogoButton.isUserInteractionEnabled = true
    }
        
    // MARK: - Func
    
    private func setupButtonsAction() {
        customOffroadLogoButton.addTarget(self, action: #selector(centerTabBarButtonItemTapped), for: .touchUpInside)
    }
    
    func hideTabBarAnimation(delayFactor: CGFloat = 0) {
        hideTabBarAnimator.addAnimations({ [weak self] in
            self?.showTabBarAnimator.stopAnimation(true)
            self?.tabBar.frame.origin.y = UIScreen.current.bounds.height + 30
        }, delayFactor: delayFactor)
        hideTabBarAnimator.addCompletion { _ in
            self.tabBar.isHidden = true
        }
        hideTabBarAnimator.startAnimation()
    }
    
    func showTabBarAnimation(delayFactor: CGFloat = 0) {
        if tabBar.isHidden {
            tabBar.frame.origin.y = UIScreen.current.bounds.height + 30
            tabBar.isHidden = false
        }
        showTabBarAnimator.addAnimations({ [weak self] in
            self?.hideTabBarAnimator.stopAnimation(true)
            self?.tabBar.frame.origin.y = UIScreen.current.bounds.height - 96
        }, delayFactor: delayFactor)
        showTabBarAnimator.startAnimation()
    }
}

//MARK: - UINavigationControllerDelegate

extension OffroadTabBarController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        disableTabBarInteraction()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        enableTabBarInteraction()
    }
    
}
