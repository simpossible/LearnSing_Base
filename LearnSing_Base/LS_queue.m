//
//  LS_queue.m
//  LearnSing_Base
//
//  Created by Mato on 15/10/8.
//  Copyright © 2015年 ljf. All rights reserved.
//

#import "LS_queue.h"

typedef struct ls_node{
    struct ls_node *pre;
    void *content;
    struct ls_node *next;
}node;

@interface LS_queue()
@property(atomic,assign)int              size;

@property(nonatomic,assign)node             *first;
@property(nonatomic,assign)node             *last;
@property(nonatomic,assign)int              maxSize;
@end

@implementation LS_queue

-(instancetype)init{
    if (self = [super init]) {
        _first = (node*)malloc(sizeof(node));
        _last = _first;
        
        _first->pre = NULL;
        _first->next = NULL;
        
        
        //初始化链表大小为1
        _size = 0;
        _maxSize=0;
    }
    return self;
}


-(void)push:(void*)data{
    if (_size == 0) {
        _first->content = data;
        _size =1;
        return;
    }else{
        node *content_node = (node*)malloc(sizeof(node));
        content_node->pre = NULL;
        content_node->content = data;
        
        _first->pre = content_node;
        content_node->next = _first;
        _first = content_node;
        _size ++;
    }
   
   
}
-(BOOL)popBack{
    if (_size == 0) {
        NSLog(@"pop 0 size is %d",_size);
        return false;
    }else if(_size == 1){
        _last->content = NULL;
        _size =0;
        return true;
    }else{
        _last = _last->pre;
        free(_last->next);
        _last->next = NULL;
        _size--;
        return true;
    }
}


-(void *)getFirstData{
    return _first->content;
}

-(void*)getLastData{
    return _last->content;
}

-(void)freeNode:(node *)f_node{
//    free(f_node->content);
    free(f_node);
}

-(int)getSize{
    return self.size;
}

@end
