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
+(void)addItemFormDictionary:(NSDictionary *)json callback:(nonnull CreateItemCallback)callback{
    NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate backgroundContext];
    [context performBlock:^{
        Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:context];
        [item setValuesFromDictionary:json];
        [context save:nil];
        callback(item);
    }];
}

@end
