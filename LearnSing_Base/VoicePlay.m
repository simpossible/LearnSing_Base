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

    Byte*a = (Byte*)outBuffer->mAudioData;
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
    vps.mDataFormate.mBytesPerFrame = vps.mDataFormate.mChannelsPerFrame *sizeof(SInt16);
    vps.mDataFormate.mFormatFlags = kLinearPCMFormatFlagIsBigEndian|kLinearPCMFormatFlagIsSignedInteger|kLinearPCMFormatFlagIsPacked;
   OSStatus sta= AudioQueueNewOutput(&vps.mDataFormate, HandleOutputBuffer, (__bridge void * _Nullable)(self.dataQueue), nil, nil, 0, &vps.mQueue);
    NSLog(@"the new output is %d",sta);
   
    return self;
}


-(void)start{
    for (int i =0; i<5; i++) {
        AudioQueueAllocateBuffer(vps.mQueue, 6400, &vps.mBuffers[i]);
//        HandleOutputBuffer(nil, vps.mQueue, vps.mBuffers[i]);
        AudioQueueEnqueueBuffer(vps.mQueue, vps.mBuffers[i], 0, NULL);
    }
    OSStatus sta = AudioQueueStart(vps.mQueue, 0);
    NSLog(@"the play start stat is %d",sta);
}


-(void)stop{
    OSStatus sta =  AudioQueueStop(vps.mQueue, true);
    NSLog(@"the play stop stat is %d",sta);
}


-(void)pause{

}

@end
