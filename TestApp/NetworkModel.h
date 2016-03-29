//
//  NetworkModel.h
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkModelCallback)(BOOL status, id result);

@interface NetworkModel : NSObject
+(instancetype)shareIntance;
-(void)getDataFromUrl:(NSURL*)url callback:(NetworkModelCallback)callback;
-(void)downloadImage:(NSURL *)url callback:(NetworkModelCallback)callback;
@end
