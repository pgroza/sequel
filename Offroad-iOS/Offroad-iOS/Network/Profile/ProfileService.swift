//
//  ProfileService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol ProfileServiceProtocol {
    func updateProfile(body: ProfileUpdateRequestDTO, completion: @escaping (NetworkResult<ProfileUpdateResponseDTO>) -> ())
    func patchMarketingConsent(body: MarketingConsentRequestDTO, completion: @escaping (NetworkResult<MarketingConsentResponseDTO>) -> ())
}

final class ProfileService: BaseService, ProfileServiceProtocol {
    let provider = MoyaProvider<ProfileAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func updateProfile(body: ProfileUpdateRequestDTO, completion: @escaping (NetworkResult<ProfileUpdateResponseDTO>) -> ()) {
        provider.request(.updateProfile(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<ProfileUpdateResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func patchMarketingConsent(body: MarketingConsentRequestDTO, completion: @escaping (NetworkResult<MarketingConsentResponseDTO>) -> ()) {
        
        provider.request(.patchMarketingConsent(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<MarketingConsentResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
