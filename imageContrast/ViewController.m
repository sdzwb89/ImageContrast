//
//  ViewController.m
//  imageContrast
//
//  Created by zhangbin on 2018/3/7.
//  Copyright © 2018年 vvex. All rights reserved.
//

#import "ViewController.h"
#import "VVEXFileSearch.h"

@interface ViewController()
<NSTableViewDelegate,
NSTableViewDataSource>

@property (weak) IBOutlet NSTextField *pathLabel;

@property (weak) IBOutlet NSTableView *tableView1;
@property (weak) IBOutlet NSTableView *tableView2;
@property (weak) IBOutlet NSTextField *suffixTextField;

@property (nonatomic, strong) NSMutableArray *result1;
@property (nonatomic, strong) NSMutableArray *result2;

@property (weak) IBOutlet NSTextField *pathLabel2;

@property (nonatomic, strong) NSArray *pathArray1;
@property (nonatomic, strong) NSArray *pathArray2;

@property (weak) IBOutlet NSProgressIndicator *process1;

@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSButton *search1;
@property (weak) IBOutlet NSButton *search2;
@property (weak) IBOutlet NSButton *contrast1;
@property (weak) IBOutlet NSButton *contrast2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    
    self.process1.style = NSProgressIndicatorSpinningStyle;
    self.process1.wantsLayer = YES;
    self.process1.layer.backgroundColor = [NSColor greenColor].CGColor;
    self.process1.controlSize = NSControlSizeRegular;
    self.process1.indeterminate = YES;
    [self.process1 sizeToFit];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


- (IBAction)searchPNG:(NSButton *)sender {
    
    NSString *path;
    if (sender.tag == 300) {
        path = self.pathLabel.stringValue;
    } else {
        path = self.pathLabel2.stringValue;
    }
    if (!self.suffixTextField.stringValue) {
        self.suffixTextField.stringValue = @"@2x.png";
    }
    VVEXFileSearch *search = [VVEXFileSearch new];
    [search showAllFileWithPath:path withSuffix:self.suffixTextField.stringValue];
    if (sender.tag == 300) {
        self.pathArray1 = search.mArray.copy;
        NSTableColumn *colu = [[self.tableView1 tableColumns] firstObject];
        colu.title = [NSString stringWithFormat:@"共查到%zd张图片",self.pathArray1.count];
        [self.tableView1 reloadData];
        self.contrast1.enabled = self.pathArray1.count > 0;
    }else{
        self.pathArray2 = search.mArray.copy;
        NSTableColumn *colu = [[self.tableView2 tableColumns] firstObject];
        colu.title = [NSString stringWithFormat:@"共查到%zd张图片",self.pathArray2.count];
        [self.tableView2 reloadData];
        self.contrast2.enabled = self.pathArray2.count > 0 && self.pathArray1.count > 0;
    }
}

- (IBAction)choicePath:(NSButton *)sender {
    
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    __weak typeof(self)weakSelf = self;
    //是否可以创建文件夹
    panel.canCreateDirectories = NO;
    //是否可以选择文件夹
    panel.canChooseDirectories = YES;
    //是否可以选择文件
    panel.canChooseFiles = NO;
    //是否可以多选
    [panel setAllowsMultipleSelection:NO];
    
    //显示
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        
        //是否点击open 按钮
        if (result == NSModalResponseOK) {
            //NSURL *pathUrl = [panel URL];
            NSString *pathString = [panel.URLs.firstObject path];
            if (sender.tag == 100) {
                weakSelf.pathLabel.stringValue = pathString;
                weakSelf.search1.enabled = YES;
            } else {
                weakSelf.pathLabel2.stringValue = pathString;
                weakSelf.search2.enabled = YES;
            }
        }
    }];
}

- (IBAction)contrastImage:(NSButton *)sender {
    
    NSInteger tag = sender.tag;
    [self.process1 startAnimation:nil];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:@"imageContrast"];
    if (![fileManager fileExistsAtPath: path]) {
        NSError *error = nil;
        BOOL isSuccess = [fileManager createDirectoryAtPath: path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSAlert *alert = [[NSAlert alloc]init];
            [alert addButtonWithTitle:@"ERROR"];
            [alert setMessageText:@"创建文件出错！"];
            [alert setInformativeText:[NSString stringWithFormat:@"创建文件出错\n%@",path]];
            [alert setAlertStyle:NSAlertStyleInformational];
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                NSLog(@"END!");
                return ;
            }];
        }
        NSLog(@"error = %@",error);
        NSLog(@"isSiccess = %d",isSuccess);
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (tag == 500) {
            // 第一种对比方式  对比同一个数组
            NSString *filePath = [NSString stringWithFormat:@"%@/%@_Reslut.txt",path,[NSDate date].description];
            for (int i = 0; i < self.pathArray1.count; ++i) {
                for (int j = i + 1; j < self.pathArray1.count; ++j) {
                    @autoreleasepool {
                        NSImage *image1 = [[NSImage alloc] initWithContentsOfFile:self.pathArray1[i]];
                        NSImage *image2 = [[NSImage alloc] initWithContentsOfFile:self.pathArray1[j]];
                        NSData *data1 = [image1 TIFFRepresentation];
                        NSData *data2 = [image2 TIFFRepresentation];
                        if ([data1 isEqual:data2]) {
                            NSString *str = [NSString stringWithFormat:@"%@\nAND\n%@\n一样\n",self.pathArray1[i],self.pathArray1[j]];
                            NSLog(@"%@\n",str);
                            [self.result1 addObject:str];
                        }
                    }
                }
                
            }
            __block NSString *message;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.process1 stopAnimation:nil];
                //写入文件
                if ([fileManager isExecutableFileAtPath:filePath]) {
                    [self.result1 writeToFile:filePath atomically:YES];
                    message = @"写入文件成功！";
                } else {
                    if([fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
                        [self.result1 writeToFile:filePath atomically:YES];
                        message = @"写入文件成功！";
                    } else {
                        message = @"创建文件失败！";
                    }
                }
 
                NSAlert *alert = [[NSAlert alloc]init];
                [alert addButtonWithTitle:@"OK"];
                [alert setMessageText:@"对比完成！"];
                [alert setInformativeText:[NSString stringWithFormat:@"%@内的图片对比完成\n %@",self.pathLabel.stringValue,message]];
                [alert setAlertStyle:NSAlertStyleInformational];
                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                    NSLog(@"END!");
                    weakSelf.textField.stringValue = filePath;
                }];
            });
        } else if (tag == 600) {
            // 第二中对比  对比两个数组
            NSString *filePath = [NSString stringWithFormat:@"%@/%@_Reslut2.txt",path,[NSDate date].description];
            for (int i = 0; i < self.pathArray1.count; ++i) {
                for (int j = 0; j < self.pathArray2.count; ++j) {
                    @autoreleasepool {
                        NSImage *image1 = [[NSImage alloc] initWithContentsOfFile:self.pathArray1[i]];
                        NSImage *image2 = [[NSImage alloc] initWithContentsOfFile:self.pathArray2[j]];
                        NSData *data1 = [image1 TIFFRepresentation];
                        NSData *data2 = [image2 TIFFRepresentation];
                        if ([data1 isEqual:data2]) {
                            NSString *str = [NSString stringWithFormat:@"\n%@\nAND\n%@\n一样\n",self.pathArray1[i],self.pathArray2[j]];
                            NSLog(@"%@\n",str);
                            [self.result2 addObject:str];
                        }
                    }
                }
            }
            __block NSString *message;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.process1 stopAnimation:nil];
                if ([fileManager isExecutableFileAtPath:filePath]) {
                    [self.result2 writeToFile:filePath atomically:YES];
                    message = @"写入文件成功！";
                } else {
                    if([fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
                        [self.result2 writeToFile:filePath atomically:YES];
                        message = @"写入文件成功！";
                    } else {
                        message = @"创建文件失败！";
                    }
                }
                NSAlert *alert = [[NSAlert alloc]init];
                [alert addButtonWithTitle:@"OK"];
                [alert setMessageText:@"对比完成！"];
                [alert setInformativeText:[NSString stringWithFormat:@"%@  AND   %@ 的图片对比完成\n%@",self.pathLabel.stringValue,self.pathLabel2.stringValue,message]];
                [alert setAlertStyle:NSAlertStyleInformational];
                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                    NSLog(@"END!");
                    weakSelf.textField.stringValue = filePath;
                }];
            });
        }
    });

}


#pragma mark - dataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  
    if (tableView.tag == 10000) {
        return self.pathArray1.count;
    } else if (tableView.tag == 20000) {
        return self.pathArray2.count;
    }else {
        return 0;
    }
    
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"PathCellID" owner:self];
    NSString *pathString;
    if (tableView.tag == 10000) {
        pathString = self.pathArray1[row];
    } else if(tableView.tag == 20000) {
        pathString = self.pathArray2[row];
    } else {
        return [NSView new];
    }
    if (cell) {
        cell.textField.stringValue = pathString ?: @"";
    }
    return cell;
}

- (NSMutableArray *)result1 {
    
    if (!_result1) {
        _result1 = [NSMutableArray array];
    }
    return _result1;
}

-(NSMutableArray *)result2 {
    
    if (!_result2) {
        _result2 = [NSMutableArray array];
    }
    return _result2;
}
@end
