//
//  UITableCellColumnView.h
//  Level2UI
//
//  Created by zhou hua on 11-3-21.
//  Copyright 2011年 compass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableCellColumnView : UIView {
@private    
    NSString *reuseIdentifier;
}

@property(nonatomic,retain) UIImage *image;
@property(nonatomic,retain) NSString *text;
@property(nonatomic,retain) UIFont *textFont;
@property(nonatomic,retain) UIColor *textColor;
@property(nonatomic) UITextAlignment textAlignment;
@property(nonatomic,readonly) CGSize minSize;

- (id)initWithReuseIdentifier:(NSString *)_reuseIdentifier; 

@end
