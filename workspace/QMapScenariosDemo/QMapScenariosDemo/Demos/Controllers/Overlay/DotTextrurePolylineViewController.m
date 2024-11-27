//
//  DotTextrurePolylineViewController.m
//  QMapScenariosDemo
//
//  Created by KeithCao on 2024/11/27.
//

#import "DotTextrurePolylineViewController.h"

@interface DotTextrurePolylineViewController () <QMapViewDelegate>

@end

@implementation DotTextrurePolylineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    [self addDotPolyline];
}

- (void)addDotPolyline{
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
    
    QPolyline *line = [[QPolyline alloc] initWithCoordinates:polylineCoords count:6];
    [self.mapView addOverlay:line];
    
    [self.mapView setVisibleMapRect:line.boundingMapRect animated:YES];
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay {
    if ([overlay isKindOfClass:QPolyline.class]) {
        QPolyline *polyline = (QPolyline *)overlay;
        QTexturePolylineView *render = [[QTexturePolylineView alloc] initWithPolyline:polyline];
        render.displayLevel = QOverlayLevelAboveBuildings;
        render.drawType = QTextureLineDrawType_FootPrint;   // 脚印线绘制-》以足迹的形式重复绘制整个图片
        render.lineWidth = 10;
        render.styleTextureImage = [UIImage imageNamed:@"color_point_texture.png"]; // 纹理图片，传如自定义的圆点图片
        render.footprintStep = render.styleTextureImage.size.width / 2; // 纹理图片的间隔
        NSMutableArray<QSegmentStyle*> *styles = [NSMutableArray array];
        
        // 配置线段的下标
        QSegmentStyle *style = [[QSegmentStyle alloc] init];
        style.startIndex = 0;
        style.endIndex = (int)(polyline.pointCount - 1);
        
        [styles addObject:style];
        
        render.segmentStyle = styles;
        
        return render;
    }
    
    return nil;
}

@end
