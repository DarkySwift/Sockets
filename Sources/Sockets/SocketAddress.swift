//
//  SocketAddress.swift
//  SocketsPackageDescription
//
//  Created by Carlos Duclos on 3/25/18.
//

import Foundation

public enum SocketAddress {
    
    case none
    case version4(address: sockaddr_in)
    case version6(address: sockaddr_in6)
    
    static var lengthOfVersion4: socklen_t {
        return socklen_t(MemoryLayout<sockaddr_in>.size)
    }
    
    static var lengthOfVersion6: socklen_t {
        return socklen_t(MemoryLayout<sockaddr_in6>.size)
    }
    
    init(addrInfo: addrinfo) {
        var info = addrInfo
        var me: SocketAddress = .none
        
        switch addrInfo.ai_family {
            
        case AF_INET:
            withUnsafePointer(to: &info, { (pointer) -> Void in
                pointer.withMemoryRebound(to: sockaddr_in.self, capacity: 1) {
                    me = .version4(address: $0.pointee)
                }
            })
            
        case AF_INET6:
            withUnsafePointer(to: &info, { (pointer) -> Void in
                pointer.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) {
                    me = .version6(address: $0.pointee)
                }
            })
            
        default:
            fatalError("Unknown address size")
        }
        
        self = me
    }
    
    /// Creates an instance for a given IPv4 socket address.
    init(address: sockaddr_in) {
        self = .version4(address: address)
    }
    
    /// Creates an instance for a given IPv6 socket address.
    init(address: sockaddr_in6) {
        self = .version6(address: address)
    }
    
    public func nameInfo() throws -> (host: String, port: String) {
        var hostBuffer = [CChar](repeating:0, count:256)
        var portBuffer = [CChar](repeating:0, count:256)
        var result: Int32 = -1
        
        switch self {
        case .version4(let address):
            
            var addr = address
            result = withUnsafePointer(to: &addr, { (pointer) -> Int32 in
                pointer.withMemoryRebound(to: sockaddr.self, capacity: 1, { (ptr) -> Int32 in
                    
                    return getnameinfo(ptr, socklen_t(MemoryLayout<sockaddr_in>.size), &hostBuffer, socklen_t(hostBuffer.count), &portBuffer, socklen_t(portBuffer.count), 0)
                })
            })
            
            break
        case .version6(let address):
            break
        case .none:
            break
        }
        
        guard result != -1 else {
            throw Socket.Error.GetNameInfoFailed(code: errno)
        }
        
        let host = String(cString: hostBuffer)
        let port = String(cString: portBuffer)
        
        guard host.count > 0 else {
            throw Socket.Error.GetNameInfoInvalidName
        }
        
        guard port.count > 0 else {
            throw Socket.Error.GetNameInfoInvalidName
        }
        
        return (host, port)
    }
    
}
