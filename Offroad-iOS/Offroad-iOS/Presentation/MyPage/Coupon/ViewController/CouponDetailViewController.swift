//
//  CouponDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import Kingfisher
import SnapKit

class CouponDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let couponDetailView = CouponDetailView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = couponDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
    init(coupon: AvailableCoupon) {
        super.init(nibName: nil, bundle: nil)
        
        let url = URL(string: coupon.couponImageUrl)
        couponDetailView.couponImageView.kf.setImage(with: url)
        couponDetailView.couponTitleLabel.text = coupon.name
        couponDetailView.couponDescriptionLabel.text = coupon.description
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Func
    
    private func setupTarget() {
        couponDetailView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        couponDetailView.useButton.addTarget(self, action: #selector(didTapUseButton), for: .touchUpInside)
    }
    
    private func setupCloseButton(action: @escaping CouponCodeInputPopupView.CloseButtonAction) {
        couponDetailView.couponUsagePopupView.closeButtonAction = action
    }
    
}

extension CouponDetailViewController {
    
    //MARK: - @objc Method
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func textFieldDidChange() {
        let isTextFieldEmpty = couponDetailView.couponUsagePopupView.couponCodeTextField.text?.isEmpty ?? true
        
        if isTextFieldEmpty {
            couponDetailView.couponUsagePopupView.okButton.changeState(forState: .isDisabled)
        } else {
            couponDetailView.couponUsagePopupView.okButton.changeState(forState: .isEnabled)            }
    }
    
    @objc private func didTapUseButton() {
        let alertController = OFRAlertController(title: "쿠폰 사용", message: "코드를 입력 후 사장님에게 보여주세요", type: .textField)
        let okAction = OFRAlertAction(title: "확인", style: .default) { action in
            print("확인 버튼 눌림")
            return
        }
        alertController.addAction(okAction)
        alertController.showsKeyboardWhenPresented = true
        alertController.configureDefaultTextField { textField in
            textField.placeholder = "매장의 고유 코드를 입력해 주세요"
            textField.keyboardType = .numberPad
        }
        
        present(alertController, animated: true)
    }
    
}

