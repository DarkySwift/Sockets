//
//  ClientSocket.swift
//  SocketsPackageDescription
//
//  Created by Carlos Duclos on 3/25/18.
//

import Foundation

public struct ServerSocket {
    
    public var addressSocketType: AddressSocketType
    
    public init(port: String) throws {
        let addressInfo = try AddressInfo(port: port)
        self.addressSocketType = try AddressSocketType.init(addressInfo: addressInfo)
    }
    
}

