//
//  fileSearch.m
//  imageContrast
//
//  Created by zhangbin on 2018/3/7.
//  Copyright © 2018年 vvex. All rights reserved.
//

#import "VVEXFileSearch.h"

@interface VVEXFileSearch()



@end

@implementation VVEXFileSearch

- (NSArray*) allFilesAtPath:(NSString*) dirString {
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    for (NSString* fileName in tempArray) {
        
        BOOL flag = YES;
        
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
    
}

//递归读取解压路径下的所有@2x.png文件
- (void)showAllFileWithPath:(NSString *)path withSuffix:(NSString *)suffix {
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString * subPath = nil;
            for (NSString * str in dirArray) {
                subPath  = [path stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                [self showAllFileWithPath:subPath withSuffix:suffix];
            }
        }else{
            NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
            if ([fileName hasSuffix:suffix]) {
                [self.mArray addObject:path];
            }
        }
    }else{
        NSLog(@"this path is not exist!");
    }
}


//递归读取解压路径下的所有@2x.png文件
- (void)showAllPiceFileWithPath:(NSString *)path {
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString * subPath = nil;
            for (NSString * str in dirArray) {
                subPath  = [path stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                [self showAllPiceFileWithPath:subPath];
            }
        }else{
            NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
            if ([fileName hasSuffix:@".png"]
                || [fileName hasSuffix:@".svg"]
                || [fileName hasSuffix:@".jpg"]
                ) {
                [self.mArray addObject:path];
            }
        }
    }else{
        NSLog(@"this path is not exist!");
    }
}

- (NSMutableArray *)mArray {
    
    if (!_mArray) {
        _mArray = [NSMutableArray array];
    }
    return _mArray;
}

@end
