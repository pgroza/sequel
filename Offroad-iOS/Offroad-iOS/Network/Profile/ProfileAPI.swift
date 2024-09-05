//
//  ProfileAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum ProfileAPI {
    case updateProfile(body: ProfileUpdateRequestDTO)
    case postDeleteAccount(body: DeleteAccountRequestDTO)
}

extension ProfileAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGeneral }
        
    var path: String {
        switch self {
        case .updateProfile:
            return "/users/profiles"
        case .postDeleteAccount:
            return "/users/delete"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateProfile:
            return .patch
        case .postDeleteAccount:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .updateProfile(let profileUpdateRequestDTO):
            return .requestJSONEncodable(profileUpdateRequestDTO)
        case .postDeleteAccount(let deleteAccountRequestDTO):
            return .requestJSONEncodable(deleteAccountRequestDTO)
        }
    }
}


