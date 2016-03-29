//
//  Item+CoreDataProperties.h
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *media;
@property (nullable, nonatomic, retain) NSDate *date_taken;
@property (nullable, nonatomic, retain) NSString *descriptionHTML;
@property (nullable, nonatomic, retain) NSDate *published;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *author_id;
@property (nullable, nonatomic, retain) NSString *tags;

@end

NS_ASSUME_NONNULL_END
