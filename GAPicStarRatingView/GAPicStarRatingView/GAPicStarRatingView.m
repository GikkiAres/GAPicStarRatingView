//
//  GAPicStarRatingView.m
//  GAPicStarRatingViewMaster
//
//  Created by GikkiAres on 5/23/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//


#import "GAPicStarRatingView.h"


#define kSelectedImageName @"GAStar-Selected"
#define kUnselectedImageName @"GAStar-Unselected"




//默认值宏
#define kDefaultTotalStarNum 5
#define kDefaultInitSelectedStarNum 0
#define kDefaultDisplayStyle GAPicStarRatingViewStarStyleIncompleteStar


@interface GAPicStarRatingView ()
//用来显示已经选择的星星
@property (nonatomic, strong) UIView *foregroundStarView;
//显示未选择的星星
@property (nonatomic, strong) UIView *backgroundStarView;

//标记是否真的需要重新布局而不是系统调用.
@property(nonatomic,assign) BOOL isAdjustingSubviewFrame;

@end


@implementation GAPicStarRatingView

#pragma mark - Init Methods
//1 便利构造函数必须用一些默认值来调用指定构造函数,因为指定构造函数才能完全初始化对象.便利构造函数应该看成是用一些默认值去调用指定构造函数.
//2 子类的指定构造函数,必须调用父类的指定构造函数.init是便利构造函数,initWithFrame和initWithCoder是指定构造函数.

- (instancetype)initWithFrame:(CGRect)frame {
   return [self initWithFrame:self.frame totalStarNum:kDefaultTotalStarNum initalSelectedStarNum:kDefaultInitSelectedStarNum style:kDefaultDisplayStyle];
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
    if(self) {
        _totalStarNum = kDefaultTotalStarNum;
        _selectedStarNum = kDefaultInitSelectedStarNum;
        _displayStyle = kDefaultDisplayStyle;
        [self commonInit];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame totalStarNum:(NSInteger)totalStarNum initalSelectedStarNum:(CGFloat)selectedStarNum style:(GAPicStarViewDisplayStyle)displayStyle {
  if (self = [super initWithFrame:frame]) {
    _totalStarNum = totalStarNum;
    _selectedStarNum = selectedStarNum;
    _displayStyle = displayStyle;
    [self commonInit];
  }
  return self;
}

#pragma mark - Get and Set Methods
- (void)setSelectedPercent:(CGFloat)selectedPercent {
    if (_selectedPercent == selectedPercent) {
        return;
    }
    if (selectedPercent < 0) {
        selectedPercent = 0;
    } else if (selectedPercent > 1) {
        selectedPercent = 1;
    } else {
        _selectedPercent = selectedPercent;
    }
    _selectedStarNum = _selectedPercent*_totalStarNum;
    [self createStarViewAnimated:_sholudAnimateWhenSet];
}

- (void)setSelectedStarNum:(CGFloat)selectedStarNum {
    self.selectedPercent = selectedStarNum/_totalStarNum;
}


- (void)setTotalStarNum:(NSInteger)totalStarNum {
    _totalStarNum = totalStarNum;
    self.selectedPercent = _selectedStarNum/totalStarNum;
}


#pragma mark - Private Methods
//其实应该在init方法中负责创建数据,而应该在layoutSubview中,负责调整每个UI对象的位置.并且frame依赖父视图的东西应该在layoutSubview中创建比价好.
- (void)commonInit {
  self.autoresizingMask = UIViewAutoresizingNone;
  _isSettable = YES;
  _sholudAnimateWhenSet = NO;
  _sholudAnimateWhenTap = YES;
    _animationDuration = 0.2;
  _selectedPercent = _selectedStarNum/_totalStarNum;
    _isAdjustingSubviewFrame = NO;
  //增加点击手势
  UITapGestureRecognizer *grTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
  [self addGestureRecognizer:grTap];
}


- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
}

- (void)createStarViewAnimated:(BOOL)animated {
  [_backgroundStarView removeFromSuperview];
  [_foregroundStarView removeFromSuperview];
  self.foregroundStarView = [self createStarViewWithImage:kSelectedImageName];
  self.backgroundStarView = [self createStarViewWithImage:kUnselectedImageName];
  [self addSubview:self.backgroundStarView];
  [self addSubview:self.foregroundStarView];
  //创建starView的时候不动画.
  [self displayStarAnimated:animated];
}

- (void)displayStarAnimated:(BOOL)animated {
  //根据不同的显示模式,计算实际显示的星数.
  CGFloat displayStarNum = _selectedStarNum;
  
  switch (self.displayStyle) {
          
    case GAPicStarRatingViewStarStyleFullStar:{
      //1.2 算2星
      int numFullStar = (int)_selectedStarNum;
      CGFloat delta = _selectedStarNum-numFullStar;
      if (delta==0) {
        displayStarNum = numFullStar;
      }
      else {
        displayStarNum = numFullStar +1;
      }
      break;
    }
          
    case   GAPicStarRatingViewStarStyleHalfStar2: {
      //1.2,1.5,1.9 都算1.5分,1分算1分,2分算2分.
      int numFullStar = (int)_selectedStarNum;
      CGFloat delta = _selectedStarNum-numFullStar;
      //浮点数不能精确比较???
      if (delta==0) {
        displayStarNum = numFullStar;
      }
      else  {
        displayStarNum = numFullStar+0.5;
      }
      break;
    }
          
    case GAPicStarRatingViewStarStyleHalfStar:{
      //1->1,1.2->1,1.6->1.5
      int numFullStar = (int)_selectedStarNum;
      CGFloat delta = _selectedStarNum-numFullStar;
      if (delta==0) {
        displayStarNum = numFullStar;
      }
      else if (delta<0.5) {
        displayStarNum = numFullStar;
      }
      else {
        displayStarNum = numFullStar+0.5;
      }
      break;
    }
          
    case GAPicStarRatingViewStarStyleIncompleteStar:{
      break;
    }
          
  }
  CGFloat displayPercent = displayStarNum/_totalStarNum;
  
  //  CGFloat animationTimeInterval = self.hasAnimation ? ANIMATION_TIME_INTERVAL : 0;
  if (animated) {
    [UIView animateWithDuration:_animationDuration animations:^{
      self.foregroundStarView.frame = CGRectMake(0,0,self.bounds.size.width*displayPercent, self.bounds.size.height);
    } completion:^(BOOL finished) {
        _isAdjustingSubviewFrame = NO;
    }
     ];
  }
  else {
      self.foregroundStarView.frame = CGRectMake(0,0,self.bounds.size.width*displayPercent, self.bounds.size.height);
  }

}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
  UIView *view = [[UIView alloc] initWithFrame:self.bounds];
  view.clipsToBounds = YES;
  view.backgroundColor = [UIColor clearColor];
  for (NSInteger i = 0; i < self.totalStarNum; i ++){
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = CGRectMake(i * self.bounds.size.width / self.totalStarNum, 0, self.bounds.size.width / self.totalStarNum, self.bounds.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:imageView];
  }
  return view;
}


- (void)layoutSubviews {
  [super layoutSubviews];
//  //父类尺寸变化,需要重新创建starView显示
    if (_isAdjustingSubviewFrame) {
        return;
    }
  [self createStarViewAnimated:NO];
}


#pragma mark - 4 点击事件
#pragma mark  评分
//点击的评分只能是整数颗星. (0-1]算1分,...(4,5]算5分.
- (void)onTap:(UITapGestureRecognizer *)gr {
  if (!_isSettable) {
    return;
  }
  CGPoint pt = [gr locationInView:self];
  CGFloat touchPercent = pt.x/self.bounds.size.width;
  
  _selectedStarNum = touchPercent*_totalStarNum;
  
  int numFullStar = (int)_selectedStarNum;
  CGFloat delta = _selectedStarNum-numFullStar;
  if (delta==0) {
    _selectedStarNum = numFullStar;
  }
  else {
    _selectedStarNum = numFullStar +1;
  }
  _selectedPercent = _selectedPercent/_totalStarNum;
  
//不需要重新构建starView,重新显示分数就好
    _isAdjustingSubviewFrame = YES;
    [self displayStarAnimated:_sholudAnimateWhenTap];

    if (_delegate&&[_delegate respondsToSelector:@selector(GAPicStarRatingViewHasBeenTapped:)]) {
        [_delegate GAPicStarRatingViewHasBeenTapped:self];
    }
  
}

- (void)dealloc {
  NSLog(@"dealloc");
}

@end
