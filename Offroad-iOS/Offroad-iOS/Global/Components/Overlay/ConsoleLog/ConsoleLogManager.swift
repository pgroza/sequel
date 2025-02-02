//
//  ConsoleLogManager.swift
//  ORB(Dev)
//
//  Created by 김민성 on 1/31/25.
//

import Foundation

class ConsoleLogManager {
    
    //MARK: Type Properties
    
    static let shared = ConsoleLogManager()
    
    //MARK: - Properties
    
    let consoleLogWindow = ConsoleLogWindow()
    
    //MARK: - Life Cycle
    
    private init() { }
    
}

extension ConsoleLogManager {
    
    //MARK: - Func
    
    func printLog(_ log: String) {
        DispatchQueue.main.async { [weak self] in
            guard let consoleLogViewController = self?.consoleLogWindow.rootViewController as? ConsoleLogViewController else { return }
            consoleLogViewController.printLog(log)
        }
    }
    
}
