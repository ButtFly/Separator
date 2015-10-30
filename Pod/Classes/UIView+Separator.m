//
//  UIView+Separator.m
//  Separator
//
//  Created by 余河川 on 15/10/21.
//  Copyright © 2015年 余河川. All rights reserved.
//

#import "UIView+Separator.h"
#import <objc/runtime.h>




#pragma mark - LYSeparatorUpdateDelegate
@protocol LYSeparatorUpdateDelegate <NSObject>

- (void)separatorDidUpdate:(LYSeparatorDescription *)separator;

@end












/**
 *  table 分割线 颜色
 */
#define LYTableSeparatorColor [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]

#pragma mark - LYSeparatorDescription
@interface LYSeparatorDescription()

@property (nonatomic, weak) id<LYSeparatorUpdateDelegate> delegate;

@end

@implementation LYSeparatorDescription

+ (instancetype)separatorWithName:(NSString *)name {
    
    LYSeparatorDescription *obj = [LYSeparatorDescription new];
    if (obj) {
        obj->_name = name;
    }
    return obj;
    
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self->_name = @"_LYSeparatorDescription_";
        self.lineWidth = 0.5;
        self.stokeColor = LYTableSeparatorColor;
        self.stokeStart = 0;
        self.stokeEnd = 1;
        self.relation = LYSeparatorHorizontalBottomSpace;
        self.constant = 0;
        self.instanceCount = 1;
        self.instanceTransform = CATransform3DIdentity;
        
    }
    return self;
    
}

- (void)setConstant:(CGFloat)constant {
    
    _constant = constant;
    [self callDelegateUpdate];
    
}

- (void)setRelation:(LYSeparatorRelation)relation {
    
    _relation = relation;
    [self callDelegateUpdate];
    
}

- (void)setStokeStart:(CGFloat)stokeStart {
    
    _stokeStart = stokeStart;
    [self callDelegateUpdate];
    
}

- (void)setStokeEnd:(CGFloat)stokeEnd {
    
    _stokeEnd = stokeEnd;
    [self callDelegateUpdate];
    
}

- (void)setStokeColor:(UIColor *)stokeColor {
    
    _stokeColor = stokeColor ?: LYTableSeparatorColor;
    [self callDelegateUpdate];
    
}

- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineWidth = lineWidth;
    [self callDelegateUpdate];
    
}


- (void)setStokePath:(UIBezierPath *)stokePath {
    
    _stokePath = stokePath;
    [self callDelegateUpdate];
    
}

- (void)setCustomView:(UIView *)customView {
    
    _customView = customView;
    [self callDelegateUpdate];
    
}

- (void)callDelegateUpdate {
    
    if ([_delegate respondsToSelector:@selector(separatorDidUpdate:)]) {
        [_delegate separatorDidUpdate:self];
    }
    
}

@end






























#pragma mark - LYSeparatorLayer
@interface LYSeparatorLayer : CALayer <LYSeparatorUpdateDelegate>

@property (nonatomic, copy) NSArray<LYSeparatorDescription *> *separators;

@end

@implementation LYSeparatorLayer


- (void)setSeparators:(NSArray *)separators {
    
    _separators = [separators copy];
    if ([_separators count]) {
        [self setNeedsDisplay];
    }
    
}


- (void)drawInContext:(CGContextRef)ctx {
    
    [super drawInContext:ctx];
    NSArray *sublayers = [self.sublayers copy];
    [sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj removeFromSuperlayer];
        
    }];
    [_separators enumerateObjectsUsingBlock:^(LYSeparatorDescription * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /**
         *  可以参考 CAReplicatorLayer 的用法
         */
        if (obj.customView) {
            
            CAReplicatorLayer *repLayer = [CAReplicatorLayer layer];
            [self addSublayer:repLayer];
            repLayer.frame = self.bounds;
            [repLayer addSublayer:obj.customView.layer];
            repLayer.instanceCount = obj.instanceCount;
            repLayer.instanceDelay = obj.instanceDelay;
            repLayer.instanceTransform = obj.instanceTransform;
            repLayer.instanceColor = [obj.instanceColor CGColor];
            repLayer.instanceRedOffset = obj.instanceRedOffset;
            repLayer.instanceGreenOffset = obj.instanceGreenOffset;
            repLayer.instanceBlueOffset = obj.instanceBlueOffset;
            repLayer.instanceAlphaOffset = obj.instanceAlphaOffset;
            [repLayer layoutIfNeeded];
            
        } else {
        
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            [self addSublayer:shapeLayer];
            shapeLayer.frame = self.bounds;
            UIBezierPath *bezierPath = obj.stokePath ? obj.stokePath : [self bezierPathWithSeparator:obj inRect:self.bounds];
            shapeLayer.path = [bezierPath CGPath];
            shapeLayer.strokeColor = [obj.stokeColor CGColor];
            shapeLayer.strokeStart = obj.stokeStart;
            shapeLayer.strokeEnd = obj.stokeEnd;
            shapeLayer.lineWidth = obj.lineWidth;
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
            
        }
        obj.delegate = self;
        
    }];
    
}

- (UIBezierPath *)bezierPathWithSeparator:(LYSeparatorDescription *)separator inRect:(CGRect)rect {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    switch (separator.relation) {
            
        case LYSeparatorVerticalLeftRatio: {
            
            CGFloat width = CGRectGetWidth(rect) - separator.lineWidth;
            CGFloat height = CGRectGetHeight(rect);
            
            [bezierPath moveToPoint:CGPointMake(width * separator.constant + 0.5 * separator.lineWidth, 0)];
            [bezierPath addLineToPoint:CGPointMake(width * separator.constant + 0.5 * separator.lineWidth, height)];
            
        }
            break;
            
        case LYSeparatorHorizontalTopRatio: {
            
            CGFloat width = CGRectGetWidth(rect);
            CGFloat height = CGRectGetHeight(rect) - separator.lineWidth;
            [bezierPath moveToPoint:CGPointMake(0, separator.constant * height + 0.5 * separator.lineWidth)];
            [bezierPath addLineToPoint:CGPointMake(width, separator.constant * height + 0.5 * separator.lineWidth)];
            
        }
            break;
            
        case LYSeparatorVerticalLeftSpace: {
            
            CGFloat height = CGRectGetHeight(rect);
            [bezierPath moveToPoint:CGPointMake(separator.constant + 0.5 * separator.lineWidth, 0)];
            [bezierPath addLineToPoint:CGPointMake(separator.constant + 0.5 * separator.lineWidth, height)];
            
        }
            break;
            
        case LYSeparatorVerticalRightSpace: {
            
            CGFloat width = CGRectGetWidth(rect);
            CGFloat height = CGRectGetHeight(rect);
            [bezierPath moveToPoint:CGPointMake(width - separator.constant - 0.5 * separator.lineWidth, 0)];
            [bezierPath addLineToPoint:CGPointMake(width - separator.constant - 0.5 * separator.lineWidth, height)];
            
        }
            break;
            
        case LYSeparatorVerticalCenterSpace: {
            
            CGFloat centerX = CGRectGetMidX(rect);
            CGFloat height = CGRectGetHeight(rect);
            [bezierPath moveToPoint:CGPointMake(centerX + separator.constant, 0)];
            [bezierPath addLineToPoint:CGPointMake(centerX + separator.constant, height)];
            
        }
            break;
            
        case LYSeparatorHorizontalTopSpace: {
            
            CGFloat width = CGRectGetWidth(rect);
            [bezierPath moveToPoint:CGPointMake(0, separator.constant + 0.5 * separator.lineWidth)];
            [bezierPath addLineToPoint:CGPointMake(width, separator.constant + 0.5 * separator.lineWidth)];
            
        }
            break;
            
        case LYSeparatorHorizontalBottomSpace: {
            
            CGFloat width = CGRectGetWidth(rect);
            CGFloat height = CGRectGetHeight(rect) - separator.lineWidth;
            [bezierPath moveToPoint:CGPointMake(0, height - separator.constant - 0.5 * separator.lineWidth)];
            [bezierPath addLineToPoint:CGPointMake(width, height - separator.constant - 0.5 * separator.lineWidth)];
            
        }
            break;
            
        case LYSeparatorHorizontalCenterSpace: {
            
            CGFloat centerY = CGRectGetMidY(rect);
            CGFloat width = CGRectGetWidth(rect);
            [bezierPath moveToPoint:CGPointMake(0, separator.constant + centerY)];
            [bezierPath addLineToPoint:CGPointMake(width, separator.constant + centerY)];
            
        }
            break;
            
    }
    return bezierPath;
    
}

- (void)separatorDidUpdate:(LYSeparatorDescription *)separator {
    
    [self setNeedsDisplay];
    
}

@end




















#pragma mark - UIView (Separator)
static char *const LYViewSeparatorLayerKey = "SeparatorLayer";
static char *const LYViewSeparatorLayerInsetsKey = "SeparatorLayerInsets";

@implementation UIView (Separator)

#pragma mark load

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method layoutSubviews = class_getInstanceMethod(self, @selector(layoutSubviews));
        Method ly_layoutSubviews = class_getInstanceMethod(self, @selector(ly_layoutSubviews));
        method_exchangeImplementations(layoutSubviews, ly_layoutSubviews);
        
    });
}

#pragma mark properties

- (CAShapeLayer *)separatorLayer {
    
    return objc_getAssociatedObject(self, LYViewSeparatorLayerKey);
    
}

- (UIEdgeInsets)separatorLayerInsets {
    
    if (!objc_getAssociatedObject(self, LYViewSeparatorLayerInsetsKey)) {
        objc_setAssociatedObject(self, LYViewSeparatorLayerInsetsKey, [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSValue *value = (NSValue *)objc_getAssociatedObject(self, LYViewSeparatorLayerInsetsKey);
    return [value UIEdgeInsetsValue];
    
}

- (void)setSeparatorLayerInsets:(UIEdgeInsets)separatorLayerInsets {
    
    objc_setAssociatedObject(self, LYViewSeparatorLayerInsetsKey, [NSValue valueWithUIEdgeInsets:separatorLayerInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setNeedsLayout];
    
}

#pragma mark layout

- (void)ly_layoutSubviews {
    
    [self ly_layoutSubviews];
    CGRect frame = self.bounds;
    frame.origin.x += self.separatorLayerInsets.left;
    frame.origin.y += self.separatorLayerInsets.top;
    frame.size.width -= (self.separatorLayerInsets.left + self.separatorLayerInsets.right);
    frame.size.height -= (self.separatorLayerInsets.top + self.separatorLayerInsets.bottom);
    self.separatorLayer.frame = frame;
    [self.separatorLayer setNeedsDisplay];
    
}

#pragma mark add separator


- (void)addSeparator:(LYSeparatorDescription *)separator {
    
    if (!self.separatorLayer) {
        
        objc_setAssociatedObject(self, LYViewSeparatorLayerKey, [LYSeparatorLayer layer], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.layer addSublayer:self.separatorLayer];
        
    }
    LYSeparatorLayer *separatorLayer = (LYSeparatorLayer *)self.separatorLayer;
    NSMutableArray *array = [separatorLayer.separators mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    [array addObject:separator];
    separatorLayer.separators = [array copy];
    
}

- (void)addSeparators:(NSArray<LYSeparatorDescription *> *)separators {
    
    if (!self.separatorLayer) {
        
        objc_setAssociatedObject(self, LYViewSeparatorLayerKey, [LYSeparatorLayer layer], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.layer addSublayer:self.separatorLayer];
        
    }
    LYSeparatorLayer *separatorLayer = (LYSeparatorLayer *)self.separatorLayer;
    NSMutableArray *array = [separatorLayer.separators mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    [array addObjectsFromArray:separators];
    separatorLayer.separators = [array copy];
    
}

#pragma mark extension


- (void)addCellSeparator {
    
    self.separatorLayerInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    LYSeparatorDescription *separator = [LYSeparatorDescription separatorWithName:@"default cell separator"];
    [self addSeparator:separator];
    
}

- (void)addTopSeparatorWithEdge:(CGFloat)horizontalEdge color:(UIColor *)color {
    
    LYSeparatorDescription *separator = [LYSeparatorDescription separatorWithName:@"top separator"];
    if (color) {
        separator.stokeColor = color;
    }
    separator.constant = horizontalEdge;
    separator.relation = LYSeparatorHorizontalTopSpace;
    [self addSeparator:separator];
    
}

- (void)addBottomSeparatorWithEdge:(CGFloat)horizontalEdge color:(UIColor *)color {
    
    LYSeparatorDescription *separator = [LYSeparatorDescription separatorWithName:@"bottom separator"];
    if (color) {
        separator.stokeColor = color;
    }
    separator.constant = horizontalEdge;
    separator.relation = LYSeparatorHorizontalBottomSpace;
    [self addSeparator:separator];
    
}

- (void)addLeftSeparatorWithEdge:(CGFloat)verticalEdge color:(UIColor *)color {
    
    LYSeparatorDescription *separator = [LYSeparatorDescription separatorWithName:@"left separator"];
    if (color) {
        separator.stokeColor = color;
    }
    separator.constant = verticalEdge;
    separator.relation = LYSeparatorVerticalLeftSpace;
    [self addSeparator:separator];
    
}

- (void)addRightSeparatorWithEdge:(CGFloat)verticalEdge color:(UIColor *)color {
    
    LYSeparatorDescription *separator = [LYSeparatorDescription separatorWithName:@"right separator"];
    if (color) {
        separator.stokeColor = color;
    }
    separator.constant = verticalEdge;
    separator.relation = LYSeparatorVerticalRightSpace;
    [self addSeparator:separator];
    
}


- (void)addHorizontalSeparatorsWithCount:(NSInteger)count color:(UIColor *)color {
    
    if (count == 0) {
        return ;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger idx = 0; idx < count; idx ++) {
        
        NSString *name = [NSString stringWithFormat:@"horizontal separator %li", (long)idx];
        LYSeparatorDescription *separator = [LYSeparatorDescription separatorWithName:name];
        if (color) {
            separator.stokeColor = color;
        }
        separator.constant = idx / (CGFloat)(count - 1);
        separator.relation = LYSeparatorHorizontalTopRatio;
        [array addObject:separator];
        
    }
    [self addSeparators:array];
    
}

- (void)addVerticalSeparatorsWithCount:(NSInteger)count color:(UIColor *)color {
    
    if (count == 0) {
        return ;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger idx = 0; idx < count; idx ++) {
        
        NSString *name = [NSString stringWithFormat:@"vertical separator %li", (long)idx];
        LYSeparatorDescription *separator = [LYSeparatorDescription separatorWithName:name];
        if (color) {
            separator.stokeColor = color;
        }
        separator.constant = idx / (CGFloat)(count - 1);
        separator.relation = LYSeparatorVerticalLeftRatio;
        [array addObject:separator];
        
    }
    [self addSeparators:array];
    
}


@end










