//
//  Base64.hpp
//  Proxy
//
//  Created by uwei on 2018/11/15.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#ifndef Base64_hpp
#define Base64_hpp

#include <stdio.h>
#include <string>

using namespace std;

class CBase64
{
private:
    CBase64(void);
public:
    ~CBase64(void);
    
    static string Encode(const unsigned char* Data,int DataByte);
    static string Decode(const char* Data,int DataByte,int& OutByte);
};  
#endif /* Base64_hpp */
