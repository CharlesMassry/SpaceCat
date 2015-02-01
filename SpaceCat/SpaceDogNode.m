//
//  SpaceDogNode.m
//  SpaceCat
//
//  Created by Charlie Massry on 1/27/15.
//  Copyright (c) 2015 Charlie Massry. All rights reserved.
//

#import "SpaceDogNode.h"
#import "Util.h"

@implementation SpaceDogNode

+ (instancetype) spaceDogOfType:(SpaceDogType)type {
    SpaceDogNode *spaceDog;
    spaceDog.damaged = NO;
    NSArray *textures;
    
    if ( type == SpaceDogTypeA ) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_2"]];
        spaceDog.type = SpaceDogTypeA;
    } else {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_3"]];
        spaceDog.type = SpaceDogTypeB;
    }
    
    float scale = [Util randomWithMin:85 max:100] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.15];
    [spaceDog runAction:[SKAction repeatActionForever:animation]];
    
    [spaceDog setupPhysicsBody];
    
    return spaceDog;
}
-(BOOL) isDamaged {
    NSArray *textures;
    
    if (!_damaged) {
        [self removeActionForKey:@"animation"];
        
        if (self.type == SpaceDogTypeA) {
            textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_3"]];
        } else {
            textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_4"]];
        }
        
        SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
        [self runAction:[SKAction repeatActionForever:animation] withKey:@"damage_animation"];
        _damaged = YES;
        
        return NO;
    } else {
        return YES;
    }
}

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.velocity = CGVectorMake(0, -50);
    self.physicsBody.categoryBitMask = CollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = CollisionCategoryProjectile | CollisionCategoryGround; // 0010 | 1000 = 1010 Check to see what it collided with using bitwise OR operator
}

@end
