//
//  DataModel.h
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkModel.h"
@interface DataModel : NSObject
-(void)getCashedDataWithCallback:(NetworkModelCallback)callback;
-(void)loadDataFromNetwork:(NetworkModelCallback)callback;
@end
