//
//  ZGCHipnosisterView.m
//  iOS_Views_Pinch_to_Zoom_SILVER_Challenge
//
//  Created by EvilKernel on 3/7/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCHipnosisterView.h"

@interface ZGCHipnosisterView ()

@property (nonatomic, strong) UIColor *circleColor; //new property as class extension

@end

@implementation ZGCHipnosisterView

#pragma - init method
/* Overwritting designated initializer for a UIView to add a background color 'clear' for all instances of this view */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // All ZGCHypnosisView vies start with a clear background
        self.backgroundColor = [UIColor clearColor];
        // setting default setting for circlecolor proper via the init
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

#pragma - touch method
// Views overwrite this UIREsponder method, to hande a touch event upon themselves
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // When a finger touches the screen
    NSLog(@"%@ was touched", self);
    // Get 3 random numbers between 0 and 1
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    // build a Color with the random values
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    // set the color for the circle color property
    self.circleColor = randomColor;
    
}

#pragma - custom accessor circleColor property
// subclasses of UIView within the iOS SDK send themselves
// setNetDisplay whenever their content changes (ie. a UILabel view sends it to itself when its text is set/changed)
// this custom accessor for the circleColor property does just that
- (void)setCircleColor:(UIColor *)circleColor {
    _circleColor = circleColor;
    [self setNeedsDisplay]; //adds view to the list of dirty views needing a redisplay.
}

#pragma - main draw method
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

/* Overriding UIView's "drawRect:" to render a custom view (to draw a circle, triangles, etc) */

- (void)drawRect:(CGRect)rect {
    
    /*  Build a CGRect to the bounds of the instanciated view */
    CGRect bounds = self.bounds;
    
    
    //////// START DRAW CONCENTRIC CIRCLES //////////
    /*  Find the center point of the bounds rectangle */
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0; //ie. half the window width
    center.y = bounds.origin.y + bounds.size.height / 2.0; //ie. half the window height
    
    /*  Define the Radius for the circle */
    // set to half of the smaller of the views dimensions
    // this is necessary to draw circle properly in landscape or protrait mode
    // the circle wll be the largest that will fit in the view.
    // float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);  // <-defining max radius instead to draw concentric circles
    // Defining a 'Max Radius' instead for multiple circles, so the largest circle will circumscribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2; // using half of the hypotenuse of the entire view to obtain the maximum radius
    
    /*  Define a Path to DRAW circles using UIBezierPath object */
    // instances of this class can draw lines and curves to make any shapes, like circles.
    UIBezierPath *path = [[UIBezierPath alloc] init];
    // Define the path. Add an arc to the path at center, with radius of radius,
    // from 0 to 2*PI radians (a circle)
    /* [path addArcWithCenter:center //using Arc method
     radius:radius
     startAngle:0.0
     endAngle:M_PI * 2.0
     clockwise:YES]; */
    // Define a Path to draw concentric circles instead of just one (uses loop to decrease radius from MAX to 0)
    for (float currenRadius = maxRadius; currenRadius > 0; currenRadius -=20) {
        [path moveToPoint:CGPointMake(center.x + currenRadius, center.y)]; //needed for preventing the single UIBezierPath object from connecting the subpaths (the indivivdual circles) this is like lifting he pencil to draw the next circle
        [path addArcWithCenter:center
                        radius:currenRadius // Note this is currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    /*  Draw the Lines per the path */
    // Set line thickness
    path.lineWidth = 10;
    // Set Color - UIColor method, defines color for future strokes
    // [[UIColor lightGrayColor] setStroke];
    [self.circleColor setStroke]; // using new circle property instead
    // Draw the Paths (multiple circles)
    [path stroke];
    //////// FINISH DRAW CONCENTRIC CIRCLES //////////
    
    //-------- To be used by subsequent code -------
    /*  Get current image context - CoreGraphics API required here */
    // Get current drawing context for the view
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    /*  Made a new smaller frame to compensate for the wrong logo image size on new iphone6 simulator */
    CGRect imageRect = CGRectMake(bounds.origin.x + 60, bounds.origin.y + 60, bounds.size.width / 1.5, bounds.size.height / 1.5);
    //---------------------------------------------
    
    
    
    //////// GOLD - START DRAW A GRADIENT //////////
    /*  Define a Gradient  - Gradients, like shadows, require CoreGraphics API directly */
    // Gradients allow you to do shading that moves smoothly through a list of colors.
    // Build parameters for gradient function
    CGFloat locations[2] = { 0.0, 1.0 }; // array of floats for location parameter
    CGFloat components[8] = { 1.0, 0.0, 0.0, 1.0, // Start Color is Red    // array of floats for components parameter
        1.0, 1.0, 0.0, 1.0 }; // End color is Yellow
    // Encapsulates color space info - for colorSpace parameter
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Build gradient
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    /*  Define a Starting and Endpoints for gradient (required parameter for gradient draw function */
    CGPoint startPoint = { imageRect.origin.x + imageRect.size.width / 2, imageRect.origin.y };
    CGPoint endPoint = { imageRect.origin.x + imageRect.size.width / 2, imageRect.origin.y + imageRect.size.height };
    
    /*  Define Triangle-Shaped Clipping Area for Gradient (by default they draw entire view frame) */
    /*** USING CoreGraphics API in favor of Bezier object to build and draw the clipping path (good CG Practice) ***
     // Add new subpath to existing Bezier Path to draw a triangle (a clipping path for the gradient
     // Start out at tip point of triangle
     [path moveToPoint:startPoint];
     // Bottom Right point
     [path addLineToPoint:CGPointMake(imageRect.origin.x + imageRect.size.width, imageRect.origin.y + imageRect.size.height)];
     // Bottom Left point
     [path addLineToPoint:CGPointMake(imageRect.origin.x, imageRect.origin.y + imageRect.size.height)];
     // Close last segment between first and last CGPoints
     [path closePath];
     // Draw the lines for the clipping
     path.lineWidth = 1; // thickness of line to 1 point
     // Set line color and stroke
     [[UIColor clearColor] setStroke];
     // Draw the line
     [path stroke];
     // Making the path a "clipping" for the gradient via 'addClip' method
     [path addClip];  ***/
    
    /*  Define Triangle Path */
    // Coordinates / Path for triangle
    CGPoint trianTop = CGPointMake(imageRect.origin.x + imageRect.size.width / 2, imageRect.origin.y);
    CGPoint trianRight = CGPointMake(imageRect.origin.x + imageRect.size.width, imageRect.origin.y + imageRect.size.height);
    CGPoint trianLeft = CGPointMake(imageRect.origin.x, imageRect.origin.y + imageRect.size.height);
    
    /*  Draw Triangle  */
    // Build array of CGPoints for upcoming parameter
    CGPoint lines[] = { trianTop, trianRight, trianLeft };
    // Add line segments to current context per defined path
    CGContextAddLines(currentContext, lines, 3); // this function draws segment with supplied parameters
    /*  Make Clipping on Existing Context */
    // Saving current context first
    CGContextSaveGState(currentContext);
    // Add Clipping path to current context
    CGContextClip(currentContext);
    
    /*  Draw Gradient per Clipping */
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint,
                                kCGGradientDrawsBeforeStartLocation & kCGGradientDrawsAfterEndLocation); // bitwised-AND last two contants together to form last argument
    /* Release gradient and color space memory (previous C functions using 'create' need manual dealloc) */
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    /* Restore CurrentContext (everything drawn after this does not get the gradient) */
    CGContextRestoreGState(currentContext);
    //////// FINISH DRAW A GRADIENT //////////
    
    
    //////// BRONZE - START DRAW A LOGO IMAGE W / SHADOW //////////
    /*  Define Image */
    // instance of UIImage
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"]; // define image
    
    /*  Saving current context first - CoreGraphics API functions required here */
    CGContextSaveGState(currentContext);
    
    /*  Apply a Shadow to curren Context - CoreGraphics API functions required here, no ObjC abstracted yet */
    // Everything drawn within this context gets a shadow after this, the logo in this case
    CGContextSetShadow(currentContext, CGSizeMake(4, 8), 3); //func takes 3 arguments: context, CGSize, and offset
    
    /*  Compositing UIImage to the view */
    // Draw image on fixed rectangle
    [logoImage drawInRect:imageRect];
    
    /*  Restoring currentContext (everything drawn after this does not get shadow) */
    CGContextRestoreGState(currentContext);
    //////// FINISH DRAW A LOGO IMAGE W / SHADOW //////////
    
}

@end
