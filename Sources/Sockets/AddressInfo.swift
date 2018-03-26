//
//  AddressInfo.swift
//  SocketsPackageDescription
//
//  Created by Carlos Duclos on 3/25/18.
//

import Foundation
import Darwin

public struct AddressInfo {
    
    var pointer: UnsafeMutablePointer<addrinfo>?
    
    var firstAddrInfo: addrinfo {
        return pointer!.pointee
    }
    
    init(port: String?) throws {
        try self.init(host: nil, port: port)
    }
    
    init(host: String?, port: String?, family: Int32 = AF_UNSPEC, socketType: Int32 = SOCK_STREAM, flags: Int32 = AI_PASSIVE) throws {
        var hints = addrinfo()
        hints.ai_family = family;
        hints.ai_socktype = socketType;
        hints.ai_flags = flags;
        
        try self.init(host: host, port: port, hints: &hints)
    }
    
    init(host: String?, port: String?, hints: UnsafePointer<addrinfo>) throws {
        var addressInfoPointer: UnsafeMutablePointer<addrinfo>? = nil
        let result = getaddrinfo(host, port, hints, &addressInfoPointer)
        
        guard result != -1 else { throw Socket.Error.GetAddrInfoFailed(code: result) }
        guard addressInfoPointer != nil else { throw Socket.Error.NoAddressAvailable }
        pointer = addressInfoPointer
    }
    
    func withFirstAddrInfo<R>(first: (addrinfo) throws -> R) rethrows -> R {
        return try first(pointer!.pointee)
    }
    
}
