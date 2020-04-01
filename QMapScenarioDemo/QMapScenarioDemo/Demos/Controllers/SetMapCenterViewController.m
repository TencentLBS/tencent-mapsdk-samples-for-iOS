//
//  SetMapCenterViewController.m
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/22.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "SetMapCenterViewController.h"

static const NSInteger kCenterNameArrayCount = 5;

static NSString *const kCenterNameArray[kCenterNameArrayCount] =
{
    @"北京腾讯总部大厦",
    @"北京市",
    @"上海市",
    @"广州市",
    @"深圳市"
};

static const CLLocationCoordinate2D kCenterCoordinateArray[kCenterNameArrayCount] =
{
    {40.040415,116.273511},
    {39.907629,116.408386},
    {31.233940,121.478577},
    {23.130257,113.266296},
    {22.545538,114.062805}
};

@interface SetMapCenterViewController ()

@property (nonatomic, assign) CLLocationCoordinate2D userCoordinate;

@end

@implementation SetMapCenterViewController

#pragma mark - Override

- (void)handleTestAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择需要切换的中心点" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    for (int i = 0; i < kCenterNameArrayCount; i++)
    {
        [alertController addAction:[UIAlertAction actionWithTitle:kCenterNameArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            // 设置地图中心点.
            [self.mapView setCenterCoordinate:kCenterCoordinateArray[i] animated:YES];
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"当前定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self.mapView setCenterCoordinate:self.userCoordinate animated:YES];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)testTitle
{
    return @"切换中心点";
}

#pragma mark - QMapViewDelegate

- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation fromHeading:(BOOL)fromHeading
{
    self.userCoordinate = userLocation.location.coordinate;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
}

@end
