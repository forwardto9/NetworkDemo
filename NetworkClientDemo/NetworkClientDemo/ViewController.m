//
//  ViewController.m
//  NetworkClientDemo
//
//  Created by uwei on 9/14/16.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netinet/in.h>
#import <Foundation/Foundation.h>

@interface ViewController () {
    CFSocketRef _socket;
    BOOL isOnline;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _socket = CFSocketCreate(kCFAllocatorDefault, AF_INET, SOCK_STREAM, IPPROTO_TCP, 0, nil, NULL);
    if (_socket) {
        struct sockaddr_in serveraddr;
        memset(&serveraddr, 0, sizeof(serveraddr));
        serveraddr.sin_len    = sizeof(serveraddr);
        serveraddr.sin_family = AF_INET;
        serveraddr.sin_addr.s_addr = inet_addr("");
        serveraddr.sin_port        = htons(33333);
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&serveraddr, sizeof(serveraddr));
        CFSocketError result = CFSocketConnectToAddress(_socket, address, 1);
        if (result == kCFSocketSuccess) {
            isOnline = YES;
            [NSThread detachNewThreadSelector:@selector(readStream) toTarget:self withObject:nil];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendDataToServer:(id)sender {
    if (isOnline) {
        NSString *clientString = @"It's a message from client!";
        const char *sendData   = [clientString UTF8String];
        send(CFSocketGetNative(_socket), sendData, strlen(sendData) + 1, 0);
    } else {
        NSLog(@"Not connect to server!");
    }
}

- (void)readStream {
    char buf[1024];
    ssize_t hasReadLength = 0;
    while ((hasReadLength = recv(CFSocketGetNative(_socket), buf, sizeof(buf), 0))) {
        NSLog(@"receive data : %@", [NSString stringWithCString:buf encoding:NSUTF8StringEncoding]);
    }
}

@end
