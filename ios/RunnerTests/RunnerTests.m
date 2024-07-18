//
//  RunnerTests.m
//  RunnerTests
//
//  Created by Mootaz Bahri on 18.07.24.
//
@import XCTest;
@import integration_test;
INTEGRATION_TEST_IOS_RUNNER(RunnerTests)

#import <XCTest/XCTest.h>

@interface RunnerTests : XCTestCase

@end

@implementation RunnerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
