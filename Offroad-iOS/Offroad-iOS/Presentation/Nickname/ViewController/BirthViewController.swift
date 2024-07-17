//
//  BirthViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import SnapKit
import Then

final class BirthViewController: UIViewController {
    
    //MARK: - Properties
    
    private let birthView = BirthView()
    private var nickname: String = ""
    
    //MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(nickname: String) {
        self.init(nibName: nil, bundle: nil)
        
        self.nickname = nickname
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = birthView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupAddTarget()
        
        self.hideKeyboardWhenTappedAround() 
    }
    
    //MARK: - Private Method
    
    private func setupAddTarget() {
        birthView.yearTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        birthView.monthTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        birthView.dayTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidBegin)
        
        birthView.yearTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        birthView.monthTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        birthView.dayTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        birthView.nextButton.addTarget(self, action: #selector(buttonToGenderVC), for: .touchUpInside)
    }
}

extension BirthViewController {
    
    //MARK: - @objc Method
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        if sender == birthView.yearTextField {
            birthView.yearTextField.layer.borderColor = UIColor.sub(.sub).cgColor
            birthView.monthTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            birthView.dayTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        } else if sender == birthView.monthTextField {
            birthView.yearTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            birthView.monthTextField.layer.borderColor = UIColor.sub(.sub).cgColor
            birthView.dayTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        } else if sender == birthView.dayTextField {
            birthView.yearTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            birthView.monthTextField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            birthView.dayTextField.layer.borderColor = UIColor.sub(.sub).cgColor
        }
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        let maxLength: Int
        if textField == birthView.yearTextField {
            maxLength = 4
        } else {
            maxLength = 2
        }
        if let text = textField.text, text.count > maxLength {
            textField.text = String(text.prefix(maxLength))
        }
    }
    
    @objc func buttonToGenderVC(sender: UIButton) {
        let nextVC = GenderViewController(nickname: nickname, birthYear: birthView.yearTextField.text ?? "", birthMonth: birthView.monthTextField.text ?? "", birthDay: birthView.dayTextField.text ?? "")
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 텍스트 필드 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    private func setupTarget() {
        birthView.yearTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        birthView.monthTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        birthView.dayTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        birthView.nextButton.addTarget(self, action: #selector(buttonToGenderVC), for: .touchUpInside)
    }
}

//MARK: - UITextFieldDelegate

extension BirthViewController: UITextFieldDelegate {
    
    func setupDelegate() {
        birthView.yearTextField.delegate = self
        birthView.monthTextField.delegate = self
        birthView.dayTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
