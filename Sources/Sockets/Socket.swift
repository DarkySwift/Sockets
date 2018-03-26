//
//  Socket.swift
//  SocketsPackageDescription
//
//  Created by Carlos Duclos on 3/25/18.
//

import Darwin
import Foundation

public struct Socket {
    
    typealias Byte = Int8
    
    public let fileDescriptor: Int32
    
    public init(fileDescriptor: Int32) {
        self.fileDescriptor = fileDescriptor
    }
    
    public init(addrInfo: addrinfo) throws {
        let fileDescriptor = socket(addrInfo.ai_family, addrInfo.ai_socktype, addrInfo.ai_protocol)
        guard fileDescriptor != -1 else {
            throw Error.CreateFailed(code: errno)
        }
        
        self.init(fileDescriptor: fileDescriptor)
    }
    
}

extension Socket {
    
    enum Error: Swift.Error, CustomStringConvertible {
        
        case GetAddrInfoFailed(code: errno_t)
        case GetNameInfoFailed(code: errno_t)
        case NoAddressAvailable
        case GetNameInfoInvalidName
        case CreateFailed(code: errno_t)
        
        var description: String {
            switch self {
            case .NoAddressAvailable:
                return "getaddrinfo() returned no address"
            case .GetAddrInfoFailed(let code):
                return "getaddrinfo() failed: " + String(cString: gai_strerror(code))
            case .GetNameInfoFailed(let code):
                return "getnameinfo() failed " + String(cString: gai_strerror(code))
            case .GetNameInfoInvalidName:
                return "getnameinfo() invalid name"
            case .CreateFailed(let code):
                return "socket() failed " + String(cString: gai_strerror(code))
            }
        }
        
        
    }
    
}
