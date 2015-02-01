//
//  TitleScene.m
//  SpaceCat
//
//  Created by Charlie Massry on 1/25/15.
//  Copyright (c) 2015 Charlie Massry. All rights reserved.
//

#import "TitleScene.h"
#import "GamePlayScene.h"
#import <AVFoundation/AVFoundation.h>

@interface TitleScene ()

@property(nonatomic) SKAction *pressStartSFX;
@property(nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
        
        // to play background music
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic prepareToPlay];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self runAction:self.pressStartSFX];
    [self.backgroundMusic stop];
    GamePlayScene *gamePlayScene = [GamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    
    [self.view presentScene:gamePlayScene transition:transition];
}

@end
