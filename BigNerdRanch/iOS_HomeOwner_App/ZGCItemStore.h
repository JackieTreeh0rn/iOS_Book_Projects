//
//  ZGCItemStore.h
//  iOS_HomeOwner_App
//
//  Created by EvilKernel on 3/20/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

/* This is going to be a Singleton class - meaning, there will only be one instance
 of this type in the application; if you try to create another instance, the class
 will quietly return the existing instance instead. SIngletons are useful when
 you have an object that many objects will talk to.
 
 ZGCItemStore will be like having an NSMutableArray to store instances of
 ZGCItem, but abstracted. Eventually this ItemSTore will take care of saving/loading
 items as well as reordering, adding, and removing items in its array */

#import <Foundation/Foundation.h>
@class ZGCItem; // no need to know all the details for this [declarations] file, just that it exists. allows you to use 'ZGCItem' in declarations basically.


@interface ZGCItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems; // return only array for populating tableview


/* To get a single instance of this class we send it the sharedStore message 
 via this Class method we are declaring */
+ (instancetype)sharedStore;

- (ZGCItem *)createItem; // datasource calls this to create item
- (void)removeItem:(ZGCItem *)item; // datasource calls this to remove item
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex; // datasource calls to move items order



@end
