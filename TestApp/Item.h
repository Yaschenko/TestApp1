//
//  Item.h
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN
@class Item;
typedef void(^CreateItemsCallback)(NSArray *data);
@interface Item : NSManagedObject

+(Item *)addItemFormDictionary:(NSDictionary *)json inContext:(NSManagedObjectContext*)context;
+(void)addItemsFromArray:(NSArray *)array callback:(CreateItemsCallback)callback;
@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
