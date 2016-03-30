//
//  DataModel.m
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import "DataModel.h"
#import "AppDelegate.h"
#import "NetworkModel.h"
#import "Item.h"

NSString * const kContentUrl = @"http://api.flickr.com/services/feeds/photos_public.gne?tags=soccer&format=json&nojsoncallback=1";

@implementation DataModel
-(void)getCashedDataWithCallback:(NetworkModelCallback)callback {
    __weak NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate backgroundContext];
    [context performBlock:^{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        request.fetchLimit = 20;
        NSArray *array = [context executeFetchRequest:request error:nil];
        __weak NSManagedObjectContext *mainContext = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
        if (!array || array.count == 0) {
            callback(NO, nil);
            return ;
        }
        [mainContext performBlock:^{
            NSMutableArray *result = [NSMutableArray new];
            for (NSManagedObject *obj in array) {
                [result addObject:[mainContext objectWithID:obj.objectID]];
            }
            callback(YES, result);
        }];
    }];
}
-(void)parseData:(NSData*)data callback:(NetworkModelCallback)callback {
    NSError *error = nil;
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"\\'" withString:@""];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    if (error && !json) {
        callback(NO, error);
        return;
    }
    
    
    NSArray *array = [json valueForKey:@"items"];
    if (!array || (array.count == 0)) {
        callback(NO, nil);
        return ;
    }
    
    [Item addItemsFromArray:array callback:^(NSArray * _Nonnull dataR) {
        callback(YES, dataR);
    }];
}
-(void)loadDataFromNetwork:(NetworkModelCallback)callback {
    __weak DataModel *weakSelf = self;
    [[NetworkModel shareIntance] getDataFromUrl:[NSURL URLWithString:kContentUrl] callback:^(BOOL status, id result) {
        if (!status) {
            callback(status, result);
        } else {
            [weakSelf parseData:result callback:callback];
        }
    }];
}
@end
