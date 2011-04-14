//
//  MultiColumnTableCellView.h
//  Level2UI
//
//  Created by zhou hua on 11-3-8.
//  Copyright 2011 compass. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableCellColumnView;

// Multiple columns table cell view
@interface MultiColumnTableCellView : UITableViewCell {
    UIColor *normalBackground;
    UIColor *selectedBackground;
@private
    NSMutableArray *keys;
    NSMutableArray *columns;
}

@property(nonatomic,retain) UIColor *normalBackground;
@property(nonatomic,retain) UIColor *selectedBackground;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (UITableCellColumnView *)dequeueReusableColumnWithIdentifier:(NSString *)identifier;
- (UITableCellColumnView *)columnAtIndex:(NSUInteger)index;

- (void)beginUpdates;
- (void)endUpdates;

- (void)insertColumn:(UITableCellColumnView *)column identifier:(NSString *)identifier atIndex:(NSInteger)index;
- (void)deleteColumnAtIndex:(NSInteger)index;
- (void)reloadColumnData:(NSString *)text atIndex:(NSInteger)index;

- (void)setSelectedState:(BOOL)selected;

@end
