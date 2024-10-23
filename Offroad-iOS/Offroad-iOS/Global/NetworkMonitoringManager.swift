//
//  NetworkMonitor.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/23/24.
//

import Foundation

import Network
import RxSwift

final class NetworkMonitoringManager {
    
    //MARK: static Properties
    
    static let shared = NetworkMonitoringManager()
    
    //MARK: - Properties
    
    let networkMonitor = NWPathMonitor()
    var isNetworkConnectionChanged = PublishSubject<Bool>()
    
    //MARK: - Life Cycle
    
    private init() {
        networkMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if path.usesInterfaceType(.wifi) || path.usesInterfaceType(.cellular) || path.usesInterfaceType(.wiredEthernet) {
                    self.isNetworkConnectionChanged.onNext(true)
                } else {
                    self.isNetworkConnectionChanged.onNext(false)
                }
            } else {
                self.isNetworkConnectionChanged.onNext(false)
            }
        }
        networkMonitor.start(queue: DispatchQueue.global())
    }
    
    
    
}
