//
//  ViewController.m
//  LearnSing_Base
//
//  Created by Mato on 15/10/8.
//  Copyright © 2015年 ljf. All rights reserved.
//

#import "ViewController.h"
#import "LS_queue.h"
#import "VoiceRecord.h"
#import "VoicePlay.h"
@interface ViewController ()

@property(nonatomic,strong)UIButton                         *inButton;
@property(nonatomic,strong)UIButton                         *outButton;
@property(nonatomic,strong)LS_queue                         *queue;

@property(nonatomic,strong)UILabel                          *showLabel;
@property(nonatomic,strong)NSString                         *showString;

@property(nonatomic,strong)VoiceRecord                      *recorder;
@property(nonatomic,strong)VoicePlay                        *player;

@end

@implementation ViewController

-(instancetype)init{
    if (self = [super init]) {
        NSLog(@"viewcontroller");
      
    }
    return  self;
}

- (void)viewDidLoad {
    self.queue=[[LS_queue alloc]init];
    self.recorder = [[VoiceRecord alloc]init];
    self.player = [[VoicePlay alloc]init];
    self.showString = @"";
    [super viewDidLoad];
    [self createButton];
    
    
}


-(void)createButton{
    self.inButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 50, 100, 50)];
    [self.inButton setTitle:@"start" forState:UIControlStateNormal];
    [self.view addSubview:self.inButton];
    [self.inButton setTag:1];
    [self.inButton addTarget:self action:@selector(inbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.inButton setBackgroundColor:[UIColor greenColor]];
    
    
    self.outButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 110, 100, 50)];
    [self.outButton setTitle:@"out" forState:UIControlStateNormal];
    [self.outButton setBackgroundColor:[UIColor greenColor]];
    [self.outButton setTag:1];
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
    if (button.tag ==1) {
        button.tag=2;
    [button setBackgroundColor:[UIColor blueColor]];
    [self.recorder start];
    }else{
        button.tag =1;
        [button setBackgroundColor:[UIColor redColor]];
        [self.recorder stop];
    }
}

-(void)outButtonClicked:(UIButton*)button{

    
    if (button.tag ==1) {
        button.tag=2;
        [button setBackgroundColor:[UIColor blueColor]];
        [self.player start];
    }else{
        button.tag =1;
        [button setBackgroundColor:[UIColor redColor]];
        [self.player stop];
    }
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        while (1){
//            NSNumber *now = (NSNumber *)[self.queue getLastData];
//            __weak NSString *a = [NSString stringWithFormat:@"_%@",now];
//            if (![self.queue popBack]) {
//                break;
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.showLabel.text =a;
//           });
//            
//        }});
    
}

@end
