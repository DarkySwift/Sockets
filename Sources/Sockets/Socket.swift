//
//  ServerSocket.swift
//  SocketsPackageDescription
//
//  Created by Carlos Duclos on 3/26/18.
//

import Foundation

struct Socket {
    
    init(port: String) throws {
        let addrInfo = try AddressInfo(port: port)
        
    }
    
    init(addressInfo: AddressInfo) {
        guard let addrInfo = addressInfo.rawValue?.pointee else {
            fatalError("addrInfo cannot be nil")
        }
        
        var addr: UnsafeMutablePointer<addrinfo> = addrInfo.ai_next
        repeat {
            let sock = socket(addrInfo.ai_family, addrInfo.ai_socktype, addrInfo.ai_protocol)
            print("sock", sock)
            guard sock != -1 else { continue }
            
            let didBind = bind(sock, addrInfo.ai_addr, addrInfo.ai_addrlen)
            print("didBind", didBind)
            if didBind == 0 { break }
            
            close(sock)
            addr = addrInfo.ai_next
        } while (addr.pointee != nil)
    }
    
}

extension Socket {
    
    enum Error: Swift.Error, CustomStringConvertible {
        case GetAddrInfoFailed(Int32)
        
        var description: String {
            switch self {
            case .GetAddrInfoFailed(let code):
                return "getaddrinfo() failed: " + String.init(cString: gai_strerror(code))
            }
        }
    }
    
}
