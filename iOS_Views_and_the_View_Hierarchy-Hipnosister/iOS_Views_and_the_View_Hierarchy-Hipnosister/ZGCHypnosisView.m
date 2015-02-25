//
//  ZGCHypnosisView.m
//  iOS_Views_and_the_View_Hierarchy-Hipnosister
//
//  Created by EvilKernel on 2/22/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCHypnosisView.h"

@implementation ZGCHypnosisView

// Overwritting default initializer for a UIView to make background color clear for all instances of this view.
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // All ZGCHypnosisView vies start with a clear background
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

//overriding UIView's "drawRect:" to render a custom view (to draw a circle)

- (void)drawRect:(CGRect)rect {
    
    // build a CGRect to the bounds of the instanciated view
    CGRect bounds = self.bounds;
    
    
    // Find the center point of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0; //ie. half the window width
    center.y = bounds.origin.y + bounds.size.height / 2.0; //ie. half the window height
    
    // Set the Radius for the circle to half of the smaller of the views dimensions
    // this is necessary to draw circle properly in landscape or protrait mode
    // the circle wll be the largest that will fit in the view.
    // float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);
    
    // The largest circle will circumscribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2; //usinghalf of the hypotenuse of the entire view to obtain the maximum radius
    
    // DRAW the circle! //
    // Using UIBezierPath  - instancs of this class can draw lines and curves
    // that you can use to male shapes, like circles
    UIBezierPath *path = [[UIBezierPath alloc] init]; //init instance of UIBezierPath
    // Define the path. Add an arc to the path at center, with radius of radius,
    // from 0 to 2*PI radians (a circle)
    /* [path addArcWithCenter:center //using Arc method
                    radius:radius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES]; */
    
    // Drawing concentric circles //
    for (float currenRadius = maxRadius; currenRadius > 0; currenRadius -=20) {
        [path moveToPoint:CGPointMake(center.x + currenRadius, center.y)]; //needed for preventing the single UIBezierPath object from connecting the subpaths (the indivivdual circles) this is like lifting he pencil to draw the next circle
        [path addArcWithCenter:center
                        radius:currenRadius // Note this is currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
        
    }
    
    // Draw the line!
    path.lineWidth = 10; // configure the line to 10 points
    [[UIColor lightGrayColor] setStroke]; // UIColor method, defines color for future strokes
    [path stroke]; // using stroke method to draw the actual circles!
    
    
    // ADDING and IMAGE w/SHADOW to the view (must use CoreGraphics API directly for shadows and gradients operations like these) //
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"]; // define image
    // Get current drawing context for the view
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // Saving current context first
    CGContextSaveGState(currentContext);
    // Apply shadow to current context (everything drawn within this context gets a shadow now)
    CGContextSetShadow(currentContext, CGSizeMake(4, 8), 3);
    // Compositing image to the view //
    // Made a new smaller frame/cgrect to compensate for the wrong logo image size on new iphone6 simulator
    CGRect imageRect = CGRectMake(bounds.origin.x + 60, bounds.origin.y + 60, bounds.size.width / 1.5, bounds.size.height / 1.5);
    // Draw image
    [logoImage drawInRect:imageRect];
    // Restoring currentContext (everything drawn after this does not get shadow)
    CGContextRestoreGState(currentContext);
    
    

//
    // ADDING A Gradient //
    // gradients allow you to do shading that movies smoothly through a list of colors requires Core graphics API use directly as well.
    // Build parameters for gradient function
    CGFloat locations[2] = { 0.0, 1.0 }; // array of floats for location parameter
    CGFloat components[8] = { 1.0, 0.0, 0.0, 1.0, // Start Color is Red    // array of floats for components parameter
                            1.0, 1.0, 0.0, 1.0 }; // End color is Yellow
    // Encapsulates color space info - for colorSpace parameter
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Build/define gradient
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    // Define a Starting and Endpoints for gradient (required parameter for gradient draw function
    CGPoint startPoint = { imageRect.origin.x + imageRect.size.width / 2, imageRect.origin.y };
    CGPoint endPoint = { imageRect.origin.x + imageRect.size.width / 2, imageRect.origin.y + imageRect.size.height };

    // Apply Gradient to context //
    
//
    // Saving current context first
    CGContextSaveGState(currentContext);
//
    
//
    /// Add new subpath to existing Bezier Path to draw a triangle (a clipping path for the gradient)
    [path moveToPoint:startPoint]; // start out at point representing tip of triangle
    [path addLineToPoint:CGPointMake(imageRect.origin.x + imageRect.size.width, imageRect.origin.y + imageRect.size.height)]; // bottom right point
    [path addLineToPoint:CGPointMake(imageRect.origin.x, imageRect.origin.y + imageRect.size.height)]; // bottom left point
    [path closePath]; // closes segment between first and last CGPoints
    // Draw the lines for the clipping
    path.lineWidth = 1; // thickness of line to 1 point
    [UIColor clearColor]; // line color
    [path stroke]; // draw it
//
    
    // draw gradient
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation & kCGGradientDrawsAfterEndLocation); // bitwised-AND last two contants together to form last argument for this function
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

//
    // Restore CurrentContext (everything drawn after this does not get the gradient
    CGContextRestoreGState(currentContext);
//
    
    
    
    
    
    

    
    
}


@end
