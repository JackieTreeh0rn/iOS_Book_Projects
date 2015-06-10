//
//  ZGCLine.h
//  ZGCTouchTracker
//
//  Created by EviLKerneL on 5/31/15.
//  Copyright (c) 2015 EviLKerneL. All rights reserved.
//

// #import <Foundation/Foundation.h>
 #import <UIKit/UIKit.h>

#pragma mark - Constants
typedef NS_ENUM(char, lineType) {
    arc,
    straight
};


#pragma mark - properties
@interface ZGCLine : NSObject <NSCoding>
@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property (nonatomic) lineType lineType; // draw line or circle



@end
