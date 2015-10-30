//
//  LYViewController.m
//  Separator
//
//  Created by 余河川 on 10/21/2015.
//  Copyright (c) 2015 余河川. All rights reserved.
//

#import "LYViewController.h"
#import "UIView+Separator.h"

@interface LYViewController ()

@property (weak, nonatomic) IBOutlet UIView *cellSeparator;
@property (weak, nonatomic) IBOutlet UIView *leftSeparator;
@property (weak, nonatomic) IBOutlet UIView *rightSeparator;
@property (weak, nonatomic) IBOutlet UIView *topSeparator;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet UIView *drawView;
@property (weak, nonatomic) IBOutlet UIView *customLine;


@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [_cellSeparator addCellSeparator];
    [_leftSeparator addLeftSeparatorWithEdge:2 color:[UIColor blackColor]];
    [_rightSeparator addRightSeparatorWithEdge:3 color:[UIColor blackColor]];
    [_topSeparator addTopSeparatorWithEdge:4 color:[UIColor blackColor]];
    [_bottomSeparator addBottomSeparatorWithEdge:5 color:[UIColor blackColor]];
    [_drawView addVerticalSeparatorsWithCount:4 color:[UIColor greenColor]];
    [_drawView addHorizontalSeparatorsWithCount:4 color:[UIColor greenColor]];
    LYSeparatorDescription *des = [LYSeparatorDescription separatorWithName:@"custom des"];
    des.stokeColor = [UIColor redColor];
    des.stokeStart = 0.2;
    des.stokeEnd = 0.9;
    des.relation = LYSeparatorVerticalLeftRatio;
    des.constant = 0.5;
    LYSeparatorDescription *pathDes = [LYSeparatorDescription separatorWithName:@"path des"];
    pathDes.stokeColor = [UIColor redColor];
    pathDes.stokeStart = 0.2;
    pathDes.stokeEnd = 0.9;
    pathDes.stokePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 300, 50) cornerRadius:6];
    [self performSelector:@selector(changeSeparator:) withObject:des afterDelay:3];
    [_customLine addSeparators:@[des, pathDes]];
    
    NSLog(@"%@", [[[@"   asd\na \rsd        " stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""]);
    
}

- (void)changeSeparator:(LYSeparatorDescription *)separator {
    
    separator.relation = LYSeparatorHorizontalTopRatio;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
