# 示例中心

## 基础功能

### 点聚合

#### 使用产品

iOS 地图 SDK

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
QMapView | - (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture | 地图区域改变完成后会调用此接口，需要在此回调中刷新聚合点状态。 |
QMapView | - (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id <QAnnotation>)annotation | 地图添加 Annotation 后点用的接口，根据 Annotation 生成对应的 View，在此回调中对聚合点相关的 View 进行配置。 | 

iOS 地图组件库

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
QMUClusterManager | - (void)addAnnotations:(NSArray*)annos | 添加批量的原始被聚合点。 |
QMUClusterManager | - (void)refreshCluster | 当需要强制重新聚合时调用，如地图产生变化后或者更改聚合配置 distance, threeholdZoomlevel 时需调用该方法刷新聚合点状态。 |

#### 方法讲解

1. 为了实现点聚合功能，首先需要对 `QMUClusterManager` 进行初始化。

	```objc
	- (void)setupClusterManager
	{
	    self.manager = [[QMUClusterManager alloc] initWithMap:self.mapView];
	    
	    self.manager.delegate = self;
	    self.manager.distance = 56;
	}
	```

2. 然后创建聚合点 QMUAnnotation 数组，并且通过 `QMUClusterManager` 类的 'addAnnotations:' 方法添加到地图上。

	```objc
	- (void)addClusters
	{
	    // 创建聚合点数组, 可通过本地文件等方式.
	    NSArray *clusterData = [self loadClusterData];
	    
	    // 添加聚合点数组.
	    [self.manager addAnnotations:clusterData];
	}
	```

3. 在地图的 `viewForAnnotation:` 回调中对聚合点 View 进行配置。

	```objc
	- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
	{
	    if ([annotation isKindOfClass:[QMUClusterAnnotation class]])
	    {
	        QMUClusterAnnotation* clusterAnnotation = (QMUClusterAnnotation*)annotation;
	        
	        if (clusterAnnotation.count > 1)
	        {
	            // 对已经聚合的聚合点的 Annotation View 进行配置.
	            ...
	            
	            return annotationView;
	        }
	        else
	        {
	            // 对单个聚合点的 Annotation View 进行配置.
	            ...
	            
	            return annotationView;
	        }
	    }
	    
	    return nil;
	}
	```

4. 地图视野发生变动时，在视野变化结束的回调中刷新聚合点状态。

	```objc
	- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture
	{
	    [self.manager refreshCluster];
	}
	```

### 设置地图中心点

#### 使用产品

iOS 地图 SDK

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
QMapView | CLLocationCoordinate2D centerCoordinate | 设置地图中心点，改变此值时，地图缩放级别不会改变。 |
QMapView | - (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated | 设置地图中心点以及是否采用动画。 |

#### 方法讲解

1. 设置地图的中心点，带动画。

	```
	[self.mapView setCenterCoordinate:self.userCoordinate animated:YES];
	```

### 限制地图显示范围

#### 使用产品

iOS 地图 SDK

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
QMapView | -(void)setLimitMapRect:(QMapRect)mapRect mode:(QMapLimitRectFitMode)mode | 根据边界留宽显示限制地图区域范围(2D北朝上场景时)，当传入的 mapRect 的值都为0时，取消区域限制。 |

#### 方法讲解

1. 传入一个区域来限制地图视野在该区域范围之内，可设置根据区域高度或者宽度为参考值。

	```objc
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
	```

2. 设置限定区域后，地图会以所传入的区域的最小可展示级别作为地图的最小显示级别，地图显示级别不会小于该级别。用户可以搭配  `setMinZoomLevel:maxZoomLevel:` 接口进行地图的最小，最大显示级别调整。

	```objc
	- (void)handleLimitZoomLevel
	{
	    [self.mapView setMinZoomLevel:16 maxZoomLevel:self.mapView.maxZoomLevel];
	}
	```

3. 如需取消区域限制，传入四个值均为 0 的 mapRect 即可。

	```objc
	- (void)handleCancelLimitMapRect
	{
	    // 当传入的 mapRect 的四个值为 0 时, 可取消区域限制(两种模式下都可行).
	    QMapRect cancelRect = QMapRectMake(0, 0, 0, 0);
	    [self.mapView setLimitMapRect:cancelRect mode:QMapLimitRectFitWidth];
	    
	    // 恢复地图最小最大级别.
	    [self.mapView setMinZoomLevel:3 maxZoomLevel:self.mapView.maxZoomLevel];
	}
	```
	
### 适配Marker显示范围

#### 使用产品

iOS 地图 SDK

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
QGeometry | QBoundingCoordinateRegionWithCoordinates(CLLocationCoordinate2D *coordinates, NSUInteger count) | 根据坐标点返回最小外接 region。 |
QMapView | - (void)setRegion:(QCoordinateRegion)region edgePadding:(UIEdgeInsets)insets animated:(BOOL)animated | 设定当前地图的region

#### 方法讲解

1. 获取需要显示出来的Marker的坐标，并计算最小外界region：

	```objc
	NSUInteger length = self.mapView.annotations.count;
	    
	CLLocationCoordinate2D locations[length];
	for (int i = 0; i < length; i++) {
	QPointAnnotation *annotation = self.mapView.annotations[i];
	locations[i] = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude);
	}
	    
	QCoordinateRegion region = QBoundingCoordinateRegionWithCoordinates(locations, length);
	```

2. 调整地图的视野范围：

	```objc
	[self.mapView setRegion:region edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
	```

## 覆盖物

### 隐藏文字标注

#### 使用产品

iOS 地图 SDK

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
QMapView | BOOL showsPoi | 是否显示底图上的标注及名称，默认为 YES。 | 

#### 方法讲解

1. 切换地图标注是否显示。

```objc
- (void)handleTestAction
{
    self.mapView.showsPoi = !self.mapView.showsPoi;
}
```

## 轨迹处理

### 平滑移动

#### 使用产品

iOS 地图 SDK

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
QMapView | - (void)addAnnotation:(id <QAnnotation>)annotation | 添加小车标记。 |
QMapView | - (void)addOverlay:(id <QOverlay>)overlay | 添加小车轨迹。 |
QMapView | - (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id <QAnnotation>)annotation | 在地图上添加小车的 View。 |
QMapView | - (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id <QOverlay>)overlay | 在地图上添加小车轨迹的 View。 |

iOS 地图组件库

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
QMUAnnotationAnimator | + (void)translateWithAnnotationView:(QAnnotationView *)annotationView locations:(NSArray<id <QMULocation> > *)locations duration:(CFTimeInterval)duration rotateEnabled:(BOOL)needRotate | 执行平滑移动动画，该方法仅支持地图在 2D 正北状态下进行。 |
QMULocation | CLLocationCoordinate2D coordinate | 小车轨迹经纬度点串需支持的协议。 | 

#### 方法讲解

1. 创建小车标记，小车轨迹，并将它们添加到地图上。

2. 调用地图组件库提供的方法进行平滑移动。

	```objc
	- (void)handleTestAction
	{
	    QAnnotationView *annotationView = [self.mapView viewForAnnotation:self.carAnnotation];
	    
	    [QMUAnnotationAnimator translateWithAnnotationView:annotationView locations:self.carLocations duration:360 rotateEnabled:YES];
	}
	```

## 手势操作

### 自定义手势

#### 使用产品

iOS 地图 SDK

类 | 接口 | 说明 | 版本
--- | --- | --- | ---
UIGestureRecognizer | - | 系统手势 | -

#### 方法讲解

1. 创建自定义手势。

	```objc
	- (void)setupLongPressGesture
	{
	    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
	    longPressGestureRecognizer.delegate = self;
	    
	    [self.mapView addGestureRecognizer:longPressGestureRecognizer];
	}
	```

2. 实现手势的处理方法。

	```objc
	-(void)handleLongPressAction:(UIGestureRecognizer *)gestureRecognizer
	{
	    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
	    {
	        CGPoint point = [gestureRecognizer locationInView:self.mapView];
	        
	        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
	        
	        [self addAnnotation:coordinate];
	    }
	}
	```

3. 实现手势回调，设置自定义手势与其他手势可以同时触发。

	```objc
	- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
	{
	    return YES;
	}
	```