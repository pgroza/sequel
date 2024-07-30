//
//  LoginViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/8/24.
//

import UIKit

import AuthenticationServices

final class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = LoginView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
}

extension LoginViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.setupKakaoLoginButton(action: kakaoLoginButtonTapped)
        rootView.setupAppleLoginButton(action: appleLoginButtonTapped)
    }
    
    private func kakaoLoginButtonTapped() {
        print("kakaoLoginButtonTapped")
    }
    
    private func appleLoginButtonTapped() {
        print("appleLoginButtonTapped")
        
        AppleAuthManager.shared.appleLogin()
        
        AppleAuthManager.shared.loginSuccess = { user, identifyToken in
            print("login success!")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            
            var userName = user.name ?? ""
            var userEmail = user.email ?? ""
            let userIdentifyToken = identifyToken ?? ""
                        
            if userName != "" {
                if let userDefaultName = KeychainManager.shared.loadUserName() {
                    userName = userDefaultName
                } else {
                    KeychainManager.shared.saveUserName(name: userName)
                }
            } else {
                userName = KeychainManager.shared.loadUserName() ?? ""
            }
            
            if userEmail != "" {
                if let userDefaultEmail = KeychainManager.shared.loadUserEmail() {
                    userEmail = userDefaultEmail
                } else {
                    KeychainManager.shared.saveUserEmail(email: userEmail)
                }
            } else {
                userEmail = KeychainManager.shared.loadUserEmail() ?? ""
            }
            
            self.postTokenForAppleLogin(request: SocialLoginRequestDTO(socialPlatform: "APPLE", name: userName, code: userIdentifyToken))
        }
        
        AppleAuthManager.shared.loginFailure = { error in
            print("login failed - \(error.localizedDescription)")
        }
    }
    
    private func postTokenForAppleLogin(request: SocialLoginRequestDTO) {
        NetworkService.shared.authService.postSocialLogin(body: request) { response in
            switch response {
            case .success(let data):
                let accessToken = data?.data.tokens.accessToken ?? ""
                let refreshToken = data?.data.tokens.refreshToken ?? ""
                
                KeychainManager.shared.saveAccessToken(token: accessToken)
                KeychainManager.shared.saveRefreshToken(token: refreshToken)

                if isAlreadyExist {
                    let offroadTabBarController = OffroadTabBarController()
                    
                    offroadTabBarController.modalTransitionStyle = .crossDissolve
                    offroadTabBarController.modalPresentationStyle = .fullScreen
                    
                    self?.present(offroadTabBarController, animated: true)
                } else {
                    let nicknameViewController = NicknameViewController()
                    let navigationController = UINavigationController(rootViewController: nicknameViewController)
                    
                    navigationController.modalTransitionStyle = .crossDissolve
                    navigationController.modalPresentationStyle = .fullScreen
                    
                    self?.present(navigationController, animated: true)
                }
            default:
                break
            }
        }
    }
}
