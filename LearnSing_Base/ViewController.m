//
//  ViewController.m
//  LearnSing_Base
//
//  Created by Mato on 15/10/8.
//  Copyright © 2015年 ljf. All rights reserved.
//

#import "ViewController.h"
#import "LS_queue.h"
@interface ViewController ()

@property(nonatomic,strong)UIButton                         *inButton;
@property(nonatomic,strong)UIButton                         *outButton;
@property(nonatomic,strong)LS_queue                         *queue;

@property(nonatomic,strong)UILabel                          *showLabel;
@property(nonatomic,strong)NSString                         *showString;
@end

@implementation ViewController

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return  self;
}

- (void)viewDidLoad {
    self.queue=[[LS_queue alloc]init];
    self.showString = @"";
    [super viewDidLoad];
    [self createButton];
    
    
}


-(void)createButton{
    self.inButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 100, 50)];
    [self.inButton setTitle:@"add" forState:UIControlStateNormal];
    [self.view addSubview:self.inButton];
    [self.inButton addTarget:self action:@selector(inbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.inButton setBackgroundColor:[UIColor greenColor]];
    
    
    self.outButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 110, 100, 50)];
    [self.outButton setTitle:@"out" forState:UIControlStateNormal];
    [self.outButton setBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:self.outButton];
    [self.outButton addTarget:self action:@selector(outButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 50)];
    [self.showLabel setTextAlignment:NSTextAlignmentRight];
    [self.showLabel setClipsToBounds:NO];
    self.showLabel.layer.borderWidth =1;
    self.showLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    [self.view addSubview:self.showLabel];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)inbuttonClicked:(UIButton *)button{
    [button setBackgroundColor:[UIColor blueColor]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int i = 0;
        while (i<100000){
            [self.queue push:(void *)([NSNumber numberWithInt:i])];
            i++;
        }});
}

-(void)outButtonClicked:(UIButton*)button{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1){
            NSNumber *now = (NSNumber *)[self.queue getLastData];
            __weak NSString *a = [NSString stringWithFormat:@"_%@",now];
            if (![self.queue popBack]) {
                break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.showLabel.text =a;
           });
            
        }});
    
}

@end
