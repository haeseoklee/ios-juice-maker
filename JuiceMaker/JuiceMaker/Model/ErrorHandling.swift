//
//  ErrorHandling.swift
//  JuiceMaker
//
//  Created by 임지성 on 2021/10/19.
//

import Foundation

enum Errors: LocalizedError {
    case outOfStock
    case invalidValue
    var errorDescription: String? {
        switch self {
        case .outOfStock:
            return "재료가 소진되어 주스를 만들 수 없습니다."
        case .invalidValue:
            return "시스템 에러"
        }
    }
}
