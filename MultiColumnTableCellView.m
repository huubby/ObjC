//
//  MultiColumnTableCellView.m
//  Level2UI
//
//  Created by zhou hua on 11-3-8.
//  Copyright 2011 compass. All rights reserved.
//

#define DEFAULT_COLUMN_INTERVAL 10
#define HALF    0.5
#define QUARTER 0.25
#define ONE_THIRD 0.3333
#define DEFAULT_TABLECELLVIEW_ITEM_FONT [UIFont systemFontOfSize: 12.0]

#import "MultiColumnTableCellView.h"
#import "UITableCellColumnView.h"

@interface MultiColumnTableCellView(PrivateMethods)

- (void)adjustColumnsInRect:(CGRect)rect;

@end

// Implementation for MultiColumnTableCellView
@implementation MultiColumnTableCellView

@synthesize normalBackground;
@synthesize selectedBackground;

- (void)dealloc 
{
    [keys release];
    [columns release];
    [normalBackground release];
    [selectedBackground release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier: reuseIdentifier])) {        
        normalBackground = nil;
        selectedBackground = nil;
        keys = [[NSMutableArray alloc] init];
        columns = [[NSMutableArray alloc] init];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	if(!context)    return ;
    CGContextClearRect(context, rect);
    
    [self adjustColumnsInRect:rect];
    
    if (self.selected)
        self.contentView.backgroundColor = selectedBackground;//[UIColor colorWithPatternImage:selectedImage];
    else
        self.contentView.backgroundColor = normalBackground;//[UIColor colorWithPatternImage:normalImage];
}

- (void)adjustColumnsInRect:(CGRect)rect {
	float columnWidth = rect.size.width / columns.count;
	
	NSEnumerator *enumerator = [columns objectEnumerator];
	UITableCellColumnView *columnView;
	
	int index = 0;
	while ((columnView = [enumerator nextObject])) {
        CGRect columnFrame = CGRectMake(index*columnWidth, 0.0, columnWidth, rect.size.height);
        [columnView setFrame:columnFrame];        
		index++;
	}
}

- (void)setSelectedState:(BOOL)selected {
    if (selected) {
        self.selected = YES;
        if (selectedBackground)
            self.contentView.backgroundColor = selectedBackground;//[UIColor colorWithPatternImage:selectedImage];
        else
            self.contentView.backgroundColor = [UIColor clearColor];
    } else {
        self.selected = NO;
        if (normalBackground)
            self.contentView.backgroundColor = normalBackground;//[UIColor colorWithPatternImage:normalImage];
        else
            self.contentView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setNeedsDisplay
{
    NSEnumerator *enumerator = [columns objectEnumerator];
    UITableCellColumnView *cellColumn = nil;
    while ((cellColumn = [enumerator nextObject]))
        [cellColumn setNeedsDisplay];
    
    [super setNeedsDisplay];
}

- (UITableCellColumnView *)columnAtIndex:(NSUInteger)index
{    
    if (index < [columns count]) {
        return (UITableCellColumnView *)[columns objectAtIndex:index];
    }
    
    return nil;
}

- (void)beginUpdates
{
    
}

- (void)endUpdates
{
    [self adjustColumnsInRect:self.contentView.bounds];
}

- (UITableCellColumnView *)dequeueReusableColumnWithIdentifier:(NSString *)identifier 
{    
    int index = [keys indexOfObject:identifier];
    return  [columns objectAtIndex:index];
}

- (void)insertColumn:(UITableCellColumnView *)column identifier:(NSString *)identifier atIndex:(NSInteger)index
{
    if (column == nil) {
        return;
    }
    
    if (index >= [keys count]) {
        [keys addObject:identifier];
    } else {
        [keys insertObject:identifier atIndex:index];
    }
    
    if (index >= [columns count]) {
        [columns addObject:column];
    } else {
        [columns insertObject:column atIndex:index];
    }
    
    [self.contentView addSubview:column];
}

- (void)deleteColumnAtIndex:(NSInteger)index
{
    [keys removeObjectAtIndex:index];
    
    UITableCellColumnView *column = [columns objectAtIndex:index];
    [column removeFromSuperview];
    [columns removeObjectAtIndex:index];
}

- (void)reloadColumnData:(NSString *)text atIndex:(NSInteger)index
{    
    UITableCellColumnView *cellColumn = [columns objectAtIndex:index];
    cellColumn.text = text;
}

@end
