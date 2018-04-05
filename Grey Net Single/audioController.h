//
//  audioController.h
//  Grey Net Single
//
//  Created by Frank Chen on 2018/4/4.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface audioController : NSObject
<AVAudioPlayerDelegate>
{
    AVAudioPlayer* player;
}
-(void) createAVPlayer;
-(void) playMusic;
-(void) pauseMusic;
-(void) stopMusic;
-(BOOL) isPlaying;
@end
