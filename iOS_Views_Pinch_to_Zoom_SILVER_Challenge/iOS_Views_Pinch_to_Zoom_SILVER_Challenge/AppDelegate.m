//
//  AppDelegate.m
//  iOS_Views_Pinch_to_Zoom_SILVER_Challenge
//
//  Created by EvilKernel on 3/7/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "AppDelegate.h"
#import "ZGCHipnosisterView.h"

@interface AppDelegate () <UIScrollViewDelegate> // conforms to UIScrollViewDelegate protocol

@property (nonatomic) ZGCHipnosisterView *hypnoView; // a property for this pinch and zoom functionality

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create CGRects for frames
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    bigRect.size.height *= 2.0;
    
    // Create a screen-sized scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    //scrollView.pagingEnabled = NO; // you can turn this on/off to disable paging (you can't stop between views while scrolling)
    
    // Define ZOOM limits and multitouch
    scrollView.maximumZoomScale = 5.0; // max zoom scale - required for zooming
    scrollView.minimumZoomScale = 1.0; // min zoom scale - required for zooming
    scrollView.multipleTouchEnabled = YES; // enable multi fingers for this view

    // scrollView.bouncesZoom = YES;
    
    // Setting delegate for scrollview object in order to implement Pinch-to-Zoom
    scrollView.delegate = self;
    
    // Tell the scroll view how big its content area is
    //scrollView.contentSize = bigRect.size; // size of the viewing port. typically set to the size of the UIScrollView subview size
    
    // Add it to the window
    [self.window addSubview:scrollView];
    
    
    // Create a hypnosis view
    self.hypnoView = [[ZGCHipnosisterView alloc] initWithFrame:screenRect];

    // Add it to the scroll view
    [scrollView addSubview:self.hypnoView];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;

}

#pragma - scrollview delegate method
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews[0];
    
}

#pragma - scrollview delegate method #2
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    [scrollView zoomToRect:view.frame animated:NO];
    NSLog(@"Current Zoom Scale: %f", scrollView.zoomScale);
}

#pragma - scrollview delegate method #3
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"Current Zoom Scale: %f", scale);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
