//
//  main.m
//  NetworkClientDemo
//
//  Created by uwei on 9/14/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        int err;
        int fd = socket(AF_INET, SOCK_STREAM, 0);
        BOOL success = (fd != -1);
        struct sockaddr_in addr;
        if (success) {
            NSLog(@"socket success!");
            struct sockaddr_in serveraddr;
            memset(&serveraddr, 0, sizeof(serveraddr));
            serveraddr.sin_len = sizeof(serveraddr);
            serveraddr.sin_family = AF_INET;
            serveraddr.sin_port   = htons(17777);
            serveraddr.sin_addr.s_addr = inet_addr("127.0.0.1");
            socklen_t addrLen;
            addrLen = sizeof(serveraddr);
            NSLog(@"connecting......");
            err = connect(fd, (const struct sockaddr *)&serveraddr, addrLen);
            success = (err == 0);
            if (success) {
                err = getsockname(fd, (struct sockaddr *)&addr, &addrLen);
                success = (err == 0);
                if (success) {
                    NSLog(@"connect success, local address:%s, port:%d", inet_ntoa(addr.sin_addr), ntohs(addr.sin_port));
                    while (1) {
                        send(fd, "This is a message from iPhone", 1024, 0);
                    }
                } else {
                    NSLog(@"connect failed!");
                }
            }
        }
        
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
