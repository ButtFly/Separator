//
//  UIView+Separator.h
//  Separator
//
//  Created by 余河川 on 15/10/21.
//  Copyright © 2015年 余河川. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, LYSeparatorRelation) {
    
    LYSeparatorHorizontalTopSpace,          //水平画线，据顶部一定距离
    LYSeparatorHorizontalCenterSpace,       //水平画线，据竖直中心一定距离
    LYSeparatorHorizontalBottomSpace,       //水平画线，据底部一定距离
    LYSeparatorVerticalLeftSpace,           //竖直画线，据左边一定距离
    LYSeparatorVerticalCenterSpace,         //竖直画线，据水平中心一定距离
    LYSeparatorVerticalRightSpace,          //竖直画线，据右边一定距离
    LYSeparatorHorizontalTopRatio,          //水平画线，据顶部以高为基准的一定比例
    LYSeparatorVerticalLeftRatio,           //竖直画线，据左边以宽为基准的一定比例

    
};

#pragma mark - LYSeparatorDescription

@interface LYSeparatorDescription : NSObject
/**
 *  分割线与载体 layer 之间的关系
 */
@property (nonatomic, assign) LYSeparatorRelation relation;
/**
 *  表达常量，跟 relation 结合使用，例如 LYSeparatorHorizontalTopSpace 是指距离顶部的偏移量，LYSeparatorHorizontalTopRatio 是指距离顶部以高为基准的一定比例
 */
@property (nonatomic, assign) CGFloat constant;
/**
 *  默认为 nil ，如果设置了 stokePath，将会忽略 relation 以及 constant
 */
@property (nonatomic, strong) UIBezierPath *stokePath;

/**
 *  名字，用于区分
 */
@property (nonatomic, assign, readonly) NSString *name;
/**
 *  线的宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic, strong) UIColor *stokeColor;
/**
 *  线开始绘制的位置，水平以宽度为参照，竖直以高度
 */
@property (nonatomic, assign) CGFloat stokeStart;
/**
 *  线结束绘制的位置
 */
@property (nonatomic, assign) CGFloat stokeEnd;

/**
 *  使用了 customView 时，将会忽略 relation 以及 constant，lineWidth，stokeColor，stokeStart，stokeEnd，并且使下面的属性生效
 */
@property (nonatomic, strong) UIView *customView;

/**
 *  customView 重复的次数
 */

@property (nonatomic, assign) NSInteger instanceCount;


//@property BOOL preservesDepth;

/**
 *  下一个对象重复上一个对象动作的延时
 */

@property (nonatomic, assign) CFTimeInterval instanceDelay;

/**
 *  下一个对象对上一个对象的偏移
 */

@property (nonatomic, assign) CATransform3D instanceTransform;

/**
 *  这个颜色将使得重复的对象乘以 customView 的颜色
 */

@property (nonatomic, strong) UIColor *instanceColor;

/**
 *  将使下一个对象的 instanceColor 按照下面的属性偏移变化
 */

@property (nonatomic, assign) CGFloat instanceRedOffset;
@property (nonatomic, assign) CGFloat instanceGreenOffset;
@property (nonatomic, assign) CGFloat instanceBlueOffset;
@property (nonatomic, assign) CGFloat instanceAlphaOffset;

/**
 *  创建一个描述对象
 *
 *  @param name 描述对象的名字
 *
 *  @return <LYSeparatorDescription>
 */
+ (instancetype)separatorWithName:(NSString *)name;

@end




























#pragma mark - UIView (Separator)
@interface UIView (Separator)
/**
 *  分割线所在的 layer
 */
@property (nonatomic, strong, readonly) CALayer *separatorLayer;
/**
 *  separatorLayer 相对自身的偏移量
 */
@property (nonatomic, assign) UIEdgeInsets separatorLayerInsets;

/**
 *  添加一个分割线
 *
 *  @param separator 分割线描述，详见 <LYSeparatorDescription>
 */
- (void)addSeparator:(LYSeparatorDescription *)separator;
/**
 *  批量添加分割线
 *
 *  @param separators [<LYSeparatorDescription>, ...]
 */
- (void)addSeparators:(NSArray <LYSeparatorDescription *>*)separators;
/**
 *  添加一个像 cell 的分割线
 */
- (void)addCellSeparator;
/**
 *  添加一个顶部的分割线
 *
 *  @param horizontalEdge 距离顶部的偏移量，默认为 0
 *  @param color          分割线颜色，默认为 cell 分割线的颜色
 */
- (void)addTopSeparatorWithEdge:(CGFloat)horizontalEdge color:(UIColor *)color;
/**
 *  添加一个底部的分割线
 *
 *  @param horizontalEdge 距离底部的偏移量，默认为 0
 *  @param color          分割线颜色，默认为 cell 分割线的颜色
 */
- (void)addBottomSeparatorWithEdge:(CGFloat)horizontalEdge color:(UIColor *)color;
/**
 *  添加一个左边的分割线
 *
 *  @param horizontalEdge 距离左边的偏移量，默认为 0
 *  @param color          分割线颜色，默认为 cell 分割线的颜色
 */
- (void)addLeftSeparatorWithEdge:(CGFloat)verticalEdge color:(UIColor *)color;
/**
 *  添加一个右边的分割线
 *
 *  @param horizontalEdge 距离右边的偏移量，默认为 0
 *  @param color          分割线颜色，默认为 cell 分割线的颜色
 */
- (void)addRightSeparatorWithEdge:(CGFloat)verticalEdge color:(UIColor *)color;
/**
 *  添加一组等分的水平的分割线，例如画九宫格
 *
 *  @param count 分割线数目
 *  @param color 分割线颜色，默认为 cell 分割线的颜色
 */
- (void)addHorizontalSeparatorsWithCount:(NSInteger)count color:(UIColor *)color;

/**
 *  添加一组等分的竖直的分割线，例如画九宫格
 *
 *  @param count 分割线数目
 *  @param color 分割线颜色，默认为 cell 分割线的颜色
 */
- (void)addVerticalSeparatorsWithCount:(NSInteger)count color:(UIColor *)color;

@end









