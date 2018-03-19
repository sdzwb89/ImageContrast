//
//  VVEXReslutViewController.m
//  imageContrast
//
//  Created by zhangbin on 2018/3/12.
//  Copyright © 2018年 vvex. All rights reserved.
//

#import "VVEXReslutViewController.h"

@interface VVEXReslutViewController ()
<NSTableViewDelegate,
NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation VVEXReslutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - dataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.array.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"reslutCellId" owner:self];
    NSString *pathString = self.array[row];
    NSLog(@"%@",pathString);
    if (cell) {
        cell.textField.stringValue = pathString ?: @"";
    }
    return cell;
}

@end
