//
//  main.m
//  NetworkDemo
//
//  Created by uwei on 9/14/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        int err = 0;
        int fd = socket(AF_INET, SOCK_STREAM, 0);
        BOOL success = (fd != -1);
        if (success) {
            NSLog(@"create socket success!");
            struct sockaddr_in addr;
            memset(&addr, 0, sizeof(addr));
            addr.sin_len = sizeof(addr);
            addr.sin_family = AF_INET; // 协议族
            addr.sin_port   = htons(17777);
            addr.sin_addr.s_addr = htonl(INADDR_ANY);
            
            // 将addr中的服务器套接字地址与套接字描述符联系在一起
            err = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
            success = (err == 0);
        }
        
        if (success) {
            NSLog(@"bind success!");
            err = listen(fd, 1024);
            success = (err == 0);
        }
        
        if (success) {
            NSLog(@"listen success!");
            while (1) {
                struct sockaddr_in clientaddr;
                int peerfd;
                socklen_t addLen;
                addLen = sizeof(clientaddr);
                NSLog(@"Prepare accept");
                // 返回的文件描述符可以用来与客户端通信
                peerfd = accept(fd, (struct sockaddr *)&clientaddr, &addLen);
                success = (peerfd != -1);
                if (success) {
                    NSLog(@"Accept success, remote address:%s, port:%d", inet_ntoa(clientaddr.sin_addr), ntohs(clientaddr.sin_port));
                    char buf[1024];
                    ssize_t count;
                    size_t len = sizeof(buf);
                    do {
                        count = recv(peerfd, buf, len, 0);
                        NSString *str = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                        NSLog(@"received info: %@", str);
                    } while (strcmp(buf, "exit") != 0);
                }
                close(peerfd);
            }
        }
        
        
        
    }
    return 0;
}
