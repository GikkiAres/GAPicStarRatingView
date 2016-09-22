//
//  ViewController.m
//  GAPicStarRatingView
//
//  Created by GikkiAres on 9/21/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)clickBtn:(id)sender {
    _trailing.constant += 10;
}

@end
