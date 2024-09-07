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
    case patchMarketingConsent(body: MarketingConsentRequestDTO)
    case getUserInfo
}

extension ProfileAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGeneral }
    
    var parameter: [String : Any]? {
        switch self {
        case .updateProfile, .getUserInfo:
            return nil
        }
    }
        
    var path: String {
        switch self {
        case .updateProfile:
            return "/users/profiles"
        case .patchMarketingConsent:
            return "/users/agree"
        case .getUserInfo:
            return "/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateProfile, .patchMarketingConsent:
            return .patch
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .updateProfile(let profileUpdateRequestDTO):
            return .requestJSONEncodable(profileUpdateRequestDTO)
        case .patchMarketingConsent(let marketingConsentRequestDTO):
            return .requestJSONEncodable(marketingConsentRequestDTO)
        case .getUserInfo:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        }
    }
}


