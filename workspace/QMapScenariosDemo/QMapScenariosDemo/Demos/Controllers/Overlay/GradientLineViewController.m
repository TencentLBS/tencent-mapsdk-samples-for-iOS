//
//  GradientLineViewController.m
//  QMapScenariosDemo
//
//  Created by halldwang on 2024/11/12.
//

#import "GradientLineViewController.h"
#import <QMapKit/QMSSearchKit.h>



@interface GradientLineViewController ()

@property (nonatomic, strong) QPolyline *testLine;

@end

@implementation GradientLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpPolyline];
    
    [self.mapView setVisibleMapRect:self.testLine.boundingMapRect edgePadding:UIEdgeInsetsZero animated:YES];
}

- (NSArray *)generateSeg
{
    NSArray *colors = [NSArray arrayWithObjects:[UIColor greenColor],[UIColor yellowColor],[UIColor redColor],[UIColor blackColor], [UIColor blueColor], nil];
    NSMutableArray *seg = [[NSMutableArray alloc] init];
    

    int poinCount = (int)self.testLine.pointCount;
    
    for (int i = 0; i < poinCount - 1; i ++)
    {
        QSegmentColor *segColor = [[QSegmentColor alloc] init];
        segColor.startIndex = i;
        segColor.endIndex = i + 1;
        segColor.color = colors[i];
        NSLog(@" i %d, %@",  i , colors[arc4random() % 5]);
        [seg addObject:segColor];
    }
    return seg;
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]])
    {
        QTexturePolylineView *render = [[QTexturePolylineView alloc] initWithPolyline:overlay];
        render.lineWidth = 10;
        render.drawType = QTextureLineDrawType_ColorLine;
        // 分段颜色
        NSArray *sg = [self generateSeg];
        render.segmentColor = sg;
        render.drawSymbol = YES;
        // 是否使用渐变
        render.useGradient = YES;
        
        return render;
        
    }
    
    return nil;
}

- (void)setUpPolyline
{
    /* Polyline 1. */
    CLLocationCoordinate2D polylineCoords[6];
    polylineCoords[0].latitude = 39.984864;
    polylineCoords[0].longitude = 116.305756;
    
    polylineCoords[1].latitude = 39.983618;
    polylineCoords[1].longitude = 116.305848;
    
    polylineCoords[2].latitude = 39.982347;
    polylineCoords[2].longitude = 116.305966;
    
    polylineCoords[3].latitude = 39.982412;
    polylineCoords[3].longitude = 116.308111;
    
    polylineCoords[4].latitude = 39.984122;
    polylineCoords[4].longitude = 116.308224;
    
    polylineCoords[5].latitude = 39.984955;
    polylineCoords[5].longitude = 116.308099;
    
    self.testLine = [[QPolyline alloc] initWithCoordinates:polylineCoords count:6];
    [self.mapView addOverlay:self.testLine];
    
}

@end

