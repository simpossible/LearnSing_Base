//
//  VoicePlay.m
//  LearnSing_Base
//
//  Created by Mato on 15/10/8.
//  Copyright © 2015年 ljf. All rights reserved.
//

#import "VoicePlay.h"
#import "LS_queue.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VoicePlay ()
@property(nonatomic,strong)LS_queue                     *dataQueue;
@end

typedef struct Voplaystate{
    AudioStreamBasicDescription mDataFormate;
    AudioQueueRef               mQueue;
    AudioQueueBufferRef         mBuffers[5];
    AudioFileID                 mAudioFile;
    UInt32                      bufferByteSize;
    SInt64                      mCurrentPacket;
    UInt32                      mNumPacketsToread;
    AudioStreamPacketDescription *mPacketDescs;
    bool                          mIsRuning;
}Voplaystate;

static Voplaystate vps;

void HandleOutputBuffer(void *userData,AudioQueueRef outQueue,AudioQueueBufferRef outBuffer){
    NSLog(@"output");
    LS_queue *oq = (__bridge LS_queue*)userData;
    void *data = [oq getFirstData];
    outBuffer->mAudioDataByteSize = sizeof(*data);

    Byte *a = (Byte*)outBuffer->mAudioData;
    Byte *src = (Byte*)data;
    int size = sizeof(*data);
    for (int i =0; i<size; i++) {
        a[i] = src[i];
    }
    if (![oq popBackAndFreeContent]) {
        return;
    }
    AudioQueueEnqueueBuffer(outQueue, outBuffer, 0, NULL);
    
}

@implementation VoicePlay

-(instancetype)init{
    if (self =[super init]) {
        self.dataQueue = [LS_queue defaultQueue];
    }
    vps.mDataFormate.mSampleRate = 16000;
    vps.mDataFormate.mFormatID = kAudioFormatLinearPCM;
    vps.mDataFormate.mChannelsPerFrame = 2;
    vps.mDataFormate.mFramesPerPacket =1;
    vps.mDataFormate.mBitsPerChannel = 16;
    vps.mDataFormate.mBytesPerPacket =
    vps.mDataFormate.mBytesPerFrame = vps.mDataFormate.mBytesPerFrame *sizeof(SInt16);
    vps.mDataFormate.mFormatFlags = kLinearPCMFormatFlagIsBigEndian|kLinearPCMFormatFlagIsSignedInteger|kLinearPCMFormatFlagIsPacked;
    AudioQueueNewOutput(&vps.mDataFormate, HandleOutputBuffer, (__bridge void * _Nullable)(self.dataQueue), CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &vps.mQueue);
    for (int i =0; i<5; i++) {
        AudioQueueAllocateBuffer(vps.mQueue, vps.bufferByteSize, &vps.mBuffers[i]);
        //AudioQueueEnqueueBuffer(vps.mQueue, vps.mBuffers[i], 0, NULL);
        AudioQueueEnqueueBuffer(vps.mQueue, vps.mBuffers[i], 0, NULL);
       // HandleOutputBuffer((__bridge void*)self.dataQueue, vps.mQueue, vps.mBuffers[i]);
    }
    
    return self;
}


-(void)start{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    OSStatus sta = AudioQueueStart(vps.mQueue, NULL);
     NSLog(@"the play start stat is %d",sta);
}


-(void)stop{

    OSStatus sta =  AudioQueueStop(vps.mQueue, true);
    NSLog(@"the play stop stat is %d",sta);
}


-(void)pause{

}

@end
