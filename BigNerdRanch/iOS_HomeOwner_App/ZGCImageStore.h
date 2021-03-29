//
//  ZGCImageStore.h
//  iOS_HomeOwner_App
//
//  Created by EvilKernel on 5/13/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZGCImageStore : NSObject

// This will be a Singleton class, just like ZGCItemStore
+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;


@end
