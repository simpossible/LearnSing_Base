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

@interface VoiceRecord : NSObject

-(instancetype)init;

-(void)start;

-(void)stop;

-(void)pause;


@end
