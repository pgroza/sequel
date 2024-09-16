//
//  OFRAlertController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

class OFRAlertController: UIViewController {
    
    //MARK: - Properties
    
    let transitionDelegate = ZeroDurationTransitionDelegate()
    let presentationAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.7)
    let dismissalAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    /**
     팝업의 제목
     */
    override var title: String? {
        get { backgroundView.alertView.title }
        set { backgroundView.alertView.title = newValue }
    }
    
    /**
     팝업의 메시지
     */
    var message: String? {
        get { backgroundView.alertView.title }
        set { backgroundView.alertView.title = newValue }
    }
    
    /// 팝업 뷰의 타입
    var type: OFRAlertViewType {
        get { backgroundView.alertView.type }
    }
    
    var actions: [OFRAlertAction] { backgroundView.alertView.actions }
    
    /**
     해당 변수에 해당하는 텍스트필드는 alert가 present되면서 자동으로 `firstResponder`가 되고, 키보드가 같이 올라오게 된다.
     alert controller의 type을 `.textField`로 설정할 경우, 기본 제공되는 텍스트필드가 할당됨.
     type이 `.textFiled`가 아닌 `.custom`이고 별도 text field를 추가한 경우에는 이 변수에 직접 할당해 주어야 함.
     */
    var textFieldToBeFirstResponder: UITextField? = nil
    
    /**
     `textFieldToBeFirstResponder`이 nil이 아닐 경우, 자동으로 키보드가 올라오도록 설정.
     해당 속성을 false로 할당할 경우, `textFieldToBeFirstResponder`가 `nil`이 아닐 경우에도 키보드가 자동으로 올라오지 않음.
     기본값은 `true`.
     */
    var isKeyboardShowWhenPresented: Bool = true
    
    /**
     팝업 우측 상단의 X 버튼(팝업 창 닫는 버튼) 이 보여지도록 할 지 설정
     */
    var showsCloseButton: Bool = false
    
    var keyboardHeight: CGFloat? = nil
    
    //MARK: - UI Properties
    
    let backgroundView = OFRAlertBackgroundView()
    
    //MARK: - Life Cycle
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        setupPresentationStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String? = nil, message: String? = nil, type: OFRAlertViewType) {
        self.init(nibName: nil, bundle: nil)
        
        backgroundView.alertView.title = title
        backgroundView.alertView.message = message
        backgroundView.alertView.type = type
        if type == .textField {
            textFieldToBeFirstResponder = backgroundView.alertView.defaultTextField
        }
    }
    
    override func loadView() {
        view = backgroundView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAlertView()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        hideAlertView {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
}


extension OFRAlertController {
    
    //MARK: - Layout
    
    //MARK: - @objc Func
    
    @objc private func closeButtonDidTapped() {
        dismiss(animated: false)
    }
    
    //MARK: - Private Func
    
    private func setupPresentationStyle() {
        self.transitioningDelegate = transitionDelegate
        self.modalPresentationStyle = .custom
    }
    
    private func setupTargets() {
        backgroundView.alertView.closeButton.addTarget(self, action: #selector(closeButtonDidTapped), for: .touchUpInside)
    }
    
    private func showAlertView() {
        
        backgroundView.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        presentationAnimator.addAnimations { [weak self] in
            self?.backgroundView.backgroundColor = .blackOpacity(.black25)
            self?.backgroundView.alertView.alpha = 1
            self?.backgroundView.alertView.transform = .identity
        }
        presentationAnimator.startAnimation()
    }
    
    private func hideAlertView(completion: (() -> Void)? = nil) {
        
        dismissalAnimator.addAnimations { [weak self] in
            self?.backgroundView.backgroundColor = .clear
            self?.backgroundView.alertView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self?.backgroundView.alertView.alpha = 0
        }
        dismissalAnimator.addCompletion { _ in completion?() }
        dismissalAnimator.startAnimation()
    }
    
    
    //MARK: - Func
    
    func addAction(_ action: OFRAlertAction) {
        backgroundView.alertView.actions.append(action)
        self.backgroundView.layoutIfNeeded()
    }
    
//    func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
//        let textField = UITextField()
//        
//        configurationHandler?(textField)
//    }
    
    /**
     alert controller의 type이 `.textField`인 경우 `defaultTextField`의 속성을 변경하는 함수.
     alert controller의 type이 `.textField`가 아닌 경우, 이 함수는 아무런 동작도 하지 않는다.
     */
    func configureDefaultTextField(_ configure: (UITextField) -> Void) {
        guard self.type == .textField else { return }
        configure(backgroundView.alertView.defaultTextField)
    }
    
}


class OFRAlertAction {
    
    init(title: String?, style: OFRAlertAction.Style, handler: @escaping ((UIAction) -> Void)) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    var title: String?
    var style: OFRAlertAction.Style
    var handler: ((UIAction) -> Void)
    var isEnabled: Bool = true
}

extension OFRAlertAction {
    
    enum Style {
        case `default`
        case cancel
        case destructive
    }
    
}
