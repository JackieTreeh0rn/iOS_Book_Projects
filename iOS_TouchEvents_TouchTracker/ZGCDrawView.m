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

// declarations
double ZGCAngleBetweenTwoPoints(CGPoint point1, CGPoint point2);
int ZGCQuadrantforAngle(CGFloat degrees);
NSString *ZGCDocsPath(void);


// retrieve iOS docs path
NSString *ZGCDocsPath() {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); // foundation function
    return [pathList[0] stringByAppendingPathComponent:@"lines.plist"];
}

// Calculate line angle (between two points / two vectors
// multiple ways to go about this, calculating thetas and cos (trigonemetry way)
// but in this case using math function atan2(point, point) to simplify operations
double ZGCAngleBetweenTwoPoints(CGPoint point1, CGPoint point2) {
    // calculate the distance/vectors between both points
    CGFloat dx = point2.x - point1.x;
    // CGFloat dy = point2.y - point1.y;
    CGFloat dy = point1.y - point2.y; // <-- adjusting sign (-pi / +pi) to correct quadrant location

    // calculate angle (returns bearing in radians)
    CGFloat angleRad = atan2f(dy, dx);

    // convert radians to degrees
    CGFloat angleDeg = angleRad * 180 / M_PI;
    
    // get quadrant for angle/point
    int quadrant = ZGCQuadrantforAngle(angleDeg);
    
    // Log Angle (in degrees) and Quadrant #, and return it
    NSLog(@" %.2f degrees : Quadrant %d ", angleDeg, quadrant);

    return angleDeg;
    
}

int ZGCQuadrantforAngle(CGFloat degrees) {
    // convert angle to radians
    CGFloat angleRad = degrees * M_PI / 180.0;
    
    // determine quadrant for angle / log it / return it
    int quadrant = 0;
    if (angleRad >= 0 &&  angleRad < M_PI/2  ){
        quadrant +=1;
        // NSLog(@" %dst Quadrant", quadrant);
    }
    else if (angleRad >= M_PI/2 && angleRad <  M_PI) {
        quadrant +=2;
        // NSLog(@"%dnd Quadrant", quadrant);
    }
    else if (angleRad >= - M_PI && angleRad  < -(M_PI/2)) {
        quadrant +=3;
        // NSLog(@" %drd Quadrant", quadrant);
    }
    else if (angleRad >= -(M_PI/2) && angleRad < 0) {
        quadrant +=4;
        // NSLog(@" %dth Quadrant", quadrant);
    }
    
    return quadrant;
}

#


@interface ZGCDrawView ()
// @property (nonatomic, strong) ZGCLine *currentLine;  <-- switching to dictionary for multiple touches / lines
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableDictionary *circlesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@property (nonatomic, strong) NSMutableArray *finishedCircles;
@property (nonatomic) lineType currentLineType;
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

- (void)strokeArc:(ZGCLine *)line {
    
}

- (void)clearLines {
    [self.finishedLines removeAllObjects];
    [self.finishedCircles removeAllObjects];
    [self setNeedsDisplay];
}

- (UIColor *)colorFromAngle:(ZGCLine *)line {
    // Get angle for line (in degrees)
    CGFloat angleDeg = ZGCAngleBetweenTwoPoints(line.begin, line.end);
    
    // converting degrees to radian for below calculations
    CGFloat angleRad = angleDeg * M_PI / 180.0;
    
    // normalize atan2's return from [-pi,pi] to [0,2pi]
    // need this for the color logic below, otherwise you get limited color range
    if (angleRad < 0) {
        angleRad += 2 * M_PI;
    }
    
    // Begin color logic //
    // define color variables R, G, B
    CGFloat redVal, greenVal, blueVal;
    
    // each pi/3 interval gets different rules
    // 0 to 30deg
    if (angleRad > 0 && angleRad <= 1 * M_PI / 6.0) {
        redVal = [self normalizeAngle:angleRad
                                 from:-M_PI / 6.0
                                   to:M_PI / 6.0];
        greenVal = 1;
        blueVal = 0;
        
    //30 to 90deg
    } else if (angleRad > 1 * M_PI / 6.0 && angleRad <= 3 * M_PI / 6.0){
        redVal = 1;
        greenVal = 1 - [self normalizeAngle:angleRad
                                       from:1 * M_PI / 6.0
                                         to:3 * M_PI / 6.0];
        blueVal = 0;
        
    //90 to 150deg
    } else if (angleRad > 3 * M_PI / 6.0 && angleRad <= 5 * M_PI / 6.0){
        redVal = 1;
        greenVal = 0;
        blueVal = [self normalizeAngle:angleRad
                                  from:3 * M_PI / 6.0
                                    to:5 * M_PI / 6.0];
        
    //150 to 210deg
    } else if (angleRad > 5 * M_PI / 6.0 && angleRad <= 7 * M_PI / 6.0) {
        redVal = 1 - [self normalizeAngle:angleRad
                                     from:5 * M_PI / 6.0
                                       to:7 * M_PI / 6.0];
        greenVal = 0;
        blueVal = 1;
        
    //210 to 270deg
    } else if (angleRad > 7 * M_PI / 6.0 && angleRad <= 9 * M_PI / 6.0) {
        redVal = 0;
        greenVal = [self normalizeAngle:angleRad
                                   from:7 * M_PI / 6.0
                                     to:9 * M_PI / 6.0];
        blueVal = 1;
    
    //270 to 330deg
    } else if (angleRad > 9 * M_PI / 6.0 && angleRad <= 11 * M_PI / 6.0){
        redVal = 0;
        greenVal = 1;
        blueVal = 1 - [self normalizeAngle:angleRad
                                      from:9 * M_PI / 6.0
                                        to:11 * M_PI / 6.0];
    //330 to 360deg
    } else {
        redVal = [self normalizeAngle:angleRad
                                 from:11 * M_PI / 6.0
                                   to:13 * M_PI / 6.0];
        greenVal = 1;
        blueVal = 0;
    }
    
    NSLog(@"Radians:%f, Color field: R:%f, G:%f, B:%f", angleRad, redVal, greenVal, blueVal);
    
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
        ZGCQuadrantforAngle(ZGCAngleBetweenTwoPoints(line.begin, line.end)); // function returns but also NSLogs

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
    
    // Circles logic
    // if two fingers are used and they are on opposite quadrants,
    // draw arcs
    NSUInteger touchCount = touches.count;
    
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        ZGCLine *line = [[ZGCLine alloc] init];
        line.begin = location;
        line.end = location;
        
        // get quadrant for line location
        int quadrant = ZGCQuadrantforAngle(ZGCAngleBetweenTwoPoints(line.begin, line.end));
        
        // get a key based on object memory location
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        // define line type (arc or straight) based on opposite quadrants of 2 fingers
        if (touchCount == 2) {
            switch (quadrant) {
                case 1:
                case 3:
                    line.lineType = arc;
                    self.currentLineType = line.lineType;
                    self.circlesInProgress[key] = line;
                    break;
                case 2:
                case 4:
                    line.lineType = arc;
                    self.currentLineType = line.lineType;
                    self.circlesInProgress[key] = line;
                    break;
                    
                default:
                    line.lineType = straight;
                    self.currentLineType = line.lineType;
                    self.linesInProgress[key] = line;
                    break;
            }
        } else { // more or less than two fingers, draw straight lines
            line.lineType = straight;
            self.currentLineType = line.lineType;
            self.linesInProgress[key] = line;
        }
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
        if (self.currentLineType == arc) {
            ZGCLine *line = self.circlesInProgress[key];
            line.end = [t locationInView:self];
        } else {
            ZGCLine *line = self.linesInProgress[key];
            line.end = [t locationInView:self];
        }
        
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
        if (self.currentLineType == arc) {
            ZGCLine *line = self.circlesInProgress[key];
            [self.finishedCircles addObject:line];
            [self.circlesInProgress removeObjectForKey:key];
        } else {
        ZGCLine *line = self.linesInProgress[key];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key]; // could have use 'removeAllObjects' in this case
        }
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
    // NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
        [self.circlesInProgress removeObjectForKey:key];
        
        // shouldnt have to nil currentlinetype as it should go nil after the line object
        // is removed from memory when it leaves the dictionary container.
        
        [self setNeedsDisplay];
        
    }
    
}
#


@end
