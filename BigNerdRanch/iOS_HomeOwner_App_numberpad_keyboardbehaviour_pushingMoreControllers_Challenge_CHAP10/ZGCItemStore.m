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
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ZGCItemStore sharedStore]" userInfo:nil];
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

- (void)removeItem:(ZGCItem *)item {
    /* not using 'removeObject' method as it uses isEqual: againts each object
     isEqual method can vary per class's implementation (ie. ZGCItem could choose to
     use isEqual to YES if valueInDollars is was the same). The 'removeObjectIdenticalTo:'
     method looks for exact same object (uses object addresses) */
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    // First check
    if (fromIndex == toIndex) {
        return;
    }
    
    // Get pointer to object being movd so you can reinsert it
    ZGCItem *item = self.privateItems[fromIndex];
    
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
    
}

@end
