//
//  MultiColumnTableView.h
//  Level2UI
//
//  Created by zhou hua on 11-3-21.
//  Copyright 2011年 compass. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UITableCellColumnView;
@class MultiColumnTableCellView;

// Delegate of multiple column table view
@protocol MultiColumnTableViewDelegate

@optional

- (void)selectChangeAtTableView:(UITableView *)tableView 
                 rowAtIndexPath:(NSIndexPath *)indexPath 
                       selected:(BOOL)selected;

- (void)scrollTableView:(UITableView *)sender contentOffset:(CGPoint)contentOffset;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndex:(NSInteger)index;

- (CGFloat)heightForHeaderOfTableView:(UITableView *)tableView;

- (UIView *)viewForHeaderOfTableView:(UITableView *)tableView;

- (void)tableView :(UITableView *)tableView 
setStateOfCellView:(MultiColumnTableCellView *)cell 
          atIndex :(NSInteger)rowIndex;

- (void)scrollTableViewEnd:(UITableView *)sender contentOffset:(CGPoint)contentOffset;

@end

@protocol MultiColumnTableViewDataSource

@optional

- (NSInteger)numberOfRowsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfColumnsInRow:(NSInteger)row;

- (UITableCellColumnView *)tableView:(UITableView *)tableView 
                  viewForColumnAtRow:(NSInteger)row 
                              column:(NSInteger)column;

- (UIColor *)tableView:(UITableView *)tableView normalBackgroundColorForRowAtIndex:(NSInteger)row;
- (UIColor *)tableView:(UITableView *)tableView selectedBackgroundColorForRowAtIndex:(NSInteger)row;

- (void)tableView:(UITableView *)tableView updateRow:(MultiColumnTableCellView *)cell atIndex:(NSInteger)rowIndex;

@end
