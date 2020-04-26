//
//  Proxy.h
//  Proxy
//
//  Created by uwei on 2018/11/15.
//  Copyright © 2018 TEG of Tencent. All rights reserved.
//

#ifndef Proxy_h
#define Proxy_h

#include <string>
#include <vector>
#include <sys/time.h>
#include <unistd.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <fcntl.h>

using namespace std;
typedef int SOCKET;
typedef unsigned short  u_short;

enum ProxyStatus
{
    SUCCESS,
    CONNECT_PROXY_FAIL,
    NOT_CONNECT_PROXY,
    CONNECT_SERVER_FAIL
};

class CProxy
{
public:
    CProxy(long type, string ip, u_short port, string username, string password)
    :m_proxyType(type), m_proxyIp(ip), m_proxyPort(port), m_proxyUserName(username), m_proxyUserPwd(password)
    {}
    
    ~CProxy(void){};
    
    ProxyStatus ConnectProxyServer(SOCKET socket);
    ProxyStatus ConnectServer(SOCKET socket, string ip, u_short port);
    
private:
    ProxyStatus ConnectByHttp(SOCKET socket, string ip, u_short port);
    ProxyStatus ConnectBySock4(SOCKET socket, string ip, u_short port);
    ProxyStatus ConnectBySock5(SOCKET socket, string ip, u_short port);
    
    bool Send(SOCKET socket, const char* buf, int len);
    int Receive(SOCKET socket, char* buf, int bufLen);
    
private:
    long m_proxyType;
    string m_proxyIp;
    u_short m_proxyPort;
    string m_proxyUserName;
    string m_proxyUserPwd;
    
    bool m_blnProxyServerOk;
};

struct TSock4req1
{
    char VN;
    char CD;
    unsigned short Port;
    unsigned long IPAddr;
    char other;
};

struct TSock4ans1
{
    char VN;
    char CD;
};

struct TSock5req1
{
    char Ver;
    char nMethods;
    char Methods;
};

struct TSock5ans1
{
    char Ver;
    char Method;
};

struct TSock5req2
{
    char Ver;
    char Cmd;
    char Rsv;
    char Atyp;
    char other;
};

struct TSock5ans2
{
    char Ver;
    char Rep;
    char Rsv;
    char Atyp;
    char other;
};

struct TAuthreq
{
    char Ver;
    char Ulen;
    char Name;
    char PLen;
    char Pass;
};

struct TAuthans
{
    char Ver;
    char Status;
};
#endif /* Proxy_h */
