//
//  DeliveryController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/6/9.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "DeliveryController.h"
#import "DeliveryModel.h"
#import "DeliveryRouteView.h"
#import "DeliveryGoodsModel.h"
#import "DeliveryGoodsView.h"

#define TopViewHeight   44
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define NavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define MapViewHeight   self.mapView.frame.size.height

@interface DeliveryController () <QMSSearchDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *deliveryModelArray;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) QMSSearcher *searcher;

@property (nonatomic, strong) QMSDrivingRouteSearchResult *drivingRouteResult;

@property (nonatomic, strong) QPolylineView *polylineView;

@property (nonatomic, strong) QPointAnnotation *gzAnnotation;
@property (nonatomic, strong) QPointAnnotation *hzAnnotation;
@property (nonatomic, strong) QPointAnnotation *zzAnnotation;
@property (nonatomic, strong) QPointAnnotation *bjAnnotation;
@property (nonatomic, strong) QPointAnnotation *carAnnotation;
@property (nonatomic, strong) QPinAnnotationView *carAnnotationView;

@property (nonatomic, strong) QPolyline *airTransportPolyline;
@property (nonatomic, strong) QPolyline *landTransportPolyline;
@property (nonatomic, strong) QPolyline *unknowTransportPolyline;

@property (nonatomic, strong) QPolylineView *airTransportPolylineView;
@property (nonatomic, strong) QPolylineView *landTransportPolylineView;
@property (nonatomic, strong) QPolylineView *unknowTransportPolylineView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, assign) NSUInteger index;

@end

@implementation DeliveryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单号: TX123FSDAG34GQ52F3";
    
    _index = 0;
    
    [self setupTopView];
    [self setupModel];
    [self setupContentView];
    
    [self setupPolyline];
}

- (void)setupModel {
    _deliveryModelArray = [NSMutableArray array];
    
    DeliveryModel *route1 = [[DeliveryModel alloc] init];
    route1.origin = @"广州市";
    route1.destination = @"杭州市";
    route1.firstStep = YES;
    route1.time = 3;
    
    DeliveryModel *route2 = [[DeliveryModel alloc] init];
    route2.origin = @"杭州市";
    route2.destination = @"郑州市";
    route2.time = 13;
    
    DeliveryModel *route3 = [[DeliveryModel alloc] init];
    route3.origin = @"郑州市";
    route3.destination = @"北京市";
    route3.time = 0;
    
    [_deliveryModelArray  addObject:route1];
    [_deliveryModelArray  addObject:route2];
    [_deliveryModelArray  addObject:route3];
    
    for (int i = 0; i < 15; i++) {
        DeliveryGoodsModel *model = [[DeliveryGoodsModel alloc] init];
        [_deliveryModelArray addObject:model];
    }
}

/*
 路线模拟：
    广州 -> 杭州 -> 郑州 -> 北京
        广州：23.129112, 113.264385
        杭州：30.245853, 120.209947
        郑州：34.746303, 113.625351
        北京：39.904179, 116.407387
    1. 折线(空运)：广州 -> 杭州              两个坐标点构成的polyline
    2. 不规则曲线(陆运)：杭州 -> 郑州         杭州到郑州的驾车路线规划
    3. 虚线：郑州 -> 北京                   郑州到北京的texturePolyline
 */

#pragma mark - Setup Poyline
- (void)setupPolyline {
    [self landTransport];
}

// 折线(空运)：广州 -> 杭州
- (void)airTransport {
    CLLocationCoordinate2D coords[2];
    coords[0] = CLLocationCoordinate2DMake(23.129112, 113.264385);
    coords[1] = CLLocationCoordinate2DMake(30.245853, 120.209947);
    
    _airTransportPolyline = [QPolyline polylineWithCoordinates:coords count:2];
    
    [self.mapView addOverlay:_airTransportPolyline];
}

// 不规则曲线(陆运)：杭州 -> 郑州
- (void)landTransport {
    self.searcher = [[QMSSearcher alloc] initWithDelegate:self];
    
    QMSDrivingRouteSearchOption *drivingOpt = [[QMSDrivingRouteSearchOption alloc] init];
    [drivingOpt setPolicyWithType:QMSDrivingRoutePolicyTypeLeastTime];
    [drivingOpt setFrom:@"30.245853,120.209947"];
    [drivingOpt setTo:@"34.746303,113.625351"];

    [self.searcher searchWithDrivingRouteSearchOption:drivingOpt];
}

// 虚线：郑州 -> 北京
- (void)unknowTransport {
    CLLocationCoordinate2D coords[2];
    coords[0] = CLLocationCoordinate2DMake(34.746303, 113.625351);
    coords[1] = CLLocationCoordinate2DMake(39.904179, 116.407387);
    
    _unknowTransportPolyline = [QPolyline polylineWithCoordinates:coords count:2];
    
    [self.mapView addOverlay:_unknowTransportPolyline];
}

#pragma mark - Search Result
- (void)searchWithDrivingRouteSearchOption:(QMSDrivingRouteSearchOption *)drivingRouteSearchOption didRecevieResult:(QMSDrivingRouteSearchResult *)drivingRouteSearchResult {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.drivingRouteResult = drivingRouteSearchResult;
        
        // 取出第一个路线
        QMSRoutePlan *plan = self.drivingRouteResult.routes.firstObject;
        
        // 画线
        CLLocationCoordinate2D coords[plan.polyline.count];
        
        for (int i = 0; i < plan.polyline.count; i++) {
            CLLocationCoordinate2D coordinate;
            NSValue *value = plan.polyline[i];
            [value getValue:&coordinate];
            
            coords[i] = coordinate;
        }
        
        weakSelf.landTransportPolyline = [QPolyline polylineWithCoordinates:coords count:plan.polyline.count];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupAnnotation];
            [self airTransport];
            [self unknowTransport];
            [self.mapView addOverlay:weakSelf.landTransportPolyline];
        });
    });
    
}


#pragma mark - Setup Annotation
- (void)setupAnnotation {
    // 广州
    _gzAnnotation = [[QPointAnnotation alloc] init];
    _gzAnnotation.coordinate = CLLocationCoordinate2DMake(23.129112, 113.264385);
    // 杭州
    _hzAnnotation = [[QPointAnnotation alloc] init];
    _hzAnnotation.coordinate = CLLocationCoordinate2DMake(30.245853, 120.209947);
    // 郑州
    _zzAnnotation = [[QPointAnnotation alloc] init];
    _zzAnnotation.coordinate = CLLocationCoordinate2DMake(34.746303, 113.625351);
    // 北京
    _bjAnnotation = [[QPointAnnotation alloc] init];
    _bjAnnotation.coordinate = CLLocationCoordinate2DMake(39.904179, 116.407387);
    
    [self.mapView addAnnotations:@[_gzAnnotation, _hzAnnotation, _zzAnnotation, _bjAnnotation]];
    
    _carAnnotation = [[QPointAnnotation alloc] init];
    _carAnnotation.coordinate = CLLocationCoordinate2DMake(23.129112, 113.264385);
    [self.mapView addAnnotation:_carAnnotation];
    
    [self annotationRotate];
}

#pragma mark - MapView Delegate
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    static NSString *reuseId = @"Location Id";
    static NSString *carId = @"Car Id";
    
    if (annotation == _carAnnotation) {
        _carAnnotationView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:carId];
        if (_carAnnotationView == nil) {
            _carAnnotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:carId];
            _carAnnotationView.image = [UIImage imageNamed:@"car"];
            
        }
        return _carAnnotationView;
    } else {
        QPinAnnotationView *pinView = (QPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (pinView == nil) {
            pinView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
            pinView.image = [UIImage imageNamed:@"redPin"];
        }
        return pinView;
    }
    
    return nil;
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay {
    if ([overlay isKindOfClass:[QPolyline class]]) {
        
        if (overlay == _airTransportPolyline) {
            _airTransportPolylineView = [[QPolylineView alloc] initWithPolyline:_airTransportPolyline];
            _airTransportPolylineView.lineWidth = 5;
            _airTransportPolylineView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
            
            return _airTransportPolylineView;
        }
        else if (overlay == _landTransportPolyline) {
            _landTransportPolylineView = [[QPolylineView alloc] initWithPolyline:_landTransportPolyline];
            _landTransportPolylineView.lineWidth = 5;
            _landTransportPolylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.7];
            
            return _landTransportPolylineView;
        }
        else if (overlay == _unknowTransportPolyline) {
            _unknowTransportPolylineView = [[QPolylineView alloc] initWithPolyline:_unknowTransportPolyline];
            _unknowTransportPolylineView.lineWidth = 5;
            _unknowTransportPolylineView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
            _unknowTransportPolylineView.lineDashPattern = @[@10, @10];
            
            return _unknowTransportPolylineView;
        }
    }
    
    return nil;
}

- (void)mapViewInitComplete:(QMapView *)mapView {
    [self resizeMapRect];
}

#pragma mark - TopView
- (void)setupTopView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 80)];
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.layer.cornerRadius = 5;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = [UIImage imageNamed:@"goods"];
    headImageView.frame = CGRectMake(10, 0, 50, 50);
    headImageView.center = CGPointMake(headImageView.center.x, _topView.bounds.size.height * 0.5);
    [_topView addSubview:headImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"腾讯速运";
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(headImageView.frame.origin.x + headImageView.bounds.size.width + 5, headImageView.frame.origin.y, nameLabel.bounds.size.width, nameLabel.bounds.size.height);
    [_topView addSubview:nameLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    titleLabel.text = @"Tencent标准快递: 1142849198231";
    titleLabel.frame = CGRectMake(headImageView.frame.origin.x + headImageView.bounds.size.width + 5, nameLabel.bounds.size.height + nameLabel.frame.origin.y + 10, _topView.bounds.size.width - 20, 20);
    [_topView addSubview:titleLabel];
    
    [self.view addSubview:_topView];
}

#pragma mark - ContentView
- (void)setupContentView {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentView];
    
    // 轨迹路线
    CGFloat routeViewHeight = 80;
    CGFloat goodsViewHeight = 160;
    CGFloat margin = 10;
    CGFloat goodsViewY = routeViewHeight * 3 + margin * 3;
    CGFloat lastViewY = 0.0;
    
    for (int i = 0; i < _deliveryModelArray.count; i++) {
        if ([_deliveryModelArray[i] isKindOfClass:[DeliveryModel class]]) {
            DeliveryRouteView *routeView = [[DeliveryRouteView alloc] init];
            routeView.model = _deliveryModelArray[i];
            routeView.frame = CGRectMake(0, (routeViewHeight + margin) * i , ScreenWidth, routeViewHeight);
            routeView.backgroundColor = [UIColor whiteColor];
            [_contentView addSubview:routeView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(routeViewClicked:)];
            [routeView addGestureRecognizer:tap];
        } else {
            DeliveryGoodsView *goodsView = [[DeliveryGoodsView alloc] init];
            goodsView.backgroundColor = [UIColor whiteColor];
            goodsView.model = _deliveryModelArray[i];
            goodsView.frame = CGRectMake(0, goodsViewY + goodsViewHeight * (i - 3), ScreenWidth, goodsViewHeight);
            [_contentView addSubview:goodsView];
            
            if (i == _deliveryModelArray.count - 1) {
                lastViewY = goodsView.frame.origin.y + goodsViewHeight;
            }
        }
    }
    
    _contentView.frame = CGRectMake(0, MapViewHeight - MapViewHeight * 0.2, ScreenWidth, lastViewY);
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [_contentView addGestureRecognizer:pan];
}

- (void)routeViewClicked:(UITapGestureRecognizer *)tap {
    DeliveryRouteView *routeView = (DeliveryRouteView *)tap.view;
    if ([routeView.model.origin isEqualToString:@"广州市"]) {
        _index = 2;
        [self handleTestAction];
    } else if ([routeView.model.origin isEqualToString:@"杭州市"]) {
        _index = 0;
        [self handleTestAction];
    } else {
        _index = 1;
        [self handleTestAction];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    CGPoint point = [pan translationInView:self.view];
    
    if (_contentView.frame.origin.y + point.y <= -(_contentView.bounds.size.height - MapViewHeight) ||
        _contentView.frame.origin.y + point.y >= MapViewHeight - 100) {
        
        [self resizeMapRect];
        return;
    }
    
    _contentView.center = CGPointMake(_contentView.center.x, _contentView.center.y + point.y);

    [pan setTranslation:CGPointZero inView:self.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self resizeMapRect];
    }
    
    CGFloat limitHeight = 300;
    if (self.contentView.frame.origin.y < limitHeight) {
        // 控制alpha
        self.mapView.alpha = 1 - ((limitHeight - self.contentView.frame.origin.y) / limitHeight);
    } else {
        self.mapView.alpha = 1;
    }
}

#pragma mark - ResizeMapRect
- (void)resizeMapRect {
    // 获取三个点的坐标
    
    QMapPoint points[4];
    // 广州
    points[0] = QMapPointForCoordinate(CLLocationCoordinate2DMake(23.129112, 113.264385));
    // 杭州
    points[1] = QMapPointForCoordinate(CLLocationCoordinate2DMake(30.245853, 120.209947));
    // 郑州
    points[2] = QMapPointForCoordinate(CLLocationCoordinate2DMake(34.746303, 113.625351));
    // 北京
    points[3] = QMapPointForCoordinate(CLLocationCoordinate2DMake(39.904179, 116.407387));
    
    QMapRect mapRect = QBoundingMapRectWithPoints(points, 4);
    
    QMapRect newMapRect = [self.mapView mapRectThatFits:mapRect edgePadding:UIEdgeInsetsMake(40 + _topView.frame.origin.y + _topView.bounds.size.height, 0, self.view.bounds.size.height - _contentView.frame.origin.y + 20, 0)];
    
    if (!QMapRectEqualToRect(mapRect, newMapRect)) {
        [self.mapView setVisibleMapRect:newMapRect edgePadding:UIEdgeInsetsZero animated:YES];
    }
}


#pragma mark RotateAnnotation
- (void)annotationRotate {
    // 取出终点坐标位置
    CLLocationCoordinate2D toCoord = _bjAnnotation.coordinate;
    
    double fromLat = _carAnnotation.coordinate.latitude;
    double fromlon = _carAnnotation.coordinate.longitude;
    double toLat = toCoord.latitude;
    double tolon = toCoord.longitude;

    double slope = ((toLat - fromLat) / (tolon - fromlon));
    
    double radio = atan(slope);
    double angle = 180 * (radio / M_PI);
    if (slope > 0) {
        if (tolon < fromlon) {
            angle = -90 - angle;
        } else {
            angle = 90 - angle;
        }
    } else if (slope == 0) {
        if (tolon < fromlon) {
            angle = -90;
        } else {
            angle = 90;
        }
    } else {
        if (toLat < fromLat) {
            angle = 90 - angle;
        } else {
            angle = -90 - angle;
        }
    }
    
    _carAnnotationView.transform = CGAffineTransformMakeRotation((M_PI * (angle) / 180.0));
}

- (void)handleTestAction {
    _index++;
    
    if (_index == self.mapView.annotations.count - 2) {
        _index = 0;
    }
    
    if (_index > self.mapView.annotations.count)
    {
        return;
    }
    
    QPointAnnotation *annotation = self.mapView.annotations[_index];
    
    _carAnnotation.coordinate = annotation.coordinate;
    
    [self annotationRotate];
}

- (NSString *)testTitle {
    return @"小车方向";
}

@end
