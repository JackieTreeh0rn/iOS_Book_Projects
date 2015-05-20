//
//  ZGCImageStore.m
//  iOS_HomeOwner_App
//
//  Created by EvilKernel on 5/13/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCImageStore.h"


@interface ZGCImageStore ()

// declaring property to hold on to the images
@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end


@implementation ZGCImageStore


#pragma mark - INIT Section

/* Singleton Class */
+ (instancetype)sharedStore {
    static ZGCImageStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}


/* Noone should call init */
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[ZGCImageStore sharedStore]" userInfo:nil];
}


/* Secret Initializer */
- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}



#pragma mark - INSTANCE Methods

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    // [self.dictionary setObject:image forKey:key];
    self.dictionary[key] = image; // switching to shorthand
}


- (UIImage *)imageForKey:(NSString *)key {
    
    // return [self.dictionary objectForKey:key];
    return self.dictionary[key]; // switching to shorthand
    
}


- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}


@end
