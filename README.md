# Separator

[![CI Status](http://img.shields.io/travis/余河川/Separator.svg?style=flat)](https://travis-ci.org/余河川/Separator)
[![Version](https://img.shields.io/cocoapods/v/Separator.svg?style=flat)](http://cocoapods.org/pods/Separator)
[![License](https://img.shields.io/cocoapods/l/Separator.svg?style=flat)](http://cocoapods.org/pods/Separator)
[![Platform](https://img.shields.io/cocoapods/p/Separator.svg?style=flat)](http://cocoapods.org/pods/Separator)

## Usage

详细的使用见 demo，因为最近比较忙，所以实现的功能不是很全面，如果您有更好的建议，请联系我。

*	LYSeparatorRelation

~~~ javascript

LYSeparatorHorizontalTopSpace,          //水平画线，据顶部一定距离
LYSeparatorHorizontalCenterSpace,       //水平画线，据竖直中心一定距离LYSeparatorHorizontalBottomSpace,       //水平画线，据底部一定距离LYSeparatorVerticalLeftSpace,           //竖直画线，据左边一定距离
LYSeparatorVerticalCenterSpace,         //竖直画线，据水平中心一定距离
LYSeparatorVerticalRightSpace,          //竖直画线，据右边一定距离
LYSeparatorHorizontalTopRatio,          //水平画线，据顶部以高为基准的一定比例
LYSeparatorVerticalLeftRatio,           //竖直画线，据左边以宽为基准的一定比例
    	
    	
*	建立一个分隔线
			
LYSeparatorDescription *des = [LYSeparatorDescription separatorWithName:@"custom des"];
des.stokeColor = [UIColor redColor];
des.stokeStart = 0.2;
des.stokeEnd = 0.9;
des.relation = LYSeparatorVerticalLeftRatio;
des.constant = 0.5;
[view addSeparator:des];    	



*	封装了添加一些基本的分隔线

		
[view addCellSeparator];		//添加类似 cell 的分隔线
[view addTopSeparatorWithEdge:edge color:color]; //添加距离顶部 edge，颜色为 color 的水平分隔线
......
		
*	添加自定义的 UIPath，你对 LYSeparatorDescription 的改变能立即表现在视图上（目前没有加入动画的支持）
			
LYSeparatorDescription *pathDes = [LYSeparatorDescription separatorWithName:@"path des"];
pathDes.stokeColor = [UIColor redColor];
pathDes.stokeStart = 0.2;
pathDes.stokeEnd = 0.9;
pathDes.stokePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 300, 50) cornerRadius:6];
[self performSelector:@selector(changeSeparator:) withObject:des afterDelay:3];
[view addSeparator:pathDes];

*	添加自定义的图片，采用了 CAReplicatorLayer
		
LYSeparatorDescription *cusDes2 = [LYSeparatorDescription separatorWithName:@"custom des 2"];

UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 20, 20)];
imageV2.image = [UIImage imageNamed:@"2"];
cusDes2.customView = imageV2;
cusDes2.instanceCount = 20;
cusDes2.instanceTransform = CATransform3DMakeTranslation(20, 0, 0);
[view addSeparator:cusDes2];
    	
*	因为 CAReplicatorLayer 是支持动画的，所以你也可以用自己的方式添加动画

		
LYSeparatorDescription *cusDes = [LYSeparatorDescription separatorWithName:@"custom des"];
UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
imageV.image = [UIImage imageNamed:@"1"];
cusDes.customView = imageV;
cusDes.instanceCount = 20;
cusDes.instanceDelay = 0.2;

CAKeyframeAnimation *an = [CAKeyframeAnimation animationWithKeyPath:@"position"];
UIBezierPath *path = [UIBezierPath bezierPath];
[path moveToPoint:CGPointMake(10, 10)];
[path addLineToPoint:CGPointMake(200, 30)];
[path addLineToPoint:CGPointMake(300, 300)];
[path closePath];
an.path = [path CGPath];
an.repeatCount = MAXFLOAT;
an.duration = 4;
[imageV.layer addAnimation:an forKey:@"an"];
[view addSeparator:cusDes];

~~~
		


## Requirements

XCode 7以上

## Installation

Separator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Separator"
```

## Author

余河川, 315585758@qq.com

## License

Separator is available under the MIT license. See the LICENSE file for more info.
