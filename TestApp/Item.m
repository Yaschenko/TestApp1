//
//  Item.m
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import "Item.h"
#import "AppDelegate.h"

@implementation Item
-(void)setValuesFromDictionary:(NSDictionary *)json {
    self.title = [json valueForKey:@"title"];
    self.link = [json valueForKey:@"link"];
    self.media = [[json valueForKey:@"media"] valueForKey:@"m"];
    self.date_taken = [json valueForKey:@"date_taken"];
    self.descriptionHTML = [json valueForKey:@"description"];
    self.published = [json valueForKey:@"published"];
    self.author = [json valueForKey:@"author"];
    self.author_id = [json valueForKey:@"author_id"];
    self.tags = [json valueForKey:@"tags"];
}
+(Item *)addItemFormDictionary:(NSDictionary *)json inContext:(NSManagedObjectContext*)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    request.predicate = [NSPredicate predicateWithFormat:@"link like %@", [json valueForKey:@"link"]];
    NSArray *array = [context executeFetchRequest:request error:nil];
    for (Item *i in array) {
        [context deleteObject:i];
    }
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
    [item setValuesFromDictionary:json];
    return item;
}
+(void)addItemsFromArray:(NSArray *)array callback:(CreateItemsCallback)callback {
    NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate backgroundContext];
    [context performBlock:^{
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *obj in array) {
            Item *item = [Item addItemFormDictionary:obj inContext:context];
            [arr addObject:item];
        }
        if (![context save:nil]) {
            callback([NSArray new]);
            return ;
        }
        NSManagedObjectContext *mainContext = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
        [mainContext performBlock:^{
            NSMutableArray *result = [NSMutableArray new];
            for (NSManagedObject *obj in arr) {
                [result addObject:[mainContext objectWithID:obj.objectID]];
            }
            
            callback(result);
        }];
    }];
}
@end
