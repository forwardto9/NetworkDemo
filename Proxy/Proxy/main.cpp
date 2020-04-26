//
//  main.cpp
//  Proxy
//
//  Created by uwei on 2018/11/15.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#include <iostream>
#include "Proxy.h"
int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    CProxy proxy = CProxy(0, "http://txp-01.tencent.com", 8080, "uweiyuan", "apple)ID9");
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    ProxyStatus status = proxy.ConnectProxyServer(sock);
    std::cout << "status : " << status <<std::endl;
    
    
    return 0;
}
