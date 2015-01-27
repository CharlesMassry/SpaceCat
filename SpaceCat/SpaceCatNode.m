//
//  SpaceCatNode.m
//  SpaceCat
//
//  Created by Charlie Massry on 1/25/15.
//  Copyright (c) 2015 Charlie Massry. All rights reserved.
//

#import "SpaceCatNode.h"

@interface SpaceCatNode ()
@property(nonatomic) SKAction *tapAction;
@end

@implementation SpaceCatNode

+(instancetype) spaceCatAtPosition:(CGPoint)position {
    SpaceCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    spaceCat.position = position;
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    spaceCat.name = @"SpaceCat";
    
    return spaceCat;
}

-(void) performTap {
    [self runAction:self.tapAction];
}

- (SKAction *)tapAction {
    if (_tapAction != nil) {
        return _tapAction;
    }
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"spacecat_2"],
                          [SKTexture textureWithImageNamed:@"spacecat_1"]];
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
    return _tapAction;
}

@end
