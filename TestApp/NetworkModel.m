//
//  NetworkModel.m
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import "NetworkModel.h"
#import "Item.h"

@interface NetworkModel ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *tasks;
@property (nonatomic, strong) NSMutableDictionary *imageCashe;
@end
@implementation NetworkModel
+(instancetype)shareIntance {
    static NetworkModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NetworkModel new];
    });
    return instance;
}
-(instancetype)init {
    if (self = [super init]) {
        self.session = [NSURLSession sharedSession];
        self.tasks = [NSMutableDictionary new];
        self.imageCashe = [NSMutableDictionary new];
    }
    return self;
}

-(void)getDataFromUrl:(NSURL*)url callback:(NetworkModelCallback)callback {
    if (!url) {
        callback(NO, [NSError errorWithDomain:@"LocalError" code:900 userInfo:nil]);
        return;
    }
    if ([self.tasks valueForKey:url.absoluteString]) {
        callback(NO, [NSError errorWithDomain:@"LocalError" code:902 userInfo:nil]);
        return;
    }
    __weak NetworkModel *weakSelf = self;
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf.tasks removeObjectForKey:url.absoluteString];
        if (error) {
            callback(NO, error);
            return;
        } else {
            callback(YES, data);
        } 
    }];
    [self.tasks setValue:task forKey:url.absoluteString];
    [task resume];
}
-(void)downloadImage:(NSURL *)url callback:(NetworkModelCallback)callback {
    if (!url) {
        callback(NO, [NSError errorWithDomain:@"LocalError" code:900 userInfo:nil]);
        return;
    }
    if ([self.imageCashe valueForKey:url.absoluteString]) {
        callback(YES, [self.imageCashe valueForKey:url.absoluteString]);
        return;
    }
    if ([self.tasks valueForKey:url.absoluteString]) {
        callback(NO, [NSError errorWithDomain:@"LocalError" code:902 userInfo:nil]);
        return;
    }
    __weak NetworkModel *weakSelf = self;
    NSURLSessionDownloadTask * task = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf.tasks removeObjectForKey:url.absoluteString];
        if (error) {
            callback(NO, error);
            return ;
        }
        NSData *data = [NSData dataWithContentsOfURL:location];
        if (data) {
            NSString *fileName = [NSTemporaryDirectory() stringByAppendingFormat:@"%f.png", [[NSDate new] timeIntervalSince1970]];
            if ([data writeToFile:fileName atomically:YES]) {
                [weakSelf.imageCashe setValue:fileName forKey:url.absoluteString];
                callback(YES, fileName);
                return;
            }
        }
        callback(NO, nil);
    }];
    [task resume];
    [self.tasks setValue:task forKey:url.absoluteString];
}
@end
