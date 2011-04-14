//
//  UITableCellColumnView.m
//  Level2UI
//
//  Created by zhou hua on 11-3-21.
//  Copyright 2011年 compass. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UITableCellColumnView.h"

@implementation UITableCellColumnView

@synthesize image=_image;
@synthesize text=_text;
@synthesize textFont=_textFont;
@synthesize textColor=_textColor;
@synthesize textAlignment=_textAlignment;
@synthesize minSize;

- (void)dealloc
{
    [_image release];
    [_text release];
    [_textFont release];
    [_textColor release];
    [reuseIdentifier release];
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)_reuseIdentifier 
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        reuseIdentifier = [_reuseIdentifier retain];
        
        self.backgroundColor = [UIColor clearColor];;
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	if(!context)    return ;
    CGContextClearRect(context, rect);
    
    CGContextSetLineWidth(context, 1.0);
	CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGRect textFrame = CGRectZero;
    CGSize textSize = [self.text sizeWithFont:self.textFont constrainedToSize:CGSizeMake(MAXFLOAT, rect.size.height)];
    if (self.image) {
        CGRect imageFrame = CGRectZero;
        imageFrame.origin.x = (rect.size.width - self.image.size.width) / 2;
        imageFrame.origin.y = (rect.size.height - self.image.size.height) / 2;
        imageFrame.size = self.image.size;
        CGContextDrawImage(context, imageFrame, self.image.CGImage);

        textFrame = imageFrame;
        textFrame.origin.x += (textFrame.size.width - textSize.width) / 2;
        textFrame.origin.y += (self.image.size.height - textSize.height) / 2;
        textFrame.size.width -= (imageFrame.size.width - textSize.width);
        
//        textFrame.origin.y = imageFrame.origin.y + (self.image.size.height - textSize.height) / 2;
//        if (self.image.size.width > textSize.width) {
//            textFrame.size = CGSizeMake(textSize.width, self.image.size.height);
//        } else {
//            textFrame.size = CGSizeMake(self.image.size.width, self.image.size.height);
//        }
    } else {
        textFrame.origin.y = (rect.size.height - textSize.height) / 2;
        float width = MAX(rect.size.width*0.8, textSize.width);
        textFrame.size = CGSizeMake(width, rect.size.height);
    }
    
    CGContextSetFillColorWithColor(context, self.textColor.CGColor);
    [self.text drawInRect:textFrame 
                 withFont:self.textFont 
            lineBreakMode:UILineBreakModeTailTruncation 
                alignment:self.textAlignment
     ];
}

- (CGSize)getMinSize 
{
    CGSize textSize = [self.text sizeWithFont:self.textFont constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    return textSize;
}

@end
