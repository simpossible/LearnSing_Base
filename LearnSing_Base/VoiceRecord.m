//
//  VoiceRecord.m
//  LearnSing_Base
//
//  Created by Mato on 15/10/8.
//  Copyright © 2015年 ljf. All rights reserved.
//
#define KNUMBERBUFFER 5

#import "VoiceRecord.h"
#import "LS_queue.h"

@interface VoiceRecord ()
@property(nonatomic,strong)LS_queue                     *dataQueue;
@end

typedef struct VoRecordState{
    AudioStreamBasicDescription mDataFormate;
    AudioQueueRef   mQueue;
    AudioQueueBufferRef mBuffers[KNUMBERBUFFER];
    AudioFileID     mAudioFile;
    UInt32          bufferByteSize;
    SInt64          mCurrentPackt;
    bool            mIsruning;
}VoRecordState;

static VoRecordState vos;
static void handleVoiceRecordBuffer(void *userdata,AudioQueueRef Voqueue,AudioQueueBufferRef inbuffer,const AudioTimeStamp *start,UInt32 inNumPackts,const AudioStreamPacketDescription *inPacketDesc){
    LS_queue *queue=(__bridge LS_queue*)userdata;
    //void *temp;
    void *temp = malloc(sizeof(*(inbuffer->mAudioData)));
    memcpy(temp, inbuffer->mAudioData,sizeof(inbuffer->mAudioData));
    [queue push:temp];
    AudioQueueEnqueueBuffer(vos.mQueue, inbuffer, 0, NULL);
    
}



@implementation VoiceRecord

void DeriveBufferSize(AudioQueueRef audioqueue,AudioStreamBasicDescription asbDescription,Float64 seconds,UInt32 *outBuffersize){
    static const int maxBufferSize = 0x50000;
    int maxPacketSize = asbDescription.mBytesPerPacket;
    if (maxBufferSize == 0) {
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty(audioqueue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize, &maxVBRPacketSize);
    }
    Float64 numByteForTime = asbDescription.mSampleRate *maxPacketSize*seconds;
    *outBuffersize = (UInt32)(numByteForTime<maxBufferSize?numByteForTime:maxBufferSize);
    

    
}


-(instancetype)init{
    if (self =[super init]) {
        self.dataQueue = [LS_queue defaultQueue];
    }
    vos.mDataFormate.mSampleRate = 16000;
    vos.mDataFormate.mFormatID = kAudioFormatLinearPCM;
    vos.mDataFormate.mChannelsPerFrame = 2;
    vos.mDataFormate.mBitsPerChannel = 16;
    vos.mDataFormate.mBytesPerPacket =
    vos.mDataFormate.mBytesPerFrame = vos.mDataFormate.mChannelsPerFrame *sizeof(SInt16);
    vos.mDataFormate.mFramesPerPacket =1;
    vos.mDataFormate.mFormatFlags = kLinearPCMFormatFlagIsBigEndian|kLinearPCMFormatFlagIsSignedInteger|kLinearPCMFormatFlagIsPacked;
    
    AudioQueueNewInput(&vos.mDataFormate, handleVoiceRecordBuffer, (__bridge void * _Nullable)(self.dataQueue), NULL, kCFRunLoopCommonModes, 0, &vos.mQueue);
    DeriveBufferSize(vos.mQueue,vos.mDataFormate,0.1,&vos.bufferByteSize);
    
    for (int i =0; i<KNUMBERBUFFER; i++) {
        NSLog(@"allocate");
        AudioQueueAllocateBuffer(vos.mQueue, vos.bufferByteSize, &vos.mBuffers[i]);
        AudioQueueEnqueueBuffer(vos.mQueue, vos.mBuffers[i], 0, NULL);
    }
    
    return self;
}


-(void)start{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
OSStatus sta =  AudioQueueStart(vos.mQueue, NULL);
    NSLog(@"the record start stat is %d",sta);
}

-(void)pause{

}

-(void)stop{
    OSStatus sta =  AudioQueueStop(vos.mQueue, true);
    NSLog(@"the record stop stat is %d",sta);
}
@end
