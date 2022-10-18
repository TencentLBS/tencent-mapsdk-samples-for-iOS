//
//  LimitMapRectViewController.m
//  QMapScenarioDemo
//
//  Created by Zhang Tian on 2019/9/23.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "LimitMapRectViewController.h"

@implementation LimitMapRectViewController

#pragma mark - Helper

- (QMapRect)getMapRect
{
    // 故宫.
    QMapPoint points[2];
    points[0] = QMapPointForCoordinate(CLLocationCoordinate2DMake(39.922804, 116.391735));
    points[1] = QMapPointForCoordinate(CLLocationCoordinate2DMake(39.913390, 116.402330));
    
    return QBoundingMapRectWithPoints(points, 2);
}

#pragma mark - Action

- (void)handleLimitZoomLevel
{
    /**
     *  设置限定区域后, 地图会以所传入的区域的最小可展示级别作为地图的最小显示级别, 地图显示级别不会小于该级别.
     *  如: 传入的区域的最小显示级别为 16, 则地图的最小显示级别为 16.
     *  用户可以搭配 setMinZoomLevel: maxZoomLevel: 接口进行地图的最小, 最大显示级别调整.
     */
    [self.mapView setMinZoomLevel:16 maxZoomLevel:self.mapView.maxZoomLevel];
}

- (void)handleCancelLimitMapRect
{
    // 当传入的 mapRect 的四个值为 0 时, 可取消区域限制(两种模式下都可行).
    QMapRect cancelRect = QMapRectMake(0, 0, 0, 0);
    [self.mapView setLimitMapRect:cancelRect mode:QMapLimitRectFitWidth];
    
    // 恢复地图最小最大级别.
    [self.mapView setMinZoomLevel:3 maxZoomLevel:self.mapView.maxZoomLevel];
}

- (void)handleFitWidthMode
{
    QMapRect rect = [self getMapRect];
    
    // 传入对应的区域进行限制, 以区域宽度为参考值.
    [self.mapView setLimitMapRect:rect mode:QMapLimitRectFitWidth];
}


- (void)handleFitHeightMode
{
    QMapRect rect = [self getMapRect];
    
    // 传入对应的区域进行限制, 以区域高度为参考值.
    [self.mapView setLimitMapRect:rect mode:QMapLimitRectFitHeight];
}

#pragma mark - QMapViewDelegate

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id <QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolygon class]])
    {
        QPolygonView *render = [[QPolygonView alloc] initWithPolygon:overlay];
        render.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.2];
        render.lineWidth = 1;
        render.strokeColor = [UIColor redColor];
        return render;
    }
    
    return nil;
}

#pragma mark - Setup

- (void)setupNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *limitZoomItem = [[UIBarButtonItem alloc] initWithTitle:@"限制级别"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(handleLimitZoomLevel)];
    
    UIBarButtonItem *fitHeightItem = [[UIBarButtonItem alloc] initWithTitle:@"等高"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(handleFitHeightMode)];
    
    UIBarButtonItem *fitWidthItem  = [[UIBarButtonItem alloc] initWithTitle:@"等宽"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(handleFitWidthMode)];
    
    UIBarButtonItem *cancelItem    = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(handleCancelLimitMapRect)];
    
    self.navigationItem.rightBarButtonItems = @[limitZoomItem, fitHeightItem, fitWidthItem, cancelItem];
}

- (void)setupPolygon
{
    QMapRect rect = [self getMapRect];
    
    CGFloat minx = QMapRectGetMinX(rect);
    CGFloat miny = QMapRectGetMinY(rect);
    CGFloat maxX = QMapRectGetMaxX(rect);
    CGFloat maxY = QMapRectGetMaxY(rect);
    
    QMapPoint pointForPolygon[4];
    pointForPolygon[0] = QMapPointMake(minx, miny);
    pointForPolygon[1] = QMapPointMake(maxX, miny);
    pointForPolygon[2] = QMapPointMake(maxX, maxY);
    pointForPolygon[3] = QMapPointMake(minx, maxY);
    
    QPolygon *polygon = [[QPolygon alloc] initWithPoints:pointForPolygon count:4];
    [self.mapView addOverlay:polygon];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.rotateEnabled = NO;
    self.mapView.overlookingEnabled = NO;
    
    [self setupPolygon];
}

@end
