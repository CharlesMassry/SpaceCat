//
//  TitleScene.m
//  SpaceCat
//
//  Created by Charlie Massry on 1/25/15.
//  Copyright (c) 2015 Charlie Massry. All rights reserved.
//

#import "TitleScene.h"
#import "GamePlayScene.h"

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GamePlayScene *gamePlayScene = [GamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    
    [self.view presentScene:gamePlayScene transition:transition];
}

@end
