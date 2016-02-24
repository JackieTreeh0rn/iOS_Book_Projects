//
//  ZGCDrawView.m
//  ZGCTouchTracker
//
//  Created by EviLKerneL on 5/25/15.
//  Copyright (c) 2015 EviLKerneL. All rights reserved.
//

#import "ZGCDrawView.h"
#import "ZGCLine.h"

#pragma mark - C helper functions
// Retrieve iOS docs path
NSString *ZGCDocsPath() {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); // foundation function
    return [pathList[0] stringByAppendingPathComponent:@"lines.plist"];
}

// Calculate line angle (between two points / two vectors
// multiple ways to go about this, here using atan2(point, point) to simplify operation
double ZGCAngleBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    
    // calculate the distance/vectors between both points
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point1.y - point2.y;

    // calculate angle
    CGFloat radian = atan2f(dy, dx); // bearing in radians

    // convert to degrees
    CGFloat angle = radian * 180 / M_PI;
    
    // Output Angle (in degrees) and Quadrant #
    if (radian >= 0 &&  radian < M_PI/2  ){
        NSLog(@" %.2f degrees : 1st Quadrant", angle);
    }
    else if (radian >= M_PI/2 && radian <  M_PI) {
        NSLog(@" %.2f degrees : 2nd Quadrant", angle);
    }
    else if (radian >= - M_PI && radian  < -(M_PI/2)) {
        NSLog(@" %.2f degrees : 3rd Quadrant", angle);
    }
    else if (radian >= -(M_PI/2) && radian < 0) {
        NSLog(@" %.2f degrees : 4th Quadrant", angle);
    }
    
    return angle;
    
}
#


@interface ZGCDrawView ()
// @property (nonatomic, strong) ZGCLine *currentLine;  <-- switching to dictionary for multiple touches / lines
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, weak) ZGCLine *selectedLine;
@end

@implementation ZGCDrawView


#pragma mark - view INIT
- (instancetype)initWithFrame:(CGRect)frame { // init override to instantiate variables
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        
        // load saved lines if they exist
        NSArray *plist = [NSArray arrayWithContentsOfFile:ZGCDocsPath()];
        if (plist) {
            NSLog(@"_saved lines found, loading...\n\n %@", plist);
            self.finishedLines = [plist mutableCopy];
        } else {
            NSLog(@"No saved lines found...");
            self.finishedLines = [[NSMutableArray alloc] init];
        }
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
        
        // Adding a UIToolbar with a clear button, programatically...
        CGRect barRect = self.bounds;
        barRect.origin.y = 625;
        barRect.size.height = 44;
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:barRect];
        [toolbar sizeToFit];
        self.autoresizesSubviews = YES;
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        // Buttons
        UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *clearLines = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearLines)];
        UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        clearLines.tintColor = [UIColor whiteColor];
        toolbar.items = @[flex1, clearLines, flex2];
        
        [self addSubview:toolbar];
        
        
        // Adding a Gesture Recognizer (to clear screen when two taps are detected)
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES; // delays first tap so view doesnt get it right away (keeps dot from being drawn before 2 taps occur)
        [self addGestureRecognizer:doubleTapRecognizer];
        
        // Adding another Gesture Recognizer to allow for selecting a line
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer]; // to avoid multiple gesture recog. to be triggered (eg. a tap during a double tap)
        [self addGestureRecognizer:tapRecognizer];
        


    }
    
    return self;
}
#

#pragma mark - view public methods
- (void)saveChanges {
    
    BOOL success = [self.finishedLines writeToFile:ZGCDocsPath() atomically:YES];
    // called by AppDelegate when exiting
    if (success) {
        NSLog(@"Saving to: %@", ZGCDocsPath());
    } else {
        NSLog(@"Save location not found: %@", ZGCDocsPath());
    }
    
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

- (void)doubleTap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized double tap");
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
    
}

- (void)tap:(UIGestureRecognizer *)gr {
    NSLog(@"Recognized single tap");
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    [self setNeedsDisplay];
}

- (void)clearLines {
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (ZGCLine *)lineAtPoint:(CGPoint)p {
    // Find a line close to p
    for (ZGCLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        // Check a few points on the line
        for (float t = 0.0; t <= 1.0; t +=0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within 20 points, lets return this line
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    // if nothing is close enouhg to the tapped point, no line was selected
    return nil;
}

- (UIColor *)colorFromAngle:(ZGCLine *)line {
    // Get angle for line (in degrees)
    CGFloat angleIn = ZGCAngleBetweenTwoPoints(line.begin, line.end);
    
    // converting degrees to radian for below calculations
    CGFloat angle = angleIn * M_PI / 180.0;
    
    // normalize atan from [-pi,pi] to [0,2pi]
    // need this for the color logic below, otherwise you get limited color range
    if (angle < 0) {
        angle += 2 * M_PI;
    }
    
    // Begin color logic
    CGFloat redVal, greenVal, blueVal;
    
    // each pi/3 interval gets different rules
    // 0 to 30deg
    if (angle > 0 && angle <= 1 * M_PI / 6.0) {
        redVal = [self normalizeAngle:angle
                                 from:-M_PI / 6.0
                                   to:M_PI / 6.0];
        greenVal = 1;
        blueVal = 0;
        
    //30 to 90deg
    } else if (angle > 1 * M_PI / 6.0 && angle <= 3 * M_PI / 6.0){
        redVal = 1;
        greenVal = 1 - [self normalizeAngle:angle
                                       from:1 * M_PI / 6.0
                                         to:3 * M_PI / 6.0];
        blueVal = 0;
        
    //90 to 150deg
    } else if (angle > 3 * M_PI / 6.0 && angle <= 5 * M_PI / 6.0){
        redVal = 1;
        greenVal = 0;
        blueVal = [self normalizeAngle:angle
                                  from:3 * M_PI / 6.0
                                    to:5 * M_PI / 6.0];
        
    //150 to 210deg
    } else if (angle > 5 * M_PI / 6.0 && angle <= 7 * M_PI / 6.0) {
        redVal = 1 - [self normalizeAngle:angle
                                     from:5 * M_PI / 6.0
                                       to:7 * M_PI / 6.0];
        greenVal = 0;
        blueVal = 1;
        
    //210 to 270deg
    } else if (angle > 7 * M_PI / 6.0 && angle <= 9 * M_PI / 6.0) {
        redVal = 0;
        greenVal = [self normalizeAngle:angle
                                   from:7 * M_PI / 6.0
                                     to:9 * M_PI / 6.0];
        blueVal = 1;
    
    //270 to 330deg
    } else if (angle > 9 * M_PI / 6.0 && angle <= 11 * M_PI / 6.0){
        redVal = 0;
        greenVal = 1;
        blueVal = 1 - [self normalizeAngle:angle
                                      from:9 * M_PI / 6.0
                                        to:11 * M_PI / 6.0];
    //330 to 360deg
    } else {
        redVal = [self normalizeAngle:angle
                                 from:11 * M_PI / 6.0
                                   to:13 * M_PI / 6.0];
        greenVal = 1;
        blueVal = 0;
    }
    
    NSLog(@"radians:%f, R:%f, G:%f, B:%f", angle, redVal, greenVal, blueVal);
    
    return [UIColor colorWithRed:redVal green:greenVal blue:blueVal alpha:1.0];

    
}
     
- (float)normalizeAngle:(float)angle from:(float)min to:(float)max {
    
    if (angle > max || angle < min) {
        NSLog(@"normalizeAngle out of range,");
    }
    return (angle - min) / (max - min);
}

#


#pragma mark - view drawRect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // Drawing finished lines in black
    // [[UIColor blackColor] set]; // <-- switched to color based on angle
    for (ZGCLine *line in self.finishedLines) {
        UIColor *lineColor = [self colorFromAngle:line];
        [lineColor set];
        [self strokeLine:line];
        
        
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
        
        // Output line angle and quadrant as it is drawn
        ZGCLine *line = self.linesInProgress[key];
        ZGCAngleBetweenTwoPoints(line.begin, line.end);


    }
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
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
  //  NSLog(@"%@", NSStringFromSelector(_cmd));
    
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
   // NSLog(@"%@", NSStringFromSelector(_cmd));
    
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
  //  NSLog(@"%@", NSStringFromSelector(_cmd));
    
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
