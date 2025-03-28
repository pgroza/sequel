//
//  UserInfoResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/5/24.
//

import Foundation

struct UserInfoResponseDTO: Codable {
    let message: String
    let data: UserInfoData
}

struct UserInfoData: Codable {
    let nickname: String
    let currentEmblem: String
    let elapsedDay: Int
    let completeQuestCount: Int
    let visitedPlaceCount: Int
    let characterImageUrl: String
}
