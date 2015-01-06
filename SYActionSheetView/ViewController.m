//
//  ViewController.m
//  SYActionSheetView
//
//  Created by sunbb on 15-1-6.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "ViewController.h"
#import "SYActionSheetView.h"

@interface ViewController ()

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

- (IBAction)actionBtnPressed:(id)sender
{
    SYActionSheetView *actv = [[SYActionSheetView alloc] initWithTitle:nil cancelButtonTitle:@"cancle" otherButtonTitles:@"action1",@"action2",nil];
    actv.syActionSheetActionBlock = ^(UIButton *actionBtn){
        
        if (actionBtn.tag == kBtnCaccleTag + 1)
        {
            SYLog(@"%@",actionBtn.titleLabel.text);
        }
        else if (actionBtn.tag == kBtnCaccleTag + 2)
        {
            SYLog(@"%@",actionBtn.titleLabel.text);
        }
    };
    [actv showSYActionSheet];
}

@end
