//
//  fileSearch.h
//  imageContrast
//
//  Created by zhangbin on 2018/3/7.
//  Copyright © 2018年 vvex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVEXFileSearch : NSObject

@property (nonatomic, strong) NSMutableArray *mArray;


/**
 递归读取解压路径下的所有@2x.png文件

 @param path 目录
 */
- (void)showAllFileWithPath:(NSString *)path withSuffix:(NSString *)suffix;

@end
