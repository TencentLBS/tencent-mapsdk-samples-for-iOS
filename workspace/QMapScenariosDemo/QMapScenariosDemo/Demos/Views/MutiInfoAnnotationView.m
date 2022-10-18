//
//  MutiInfoAnnotationView.m
//  QMapScenarioDemo
//
//  Created by v_hefang on 2020/5/21.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "MutiInfoAnnotationView.h"
#import "MutiInfoAnnotation.h"
#import "TitleInfoWindowView.h"
#import "ImageInfoWindowView.h"

@interface MutiInfoAnnotationView ()
@property (nonatomic, strong) UIView *infoWindow;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLbael;
@property (nonatomic, strong) MutiInfoAnnotation *mutiAnnotation;
@property (nonatomic, strong) ImageInfoWindowView *imageInfoWindow;
@property (nonatomic, strong) TitleInfoWindowView *titleInfoWindow;
@end

@implementation MutiInfoAnnotationView

- (id)initWithAnnotation:(MutiInfoAnnotation *)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithAnnotation:annotation
                         reuseIdentifier:reuseIdentifier]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        [self setupInfoWindowWithAnnotation:annotation];
    }
    return self;
}

- (void)setupInfoWindowWithAnnotation:(MutiInfoAnnotation *)annotation {
    _mutiAnnotation = annotation;
    
    if (annotation.isImageInfoWindow) {
        _imageInfoWindow = [[ImageInfoWindowView alloc] init];
        [self addSubview:_imageInfoWindow];
    } else {
        _titleInfoWindow = [[TitleInfoWindowView alloc] init];
        _titleInfoWindow.title = annotation.title;
        _titleInfoWindow.subtitle = annotation.subtitle;
        [self addSubview:_titleInfoWindow];
    }
}

- (void)handleTap {
    if (_isCanShowInfoWindow) {
        if (_titleInfoWindow) {
            [_titleInfoWindow presentInfoWindowInView:self];
        } else {
            [_imageInfoWindow presentInfoWindowInView:self];            
        }
    }
    
    [self.superview bringSubviewToFront:self];
}



@end
