//
//  TrackViewController.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/6/29.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "TrackViewController.h"
#import <TencentTrackSDK/TencentTrackSDK.h>

// 以下内容需要与客服人员沟通开通
#define kKey @"key"
#define kServiceID @"serviceID"
#define kObjectID @"objID"


@interface TrackViewController () <TencentTrackManagerDelegate>
@property (nonatomic, strong) TencentTrackManager *trackManager;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *historyLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval collectStartTime;
@property (nonatomic, assign) NSTimeInterval collectEndTime;
@property (nonatomic, strong) TencentTrackHistoryTrackRequest *trackRequest;
@property (nonatomic, strong) QPolyline *polyline;
@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self setupTrackManager];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopCollection];
}

- (void)setupSubviews {
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.mapView.bounds.size.width - 20, 40)];
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.backgroundColor = [UIColor whiteColor];
    _locationLabel.text = @"位置采集:";
    [self.mapView addSubview:_locationLabel];
    
    _historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, self.mapView.bounds.size.width - 20, 40)];
    _historyLabel.textAlignment = NSTextAlignmentCenter;
    _historyLabel.backgroundColor = [UIColor whiteColor];
    _historyLabel.text = @"历史采集:";
    [self.mapView addSubview:_historyLabel];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _startButton.frame = CGRectMake(10, _historyLabel.frame.origin.y + _historyLabel.bounds.size.height + 10, _locationLabel.bounds.size.width * 0.5 - 20, 40);
    [_startButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_startButton setTitle:@"开始采集" forState:UIControlStateNormal];
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.mapView addSubview:_startButton];
    [_startButton addTarget:self action:@selector(startCollection) forControlEvents:UIControlEventTouchUpInside];
    
    _stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _stopButton.frame = CGRectMake(_historyLabel.frame.origin.x + _historyLabel.bounds.size.width * 0.5 + 20, _startButton.frame.origin.y, _historyLabel.bounds.size.width * 0.5 - 20, 40);
    [_stopButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [_stopButton setTitle:@"停止采集" forState:UIControlStateNormal];
    [_stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.mapView addSubview:_stopButton];
    [_stopButton addTarget:self action:@selector(stopCollection) forControlEvents:UIControlEventTouchUpInside];
    _stopButton.enabled = NO;
}

- (void)setupTrackManager {
    _trackManager = [[TencentTrackManager alloc] init];
    _trackManager.delegate = self;
    [_trackManager setKey:kKey serviceID:kServiceID objectID:kObjectID];
    // 采集间隔为5s，上传间隔为10s
    [_trackManager setCollectInterval:2 uploadInterval:4];
}

- (void)startCollection {
    [_trackManager startKeepTrack];
    _startButton.enabled = NO;
    _stopButton.enabled = YES;
}

- (void)stopCollection {
    [_trackManager stopKeepTrack];
    _collectEndTime = [[NSDate date] timeIntervalSince1970];
    
    _startButton.enabled = YES;
    _stopButton.enabled = NO;
}


#pragma mark - TrackManager Delegate
/*
 *  @brief  成功采集到定位点回调，可获取该定位点
 */
-(void)trackManager:(TencentTrackManager*)manager didCollectLocation:(CLLocation*)location {
    _locationLabel.text = [NSString stringWithFormat:@"位置采集: %lf, %lf", location.coordinate.latitude, location.coordinate.longitude];
    
    if (_collectStartTime == 0) {
        _collectStartTime = [[NSDate date] timeIntervalSince1970];
    }
}

/*
 *  @brief  采集定位点失败回调，返回错误信息
 */
-(void)trackManager:(TencentTrackManager*)manager didFailToCollectLocationWithError:(NSError*)error {
    _locationLabel.text = @"采集定位点失败";
    NSLog(@"采集定位点失败: %@", error.description);
}

/*
 *  @brief  上传轨迹成功状态回调，可获取上传的状态
 */
-(void)trackManager:(TencentTrackManager*)manager didUploadTrackWithState:(NSInteger)state {
    // 每次更新结束时间
    _collectEndTime = [[NSDate date] timeIntervalSince1970];
    
    // 当第一次上传成功后，开始获取历史轨迹
    if (_timer == nil && state == 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(getHistoryCollection) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

/*
 *  @brief  上传轨迹失败回调
 */
-(void)trackManager:(TencentTrackManager*)manager didFailToUploadTrackWithError:(NSError*)error {
    _locationLabel.text = @"上传定位点失败";
    NSLog(@"上传定位点失败: %@", error.description);
}


#pragma mark - Track History
/*
 获取历史轨迹使用须知：
    1. 采集完毕并上传的点，是手机当前的定位点
    2. 采集点上传完毕后，服务器会根据当前采集的几个点进行纠偏、优化等操作
    3. 从服务器拉取的历史轨迹，是经过纠偏、优化过后的轨迹
    4. 拉取历史轨迹的服务有日调用量、并发限制的，具体请查阅：
            https://lbs.qq.com/service/webService/webServiceGuide/webServiceQuota
 */
- (void)getHistoryCollection {
    if (_trackRequest == nil) {
        _trackRequest = [[TencentTrackHistoryTrackRequest alloc] init];
        _trackRequest.objectID = kObjectID;
    }
    _trackRequest.startTime = _collectStartTime;
    _trackRequest.endTime = _collectEndTime;

    [self.trackManager queryHistoryWithRequest:_trackRequest];
}


/*
 *  @brief  获取轨迹回调，如成功则返回轨迹，失败则返回错误信息
 */
-(void)trackManager:(TencentTrackManager*)manager didReceiveTrack:(TencentTrackHistoryTrackResponse *)track withError:(NSError*)error {
    
    // 解析坐标点
    NSArray *trackLocationArray = track.track;
    
    CLLocationCoordinate2D coords[trackLocationArray.count];
    for (int i = 0; i < trackLocationArray.count; i++) {
        TencentTrackLocation *location = trackLocationArray[i];
        coords[i] = location.coordinate;
    }
    
    if (_polyline != nil) {
        [self.mapView removeOverlay:_polyline];
    }
    _polyline = [[QPolyline alloc] initWithCoordinates:coords count:trackLocationArray.count];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.historyLabel.text = [NSString stringWithFormat:@"历史采集: %lu个点", trackLocationArray.count];
        [self.mapView addOverlay:weakSelf.polyline];
    });
}

- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay {
    if ([overlay isKindOfClass:[QPolyline class]]) {
        QPolylineView *polylineView = [[QPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 5;
        polylineView.strokeColor = [UIColor blueColor];
        
        return polylineView;
    }
    
    return nil;
}

- (void)handleTestAction {

    if (_polyline != nil) {
        [self.mapView setVisibleMapRect:_polyline.boundingMapRect animated:YES];
    }
}

- (NSString *)testTitle {
    return @"调整视角";
}


@end
