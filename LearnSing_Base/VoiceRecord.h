//
//  VoiceRecord.h
//  LearnSing_Base
//
//  Created by Mato on 15/10/8.
//  Copyright © 2015年 ljf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import <AVFoundation/AVFoundation.h>
typedef struct VoRecordState{
    AudioStreamBasicDescription mDataFormate;
    AudioQueueRef   mQueue;
    AudioQueueBufferRef mBuffers[5];
    AudioFileID     mAudioFile;
    UInt32          bufferByteSize;
    SInt64          mCurrentPackt;
    bool            mIsruning;
}VoRecordState;


@interface VoiceRecord : NSObject

-(instancetype)init;

-(void)start;

-(void)stop;

-(void)pause;


@end
