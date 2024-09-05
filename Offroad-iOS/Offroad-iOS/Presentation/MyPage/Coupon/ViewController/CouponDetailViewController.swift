//
//  CouponDetailViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import SnapKit

class CouponDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let couponUsagePopupView = CouponUsagePopupView().then {
        $0.isHidden = true
    }
    
    private let couponDetailView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.home(.homeContents2).cgColor
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.main(.main1)
    }
    
    private let couponImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private let couponTitleLabel = UILabel().then {
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.font = UIFont.offroad(style: .iosTextBold)
        $0.numberOfLines = 0
    }
    
    private let dottedLineView = UIView().then {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.home(.homeContents2).cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineDashPattern = [3, 3]
        
        let viewWidth = UIScreen.main.bounds.width
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: viewWidth-50, y: 0)])
        shapeLayer.path = path
        
        $0.layer.addSublayer(shapeLayer)
    }
    
    private let couponDescriptionLabel = UILabel().then {
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.font = UIFont.offroad(style: .iosTextRegular)
        $0.numberOfLines = 3
    }
    
    private let usageTitleLabel = UILabel().then {
        $0.text = "사용방법"
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosHint)
    }
    
    private let usageLogoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgKey)
    }
    
    private let usageDescriptionLabel = UILabel().then {
        $0.text = "매장에 게시되어 있거나 매장 직원에게 전달받은\n고유 코드를 입력한 후 제시해 사용해 주세요."
        $0.textColor = UIColor.grayscale(.gray400)
        $0.font = UIFont.offroad(style: .iosBoxMedi)
        $0.numberOfLines = 2
        $0.setLineSpacing(spacing: 5)
    }
    
    private let useButton = UIButton().then {
        $0.setTitle("사용하기", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosTextRegular)
        $0.backgroundColor = UIColor.main(.main2)
        $0.layer.cornerRadius = 5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    // MARK: - Initializer
    
    init(image: UIImage?, title: String, description: String) {
        super.init(nibName: nil, bundle: nil)
        self.couponImageView.image = image
        self.couponTitleLabel.text = title
        self.couponDescriptionLabel.text = description
        self.couponDescriptionLabel.setLineSpacing(spacing: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupTarget()
    }
    
    //MARK: - Private Func
    
    private func setupView() {
        view.backgroundColor = UIColor.primary(.listBg)
        view.addSubviews(
            couponUsagePopupView,
            couponDetailView,
            usageTitleLabel,
            usageLogoImageView,
            usageDescriptionLabel,
            useButton
        )
        couponDetailView.addSubviews(
            couponImageView,
            couponTitleLabel,
            dottedLineView,
            couponDescriptionLabel
        )
    }
    
    private func setupLayout() {
        couponUsagePopupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        couponDetailView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(125)
            make.horizontalEdges.equalToSuperview().inset(40)
        }
        
        couponImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.horizontalEdges.equalToSuperview().inset(21.5)
            make.centerX.equalToSuperview()
        }
        
        couponTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(couponImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        dottedLineView.snp.makeConstraints { make in
            make.top.equalTo(couponTitleLabel.snp.bottom).offset(14)
            make.height.equalTo(0.5)
            make.horizontalEdges.equalToSuperview().inset(21.5)
        }
        
        couponDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dottedLineView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        usageTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(couponDetailView.snp.bottom).offset(24.5)
            make.leading.equalToSuperview().inset(51.36)
        }
        
        usageLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(usageTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(usageTitleLabel)
        }
        
        usageDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(usageLogoImageView)
            make.leading.equalTo(usageLogoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(51.36)
        }
        
        useButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
    
    private func setupTarget() {
        useButton.addTarget(self, action: #selector(didTapUseButton), for: .touchUpInside)
        
        couponUsagePopupView.setupCloseButton { [weak self] in
            self?.dismissCouponUsagePopupView()
        }
    }
    
    @objc private func didTapUseButton() {
        presentCouponUsagePopupView()
    }
    
    private func presentCouponUsagePopupView() {
        couponUsagePopupView.isHidden = false
        couponUsagePopupView.layer.zPosition = 999
        couponUsagePopupView.presentPopupView()
    }
    
    private func dismissCouponUsagePopupView() {
        couponUsagePopupView.dismissPopupView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.couponUsagePopupView.isHidden = true
        }
    }
}

