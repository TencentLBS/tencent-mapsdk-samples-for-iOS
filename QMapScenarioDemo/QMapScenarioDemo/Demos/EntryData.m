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
//        {
//            Cell *cell = [[Cell alloc] init];
//
//            cell.title = @"地图选点";
//            cell.controllerClassName = @"PickMapPointViewController";
//
//            [cellArray addObject:cell];
//        }
    
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
    
    return entry;
}

@end
