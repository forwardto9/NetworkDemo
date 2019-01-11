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
#define kBufferSize 1024

// @link [Networking Overview](https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/Introduction/Introduction.html#//apple_ref/doc/uid/TP40010220-CH12-BBCFIHFH)

@interface ViewController ()<NSStreamDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate/*this protocol for authencation*/, NSURLSessionDataDelegate> {
    CFSocketRef _socket;
    BOOL isOnline;
    NSMutableData *_receivedData;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createConnectionByUsingCFScoket];
    [self createConnectionByUsingCFNetwork];
    [self createConnectionByUsingNSStream];
    [self createConnectionByUsingNSURLConnection];
    [self createConnectionByUsingNSURLSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLSession
- (void)createConnectionByUsingNSURLSession {
    NSURL *urlWithParams = [NSURL URLWithString:@"http://192.168.10.10:12345/login.php?param1=value1&param2=value2"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    // method 1
    [[session dataTaskWithURL:urlWithParams completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if (error) {
            if (error.code == noErr) {
                //
            } else {
                NSString *errorMessage = [NSString stringWithFormat:@"Failed while reading stream, error :%@, code :(%ld)", error.localizedDescription, error.code];
                [self networFailedWihError:errorMessage];
            }
        } else {
            // if json formate, using NSJSONSerialization to decode data
            NSLog(@"Response data:%@", data);
        }
    }] resume];
    
    // method 2
    NSURLRequest *request = [NSURLRequest requestWithURL:urlWithParams cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if (error) {
            if (error.code == noErr) {
                //
            } else {
                NSString *errorMessage = [NSString stringWithFormat:@"Failed while reading stream, error :%@, code :(%ld)", error.localizedDescription, error.code];
                [self networFailedWihError:errorMessage];
            }
        } else {
            // if json formate, using NSJSONSerialization to decode data
            NSLog(@"Response data:%@", data);
        }
    }] resume];
    
    // method 3
    NSURL *urlWithoutParams = [NSURL URLWithString:@"http://192.168.10.10:23328/login.php"];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:urlWithoutParams cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0];
    mutableRequest.HTTPMethod = @"POST";
    mutableRequest.HTTPBody   = [@"param1=value1&param2=value2" dataUsingEncoding:NSUTF8StringEncoding];
    [[session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if (error) {
            if (error.code == noErr) {
                //
            } else {
                NSString *errorMessage = [NSString stringWithFormat:@"Failed while reading stream, error :%@, code :(%ld)", error.localizedDescription, error.code];
                [self networFailedWihError:errorMessage];
            }
        } else {
            // if json formate, using NSJSONSerialization to decode data
            NSLog(@"Response data:%@", data);
        }
    }] resume];
    
    // method 4
    NSURLSession *delegateSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    [[delegateSession dataTaskWithURL:urlWithParams] resume];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"[NSURLSession] get response!");
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"[NSURLSession] getting data from server!");
    if (!_receivedData) {
        _receivedData = [NSMutableData new];
    }
    [_receivedData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [task cancel];
    
    if (error && error.code != noErr) {
        NSString *errorMessage = [NSString stringWithFormat:@"Failed while reading stream, error :%@, code :(%ld)", error.localizedDescription, error.code];
        [self networFailedWihError:errorMessage];
        [session invalidateAndCancel];
    } else {
        [session finishTasksAndInvalidate];
        NSLog(@"[NSURLSession] finished!");
    }
}

#pragma mark - NSURLConnection Deprecated iOS 9.0
- (void)createConnectionByUsingNSURLConnection {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%d", @"127.0.0.1", 18888]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0];
    request.HTTPMethod = @"post";
    [request setValue:@"json/xml" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [@"param1=value1&param2=value2" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Sync
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Failed while reading stream, error :%@, code :(%ld)", error.localizedDescription, error.code];
        [self networFailedWihError:errorMessage];
    } else {
        // if json formate, using NSJSONSerialization to decode data
        NSLog(@"Response data:%@", data);
    }
    
    // Async
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //
        if (connectionError) {
            if (connectionError.code == noErr) {
                //
            } else {
                NSString *errorMessage = [NSString stringWithFormat:@"Failed while reading stream, error :%@, code :(%ld)", connectionError.localizedDescription, connectionError.code];
                [self networFailedWihError:errorMessage];
            }
        } else {
            // if json formate, using NSJSONSerialization to decode data
            NSLog(@"Response data:%@", data);
        }
    }];
    
    // delegate
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [connection start];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"[NSURLConnection] get response!");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_receivedData) {
        _receivedData = [NSMutableData new];
    }
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection cancel];
    NSLog(@"Get whole data and check");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection cancel];
    NSString *errorMessage = [NSString stringWithFormat:@"Failed while reading stream, error :%@, code :(%ld)", error.localizedDescription, error.code];
    [self networFailedWihError:errorMessage];
}

#pragma mark - NSStream
- (void)createConnectionByUsingNSStream {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%d", @"127.0.0.1", 18888]];
    NSThread *backgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadDataUsingNSStreamFromURL:) object:url];
    [backgroundThread start];
}

- (void)loadDataUsingNSStreamFromURL:(NSURL *)url {
    NSInputStream *readStream = nil;
     [NSStream getStreamsToHostWithName:url.host port:[url.port integerValue] inputStream:&readStream outputStream:nil];
    readStream.delegate = self;
    [readStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [readStream open];
    [[NSRunLoop currentRunLoop] run];
}

- (void)cleanupStream:(NSStream *)aStream {
    [aStream close];
    [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    NSLog(@"[NSStram] delegate in thread %@", [NSThread currentThread]);
    switch (eventCode) {
        case NSStreamEventHasBytesAvailable: {
            //
            uint8_t buffer[kBufferSize];
            long numBytesRead = [(NSInputStream *)aStream read:buffer maxLength:kBufferSize];
            if (numBytesRead > 0) {
                [self didReceiveData:[NSData dataWithBytes:buffer length:numBytesRead]];
            } else if (numBytesRead == 0) {
                NSLog(@"End of stream reached!");
            } else {
                NSLog(@"Input stream occurs error!");
            }
            
            break;
        }
        case NSStreamEventErrorOccurred: {
            NSError *error = [aStream streamError];
            NSString *errorMessage = [NSString stringWithFormat:@"Failed while reading stream, error :%@, code :(%ld)", error.localizedDescription, error.code];
            [self cleanupStream:aStream];
            
            [self networFailedWihError:errorMessage];
            break;
        }
            
        case NSStreamEventEndEncountered: {
            [self didFinishedReceiveData];
            [self cleanupStream:aStream];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - CFNetwork
- (void)createConnectionByUsingCFNetwork {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%d", @"127.0.0.1", 18888]];
    NSThread *backgroundThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadDataFromURL:) object:url];
    [backgroundThread start];
}

- (void)loadDataFromURL:(NSURL *)url {
    NSString *host = [url host];
    NSInteger port = [url port].integerValue;
    CFStreamClientContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    // 从回调函数中获取流数据，流完成，以及关于流的错误或者是状态信息
    CFOptionFlags registedEvents = (kCFStreamEventHasBytesAvailable|kCFStreamEventEndEncountered|kCFStreamEventErrorOccurred);
    // create read-only stream socket
    CFReadStreamRef readStream = NULL;
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)host, (UInt32)port, &readStream, NULL);
    // schedule the stream on the runloop to enable callbacks
    if (CFReadStreamSetClient(readStream, registedEvents, clientSocketCallback, &context)) {
        
        CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    } else {
        
        [self networFailedWihError:@"Set network callback failed!"];
        return;
    }
    
    // open stream for reading
    if (CFReadStreamOpen(readStream)) {
        CFErrorRef error = CFReadStreamCopyError(readStream);
        if (error) {
            if (CFErrorGetCode(error) != noErr) {
                NSString *errorInfo = [NSString stringWithFormat:@"Failed while reading stream, error domain:(%@), code:%ld", (__bridge NSString*)CFErrorGetDomain(error), CFErrorGetCode(error)];
                [self networFailedWihError:errorInfo];
            }
            CFRelease(error);
            return;
        }
        
        NSLog(@"Connect URL:%@ success!", url);
        CFRunLoopRun();
        
    } else {
        [self networFailedWihError:@"Open stream failed!"];
        return;
    }
}

void clientSocketCallback(CFReadStreamRef stream, CFStreamEventType event, void *p) {
    ViewController *selfVC = (__bridge ViewController *)p;
    switch (event) {
        case kCFStreamEventHasBytesAvailable: { // read data until no more
            while (CFReadStreamHasBytesAvailable(stream)) {
                UInt8 buffer[kBufferSize];
                int numBytesRead = (int)CFReadStreamRead(stream, buffer, kBufferSize);
                [selfVC didReceiveData:[NSData dataWithBytes:buffer length:numBytesRead]];
            }
            break;
        }
            
        case kCFStreamEventErrorOccurred: {
            
            CFErrorRef error = CFReadStreamCopyError(stream);
            if (error) {
                if (CFErrorGetCode(error) != noErr) {
                    NSString *errorInfo = [NSString stringWithFormat:@"Failed while reading stream, error domain:(%@), code:%ld", (__bridge NSString*)CFErrorGetDomain(error), CFErrorGetCode(error)];
                    [selfVC networFailedWihError:errorInfo];
                    
                }
                CFRelease(error);
            }
            
            // clean up
            cleanupCFNetworkResources(stream);
            
            break;
        }
        case kCFStreamEventEndEncountered: { // finish received data
            [selfVC didFinishedReceiveData];
            // clean up
            cleanupCFNetworkResources(stream);
            break;
        }
            
        default:
            break;
    }
}

void cleanupCFNetworkResources(CFReadStreamRef stream) {
    CFReadStreamClose(stream);
    CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

#pragma mark - Common method for resolving data
- (void)didReceiveData:(NSData *)data {
    if (!_receivedData) {
        _receivedData = [NSMutableData new];
    }
    
    [_receivedData appendData:data];
}

- (void)didFinishedReceiveData {
    NSLog(@"This method can print the result!");
}

- (void)networFailedWihError:(NSString *)errorInfo {
    NSLog(@"%@", errorInfo);
}
#pragma mark - CFSocekt Operation
- (void)createConnectionByUsingCFScoket {
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
    char buf[kBufferSize];
    ssize_t hasReadLength = 0;
    while ((hasReadLength = recv(CFSocketGetNative(_socket), buf, sizeof(buf), 0))) {
        NSLog(@"receive data : %@", [NSString stringWithCString:buf encoding:NSUTF8StringEncoding]);
    }
}

@end
