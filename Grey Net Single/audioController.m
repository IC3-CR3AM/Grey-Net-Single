//
//  audioController.m
//  Grey Net Single
//
//  Created by Frank Chen on 2018/4/4.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import "audioController.h"

@implementation audioController

-(void) createAVPlayer{
    NSLog(@"创建音乐player");
    //获取本地mp3资源
    NSString * str = [[NSBundle mainBundle] pathForResource:@"Donna Burke-HEAVENS DIVIDE (Instrumental)" ofType:@"mp3"];
    NSURL * urlMusic = [NSURL fileURLWithPath:str];
    NSLog(@"url:%@",urlMusic);
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:urlMusic error:nil];
    //准备播放
    [player prepareToPlay];
    //无限循环
    player.numberOfLoops = -1;
    
//    player.volume = 0.5;
}

-(void) playMusic{
    NSLog(@"播放音乐");
    [player play];
}

-(void) pauseMusic{
    NSLog(@"暂停音乐");
    [player pause];
}

-(void) stopMusic{
    NSLog(@"停止音乐");
    [player stop];
    player.currentTime = 0;
}

-(BOOL) isPlaying{
    BOOL isPlay = [player isPlaying];
    NSLog(@"是否在放音乐:%d",isPlay);
    return isPlay;
}
@end
