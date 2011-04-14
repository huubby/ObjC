//
//  MultiColumnTableViewController.m
//  Level2UI
//
//  Created by zhou hua on 11-3-8.
//  Copyright 2011 compass. All rights reserved.
//
#define DEFAULT_CELL_HEIGHT 40
#define HALF        0.5
#define ONE_HALF    (1+HALF)

#import "MultiColumnTableViewController.h"
#import "MultiColumnTableCellView.h"

@implementation MultiColumnTableViewController

@synthesize multiColumnsTableDelegate;
@synthesize multiColumnsTableDataSource;

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [tableHeaderView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

//-(id)initWithFrame:(CGRect)frame
- (id)initWithStyle:(UITableViewStyle)style
{
    if ((self = [super initWithStyle: style])) {
        self.tableView.bounces = NO; //stops immediately at the content boundary without bouncing
        self.tableView.separatorColor = [UIColor blackColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        tableHeaderView = nil;
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  
    return 1;  
}  


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([multiColumnsTableDataSource respondsToSelector:@selector(numberOfRowsInTableView:)]) {
        return [multiColumnsTableDataSource numberOfRowsInTableView:tableView];
    } else {
        return 0;
    }
}  

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowIndex = [indexPath indexAtPosition:1];
    
    NSString *reuseIdentifier = [NSString stringWithFormat:@"%d", rowIndex];
	MultiColumnTableCellView *cell = 
    (MultiColumnTableCellView *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[MultiColumnTableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        if ([multiColumnsTableDataSource respondsToSelector:@selector(tableView: numberOfColumnsInRow:)]) {
            NSInteger columnsNum = [multiColumnsTableDataSource tableView:tableView numberOfColumnsInRow:rowIndex];
            for (int pos = 0; pos < columnsNum; pos++) {
                UITableCellColumnView *column = [multiColumnsTableDataSource tableView:tableView viewForColumnAtRow:rowIndex column:pos];
                NSString *identifier = [NSString stringWithFormat:@"%d-%d", rowIndex, pos];
                [cell insertColumn:column identifier:identifier atIndex:pos];
            }
        }
        
        if ([multiColumnsTableDataSource respondsToSelector:@selector(tableView: normalBackgroundColorForRowAtIndex:)]) {
            cell.normalBackground = [multiColumnsTableDataSource tableView:tableView 
                                        normalBackgroundColorForRowAtIndex:rowIndex
                                     ];
        }
        if ([multiColumnsTableDataSource respondsToSelector:@selector(tableView: selectedBackgroundColorForRowAtIndex:)]) {
            cell.selectedBackground = [multiColumnsTableDataSource tableView:tableView 
                                        selectedBackgroundColorForRowAtIndex:rowIndex
                                       ];
        }
    } else {
        if ([multiColumnsTableDataSource respondsToSelector:@selector(tableView: updateRow: atIndex:)]) 
            [multiColumnsTableDataSource tableView:tableView updateRow:cell atIndex:rowIndex];        
        [cell setNeedsDisplay];
        
    }
    
    if ([multiColumnsTableDelegate respondsToSelector:@selector(tableView:setStateOfCellView:atIndex:)]) {
        [multiColumnsTableDelegate tableView:tableView 
                          setStateOfCellView:cell 
                                     atIndex:rowIndex
         ];
    }
	
	return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([multiColumnsTableDelegate respondsToSelector:@selector(selectChangeAtTableView: rowAtIndexPath: selected:)]) 
        [multiColumnsTableDelegate selectChangeAtTableView:tableView rowAtIndexPath:indexPath selected:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([multiColumnsTableDelegate respondsToSelector:@selector(selectChangeAtTableView: rowAtIndexPath: selected:)]) 
        [multiColumnsTableDelegate selectChangeAtTableView:tableView rowAtIndexPath:indexPath selected:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    if ([multiColumnsTableDelegate respondsToSelector:@selector(tableView: heightForRowAtIndex:)])  {      
        NSInteger index = [indexPath indexAtPosition:1];
        return [multiColumnsTableDelegate tableView:tableView heightForRowAtIndex:index];
    }
    
    return 0.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([multiColumnsTableDelegate respondsToSelector:@selector(heightForHeaderOfTableView:)])
        return [multiColumnsTableDelegate heightForHeaderOfTableView:tableView];
    return 0.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (nil != tableHeaderView) {
        return tableHeaderView;
    }
    if ([multiColumnsTableDelegate respondsToSelector:@selector(viewForHeaderOfTableView:)]) {
        tableHeaderView = [[multiColumnsTableDelegate viewForHeaderOfTableView:tableView] retain];
        return tableHeaderView;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if ([multiColumnsTableDelegate respondsToSelector:@selector(scrollTableView:contentOffset:)])
        [multiColumnsTableDelegate scrollTableView:(UITableView *)sender contentOffset:self.tableView.contentOffset];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)sender willDecelerate:(BOOL)decelerate // called on finger up if user dragged. decelerate is true if it will continue moving afterwards
{
    if ([multiColumnsTableDelegate respondsToSelector:@selector(scrollTableViewEnd:contentOffset:)])
        [multiColumnsTableDelegate scrollTableViewEnd:(UITableView *)sender contentOffset:self.tableView.contentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    if ([multiColumnsTableDelegate respondsToSelector:@selector(scrollTableViewEnd:contentOffset:)])
        [multiColumnsTableDelegate scrollTableViewEnd:(UITableView *)sender contentOffset:self.tableView.contentOffset];
}

-(void)reloadRow:(NSIndexPath*)pPath
{
    if ([multiColumnsTableDataSource respondsToSelector:@selector(tableView:updateRow:atIndex:)])
    {
        MultiColumnTableCellView*    cell=(MultiColumnTableCellView*)[self.tableView cellForRowAtIndexPath:pPath];
        int rowIndex=[pPath indexAtPosition:1];
        [multiColumnsTableDataSource tableView:self.tableView updateRow:cell atIndex:rowIndex];
        [cell setNeedsDisplay];
    }
}

@end

