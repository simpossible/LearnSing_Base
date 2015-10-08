//
//  VoiceRecord.m
//  LearnSing_Base
//
//  Created by Mato on 15/10/8.
//  Copyright © 2015年 ljf. All rights reserved.
//

#import "VoiceRecord.h"


typedef struct VoRecordState{
    AudioStreamBasicDescription mDataFormate;
    AudioQueueRef   mQueue;
    AudioQueueBufferRef mBuffers[5];
    AudioFileID     mAudioFile;
    UInt32          bufferByteSize;
    SInt64          mCurrentPackt;
    bool            mIsruning;
}VoRecordState;

static VoRecordState vos;

@interface VoiceRecord ()

@end
@implementation VoiceRecord

-(instancetype)init{
    if (self =[super init]) {
        
    }
    vos.mDataFormate.mSampleRate = 16000;
    vos.mDataFormate.mFormatID = kAudioFormatLinearPCM;
    vos.mDataFormate.mChannelsPerFrame = 2;
    vos.mDataFormate.mBitsPerChannel = 16;
    vos.mDataFormate.mBytesPerPacket =
    vos.mDataFormate.mBytesPerFrame = vos.mDataFormate.mChannelsPerFrame *sizeof(SInt16);
    vos.mDataFormate.mFramesPerPacket =1;
    vos.mDataFormate.mFormatFlags = kLinearPCMFormatFlagIsBigEndian|kLinearPCMFormatFlagIsSignedInteger|kLinearPCMFormatFlagIsPacked;
    return self;
}


-(void)start{

}
@end
