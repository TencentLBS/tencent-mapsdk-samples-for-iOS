//
//  ShowsPoiViewController.m
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/23.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "ShowsPoiViewController.h"

@implementation ShowsPoiViewController

#pragma mark - Override

- (void)handleTestAction
{
    self.mapView.showsPoi = !self.mapView.showsPoi;
}

- (NSString *)testTitle
{
    return @"标注开关";
}

@end
