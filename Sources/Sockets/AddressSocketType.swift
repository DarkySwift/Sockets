//
//  AddressSocketType.swift
//  SocketsPackageDescription
//
//  Created by Carlos Duclos on 3/25/18.
//

import Foundation

public struct AddressSocketType {
    
    public var socket: Socket
    public var address: SocketAddress
    
    public init(addrInfo: addrinfo) throws {
        let socket = try Socket(addrInfo: addrInfo)
        let address = SocketAddress(addrInfo: addrInfo)
        self.init(socket: socket, address: address)
    }
    
    public init(addressInfo: AddressInfo) throws {
        let socket = try Socket(addrInfo: addressInfo.firstAddrInfo)
        let address = SocketAddress(addrInfo: addressInfo.firstAddrInfo)
        self.init(socket: socket, address: address)
    }
    
    public init(socket: Socket, address: SocketAddress) {
        self.socket = socket
        self.address = address
    }
    
}
