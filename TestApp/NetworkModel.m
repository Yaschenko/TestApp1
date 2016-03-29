//
//  NetworkModel.m
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import "NetworkModel.h"
@interface NetworkModel ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *tasks;
@end
@implementation NetworkModel
static NetworkModel *instance = nil;

+(instancetype)shareIntance {
    @synchronized(self) {
        instance = [[self alloc] init];
    }
    return instance;
}
-(instancetype)init {
    if (self = [super init]) {
        self.session = [NSURLSession sharedSession];
        self.tasks = [NSMutableDictionary new];
    }
    return self;
}
-(NSArray *)parseData:(NSData*)data {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error && !json) return nil;
    
    NSMutableArray *result = [NSMutableArray new];
    
    return nil;
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
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            callback(NO, error);
            return;
        } else if ([NSJSONSerialization isValidJSONObject:data]) {
            callback(YES,[self parseData:data]);
        } else {
            callback(NO, [NSError errorWithDomain:@"LocalError" code:901 userInfo:nil]);
        }
    }];
    [self.tasks setValue:task forKey:url.absoluteString];
    [task resume];
}
@end
