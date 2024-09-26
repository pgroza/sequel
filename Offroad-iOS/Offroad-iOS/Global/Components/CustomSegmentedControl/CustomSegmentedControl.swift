//
//  CustomSegmentedControl.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

import SnapKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func segmentedControlDidSelected(segmentedControl: CustomSegmentedControl, selectedIndex: Int)
}

final class CustomSegmentedControl: UIView {
    
    //MARK: - Properties
    
    let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    weak var delegate: CustomSegmentedControlDelegate? = nil
    
    private(set) var selectedIndex: Int = 0
    lazy var underbarLeadingConstraint = underbar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    lazy var underbarTrailingConstraint = underbar.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    
    //MARK: - UI Properties
    
    private let stackView: UIStackView
    private let underbar = UIView()
    
    //MARK: - Life Cycle
    
    init(titles: [String]) {
        let buttonsArray = titles.enumerated().map { (index, title) in
            CustomSegmentedControlButton(title: title, tag: index)
        }
        self.stackView = UIStackView(arrangedSubviews: buttonsArray)
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setButtonsTarget()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(titles: [])
    }
    
    override convenience init(frame: CGRect) {
        self.init(titles: [])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUnderbarPosition(to: selectedIndex)
        selectSegment(index: selectedIndex)
    }
    
}

extension CustomSegmentedControl {
    
    //MARK: @objc Func
    
    @objc private func segmentDidSelected(sender: UIButton) {
        selectSegment(index: sender.tag)
    }
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        underbarLeadingConstraint.isActive = true
        underbarTrailingConstraint.isActive = true
        underbar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        stackView.do { stackView in
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 0
        }
        underbar.backgroundColor = .sub(.sub)
    }
    
    private func setupHierarchy() {
        addSubviews(stackView, underbar)
    }
    
    private func setButtonsTarget() {
        stackView.arrangedSubviews.forEach { view in
            guard let button = view as? CustomSegmentedControlButton else { return }
            button.addTarget(self, action: #selector(segmentDidSelected(sender:)), for: .touchUpInside)
        }
    }
    
    private func updateUnderbarPosition(to index: Int) {
        let selectedButton = stackView.arrangedSubviews[index]
        animator.addAnimations { [unowned self] in
            self.underbarLeadingConstraint.constant = selectedButton.frame.origin.x
            self.underbarTrailingConstraint.constant = selectedButton.frame.origin.x + selectedButton.bounds.width
            self.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    private func updateSegmentState(selectedIndex: Int) {
        stackView.arrangedSubviews.forEach { view in
            let button = view as! UIButton
            button.isSelected = (button.tag == selectedIndex)
        }
    }
    
    //MARK: - Func
    
    func selectSegment(index: Int) {
        guard index >= 0 && index < stackView.arrangedSubviews.count else { return }
        selectedIndex = index
        updateSegmentState(selectedIndex: index)
        updateUnderbarPosition(to: index)
        delegate?.segmentedControlDidSelected(segmentedControl: self, selectedIndex: index)
    }
    
    func changeSegmentTitle(at index: Int, to newTitle: String) {
        guard let button = stackView.arrangedSubviews[index] as? CustomSegmentedControlButton else { return }
        button.setTitle(newTitle, for: .normal)
    }
    
}
