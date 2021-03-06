//
//  LS_queue.h
//  LearnSing_Base
//
//  Created by Mato on 15/10/8.
//  Copyright © 2015年 ljf. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LS_queue : NSObject

+(LS_queue*)defaultQueue;

-(instancetype)init;

//在首端插入一个节点
-(void)push:(void*)data;

//删除末尾节点，但至少保留一个节点
-(BOOL)popBack;

/*删除节点并释放其中的类容*/
-(BOOL)popBackAndFreeContent;

-(void *)getFirstData;


-(void*)getLastData;

-(int)getSize;

-(void)dequeue;
@end
