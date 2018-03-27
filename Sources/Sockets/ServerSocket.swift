//
//  ServerSocket.swift
//  SocketsPackageDescription
//
//  Created by Carlos Duclos on 3/26/18.
//

import Foundation

struct ServerSocket {
    
    init(port: String) throws {
        let addressInfo = try AddressInfo(port: port)
        let socket = try Socket(addressInfo: addressInfo)
    }
    
}
