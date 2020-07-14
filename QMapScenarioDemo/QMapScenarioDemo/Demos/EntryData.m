//
//  EntryData.m
//  QMapKitDemoNew
//
//  Created by tabsong on 17/5/11.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "EntryData.h"
#import <QMapKit/QMapKit.h>

@implementation Cell

@end

@implementation Section

@end

@implementation EntryData

+ (instancetype)constructDefaultEntryData
{
    EntryData *entry = [[EntryData alloc] init];
    entry.title = [NSString stringWithFormat:@"示例中心 Demos %@", QMapServices.sharedServices.sdkVersion];
    NSMutableArray<Section *> *sectionArray = [NSMutableArray array];
    entry.sections = sectionArray;
    
    // Base Map Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"基础功能";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 点聚合 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"点聚合";
            cell.controllerClassName = @"PointClusterViewController";
            
            [cellArray addObject:cell];
        }
        // 地图选点 Cell.
        {
            Cell *cell = [[Cell alloc] init];

            cell.title = @"地图选点";
            cell.controllerClassName = @"PickMapPointViewController";

            [cellArray addObject:cell];
        }
    
        // 设置地图中心点 Cell.
        {
            Cell *cell = [[Cell alloc] init];
        
            cell.title = @"设置地图中心点";
            cell.controllerClassName = @"SetMapCenterViewController";
        
            [cellArray addObject:cell];
        }
    
        // 限制地图显示范围 Cell.
        {
            Cell *cell = [[Cell alloc] init];
        
            cell.title = @"限制地图显示范围";
            cell.controllerClassName = @"LimitMapRectViewController";
        
            [cellArray addObject:cell];
        }

        // 根据Marker适配地图显示范围
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"适配marker显示范围";
            cell.controllerClassName = @"ShowMarkersViewController";
            
            [cellArray addObject:cell];
        }
        
        // 调整Marker到地图中心
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"根据边距调整marker显示到地图中央";
            cell.controllerClassName = @"ShowMarkerCenterController";
            
            [cellArray addObject:cell];
        }
        
        // 地理围栏
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"地理围栏";
            cell.controllerClassName = @"GeofencingController";
            
            [cellArray addObject:cell];
        }
    }
    
    // Overlay Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"覆盖物";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 隐藏文字标注 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"隐藏文字标注";
            cell.controllerClassName = @"ShowsPoiViewController";
            
            [cellArray addObject:cell];
        }
        
        // 隐藏3D楼块 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"隐藏3D楼块";
            cell.controllerClassName = @"HideBuildingController";
            
            [cellArray addObject:cell];
        }
        // Marker动画效果 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"Marker动画效果";
            cell.controllerClassName = @"MarkerAnimationController";
            
            [cellArray addObject:cell];
        }
        // 同时显示多个InfoWindow
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"同时显示多个InfoWindow";
            cell.controllerClassName = @"MutiInfoWindowController";
            
            [cellArray addObject:cell];
        }
        // Annotation根据目的地旋转
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"Annotation根据终点位置旋转";
            cell.controllerClassName = @"AnnotationRotateController";
            
            [cellArray addObject:cell];
        }
    }
    
    // Route Animation Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"轨迹处理";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 平滑移动 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"平滑移动";
            cell.controllerClassName = @"SmoothMoveViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    // Gesture Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"手势操作";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 自定义手势 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"自定义手势(长按添加标记)";
            cell.controllerClassName = @"CustomGestureViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    // Location Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"定位";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 定位标跟随手机朝向移动 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"定位标跟随手机朝向移动";
            cell.controllerClassName = @"LocationIconController";
            
            [cellArray addObject:cell];
        }
        // 定位精度圈扩散效果
        {
            Cell *cell = [[Cell alloc] init];

            cell.title = @"定位精度圈扩散效果";
            cell.controllerClassName = @"LocationCircleController";

            [cellArray addObject:cell];
        }
    }
    
    // 物流示例 Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"示例";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 定位标跟随手机朝向移动 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"物流运输地图调整";
            cell.controllerClassName = @"DeliveryController";
            
            [cellArray addObject:cell];
        }
    }
    
    // 轨迹SDK Section.
    {
        Section *section = [[Section alloc] init];
        section.title = @"轨迹SDK";
        NSMutableArray<Cell *> *cellArray = [NSMutableArray array];
        section.cells = cellArray;
        
        [sectionArray addObject:section];
        
        // 定位标跟随手机朝向移动 Cell.
        {
            Cell *cell = [[Cell alloc] init];
            
            cell.title = @"轨迹SDK采集示例";
            cell.controllerClassName = @"TrackViewController";
            
            [cellArray addObject:cell];
        }
    }
    
    return entry;
}

@end
