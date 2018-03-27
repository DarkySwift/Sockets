//
//  AddressInfo.swift
//  SocketsPackageDescription
//
//  Created by Carlos Duclos on 3/26/18.
//

import Foundation
import Darwin

struct AddressInfo: RawRepresentable {
    typealias RawValue = UnsafeMutablePointer<addrinfo>?
    
    var rawValue: UnsafeMutablePointer<addrinfo>?
    
    init?(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    init(port: String) throws {
        var hints = addrinfo()
        hints.ai_family = AF_UNSPEC
        hints.ai_socktype = SOCK_STREAM
        hints.ai_flags = AI_PASSIVE
        hints.ai_protocol = 0
        
        var result: UnsafeMutablePointer<addrinfo>? = nil
        
        let addrInfoResult = getaddrinfo(nil, port, &hints, &result)
        if addrInfoResult != 0 {
            throw Socket.Error.GetAddrInfoFailed(addrInfoResult)
        }
        
        rawValue = result!
        
        print("addrInfoResult:", addrInfoResult)
    }
    
}
