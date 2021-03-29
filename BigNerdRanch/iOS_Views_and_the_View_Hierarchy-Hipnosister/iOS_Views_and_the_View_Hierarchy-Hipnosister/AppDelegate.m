//
//  AppDelegate.m
//  iOS_Views_and_the_View_Hierarchy-Hipnosister
//
//  Created by EvilKernel on 2/22/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "AppDelegate.h"
#import "ZGCHypnosisView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /* Creating Frame for ZGCHypnosis view
    __unused CGRect firstFrame = CGRectMake(160, 240, 100, 150); //not using now
    // Create instance of ZGCHypnosisview
    ZGCHypnosisView *firstView = [[ZGCHypnosisView alloc] initWithFrame:self.window.bounds]; //using window bounds as frame (full size frame)
    // Set backgroundcolor for the view
    // firstView.backgroundColor = [UIColor redColor];
    // finally, add the view as a subview of the window to make it part of the hierarchy
    [self.window addSubview:firstView]; */
    
    /* Creating a Frame for ZGCHypnosis view 2
    CGRect secondFrame = CGRectMake(20, 30, 50, 50);
    // Create a second instance of the view
    ZGCHypnosisView *secondView = [[ZGCHypnosisView alloc] initWithFrame:secondFrame];
    // set background color
    secondView.backgroundColor = [UIColor blueColor];
    // add as subview to first view (to illustrate how view's frame is relateive to superview
    [firstView addSubview:secondView]; */
    
    // Create CGRects for frames
    CGRect screenRect = self.window.bounds;
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    // bigRect.size.height *= 2.0; // making bigRect twice as wide, but same height (for the two side-by-side subviews)
    
    // Create a screen-sized scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    scrollView.pagingEnabled = YES; // you can turn this on/off to disable paging (you can't stop between views while scrolling)
    // Add it to the window
    [self.window addSubview:scrollView];
    
    // Create first hypnosis view
    ZGCHypnosisView *hypnosisView1 = [[ZGCHypnosisView alloc] initWithFrame:screenRect];
    // Add it to the scroll view
    [scrollView addSubview:hypnosisView1];
    
    // Create second hypnosis view / add it to the scroll view just off to the right of first view
    screenRect.origin.x += screenRect.size.width; // x origin + width
    ZGCHypnosisView *hypnosisView2 = [[ZGCHypnosisView alloc] initWithFrame:screenRect];
    [scrollView addSubview:hypnosisView2];
    
    // Tell the scroll view how big its content area is
    scrollView.contentSize = bigRect.size; // size of the viewing port. typically set to the size of the UIScrollView subview size
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
