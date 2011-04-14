//
//  MultiColumnTableViewController.h
//  Level2UI
//
//  Created by zhou hua on 11-3-8.
//  Copyright 2011 compass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiColumnTableViewDelegate.h"

// Multiple columns table view controller, implement protocol 'UITableViewDelegate' and 'UITableViewDataSource'
@interface MultiColumnTableViewController : UITableViewController {
@private
    NSObject<MultiColumnTableViewDelegate> *multiColumnsTableDelegate;
    NSObject<MultiColumnTableViewDataSource> *multiColumnsTableDataSource;
    UIView *tableHeaderView;
}

@property(nonatomic,assign) NSObject<MultiColumnTableViewDelegate> *multiColumnsTableDelegate;
@property(nonatomic,assign) NSObject<MultiColumnTableViewDataSource> *multiColumnsTableDataSource;

-(void)reloadRow:(NSIndexPath*)pPath;

@end
