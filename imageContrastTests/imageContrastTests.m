//
//  imageContrastTests.m
//  imageContrastTests
//
//  Created by zhangbin on 2018/3/8.
//  Copyright © 2018年 vvex. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VVEXFileSearch.h"

@interface imageContrastTests : XCTestCase

@property (nonatomic, strong) VVEXFileSearch *fileSearch;
@end

@implementation imageContrastTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.fileSearch = [[VVEXFileSearch alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.fileSearch = nil;
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    NSLog(@"%%%%%%%%%%");
//}

- (void)testSearchFiles {

    [self.fileSearch showAllFileWithPath:@"/Users/zhangbin/Documents/Project/Allinmd/2.0/AllinmdIPhone" withSuffix:@".png"];
    XCTAssertTrue(self.fileSearch.mArray.count > 0, @"查不到图片");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.

    }];
    NSLog(@"##########");
}

@end
