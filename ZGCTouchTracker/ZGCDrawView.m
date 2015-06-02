//
//  ZGCDrawView.m
//  ZGCTouchTracker
//
//  Created by EviLKerneL on 5/25/15.
//  Copyright (c) 2015 EviLKerneL. All rights reserved.
//

#import "ZGCDrawView.h"
#import "ZGCLine.h"

@interface ZGCDrawView ()
// @property (nonatomic, strong) ZGCLine *currentLine;  <-- switching to dictionary for multiple touches / lines
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@end

@implementation ZGCDrawView


#pragma mark - view INIT
- (instancetype)initWithFrame:(CGRect)frame { // init override to instantiate variables
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    return self;
}
#


#pragma mark - view Private methods
- (void)strokeLine:(ZGCLine *)line {
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}
#


#pragma mark - view drawRect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing finished lines in black
    [[UIColor blackColor] set];
    for (ZGCLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    
/* switched to multitouch enabled approach *
    // If there is a line currently being drawned, do it in red
    if (self.currentLine) {
        [[UIColor redColor] set];
        [self strokeLine:self.currentLine];
    }
*/
    
}
#


#pragma mark - view touch events methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Enumerate through the  set of touches and...
    // ...instantiate a ZGCLine object per touch (multitouch)
    // ...configure each line w/the location off the touch object
    // ...generate a key value based off of touch object's memory address
    // ...add the lines to the dictionary
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        ZGCLine *line = [[ZGCLine alloc] init];
        line.begin = location;
        line.end = location;
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }

/* switched to multitouch enabled approach *
    // retreieve a touch event from the set
    UITouch *t = [touches anyObject];
    
    // Get location of the touch in the view's coordinate system
    CGPoint location = [t locationInView:self];
    
    self.currentLine = [[ZGCLine alloc] init];
    self.currentLine.begin = location;
    self.currentLine.end = location;
*/
    
    [self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Let's put in a log statement  to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        ZGCLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
    
/*  switched to multitouch enabled approach *
    UITouch *t = [touches anyObject];
    
    CGPoint location = [t locationInView:self];
    
    self.currentLine.end = location;
*/
    
    [self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Lets put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        ZGCLine *line = self.linesInProgress[key];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key]; // could have use 'removeAllObjects' in this case
        
    }

/*  switched to multitouch enabled approach *
    [self.finishedLines addObject:self.currentLine];
    self.currentLine = nil;  // setting this property to nil for drawRect:'s logic (red vs black line)
*/
    
    [self setNeedsDisplay];

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // touchesCancelled is called when a touch action is cancelled by the OS
    // (a phone calls comes in, etc)
    
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
        
        [self setNeedsDisplay];
        
    }
    
}
#


@end
