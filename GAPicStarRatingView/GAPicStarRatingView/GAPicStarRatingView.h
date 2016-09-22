//
//  GAPicStarRatingView.h
//  GAPicStarRatingViewMaster
//
//  Created by GikkiAres on 5/23/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GAPicStarViewDisplayStyle) {
  GAPicStarRatingViewStarStyleFullStar,   //整星显示
  GAPicStarRatingViewStarStyleHalfStar,  //整星和半星
  GAPicStarRatingViewStarStyleHalfStar2,
  GAPicStarRatingViewStarStyleIncompleteStar //不完整的星
};


#pragma mark GAPicStarRatingViewDelegate
@class GAPicStarRatingView;
@protocol GAPicStarRatingViewDelegate <NSObject>

- (void)GAPicStarRatingViewHasBeenTapped:(GAPicStarRatingView *)view;

@end



@interface GAPicStarRatingView : UIView

//满分数,默认5
@property (nonatomic,assign) IBInspectable NSInteger totalStarNum;

//得分百分比值,默认0
@property (nonatomic, assign) CGFloat selectedPercent;

//评分星数,默认0,默认0
@property (nonatomic,assign)IBInspectable CGFloat selectedStarNum;

@property (nonatomic, assign) GAPicStarViewDisplayStyle displayStyle;

//是否允许动画，默认为NO
//tap评分时,是否动画变化
@property (nonatomic, assign)IBInspectable BOOL sholudAnimateWhenTap;
//直接设置评分时,是否动画变化
@property (nonatomic, assign)IBInspectable BOOL sholudAnimateWhenSet;

@property (nonatomic,assign)IBInspectable CGFloat animationDuration;

//是否能够点击设置
@property (nonatomic,assign) IBInspectable BOOL isSettable;

@property (nonatomic,weak) id<GAPicStarRatingViewDelegate> delegate;



#pragma mark 构造函数


//最完整的构造方式,这两个指定构造器,都需要设置.
- (instancetype)initWithFrame:(CGRect)frame totalStarNum:(NSInteger)totalStarNum initalSelectedStarNum:(CGFloat)selectedStarNum style:(GAPicStarViewDisplayStyle)style NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;



@end
