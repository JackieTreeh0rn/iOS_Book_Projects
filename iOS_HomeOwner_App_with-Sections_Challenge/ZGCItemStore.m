//
//  ZGCItemStore.m
//  iOS_HomeOwner_App
//
//  Created by EvilKernel on 3/20/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCItemStore.h"
#import "ZGCItem.h" //import is required here (not @class)

@interface ZGCItemStore ()
@property (nonatomic) NSMutableArray *privateItems; // mutability hidden via extension

@end

@implementation ZGCItemStore

+ (instancetype)sharedStore {
    // Declaring this variable as static - static variable is not destroyed when method is done executing, It is not kept on the stack (just as a global variables)
    static ZGCItemStore *sharedStore = nil;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

/* If a programmer calls [[ZGCItemStore alloc] init], let him know 
 the error of his ways */
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"User +[ZGCItemStore sharedStore]" userInfo:nil];
    return nil;
}

/* Here is the real (secret) initiliazer */
- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}

/* Overriding getter for allItems to return privateItems (mutable version) as NSarray */
- (NSArray *)allItems {
    return self.privateItems;  // returninig NSArray type (true way: [self.privateItems copy]
}

- (ZGCItem *)createItem {
    ZGCItem *item = [ZGCItem randomItem];
    [self.privateItems addObject:item];
    
    return item;
}

@end
