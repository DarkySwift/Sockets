//
//  main.swift
//  Server
//
//  Created by Carlos Duclos on 3/25/18.
//

import Foundation
import Sockets

do {
    let socket = try ServerSocket(port: "1234")
    print("filedescriptor", socket.addressSocketType.socket.fileDescriptor)
    
    let (host, port) = try socket.addressSocketType.address.nameInfo()
    print("host", host)
    print("port", port)
}


