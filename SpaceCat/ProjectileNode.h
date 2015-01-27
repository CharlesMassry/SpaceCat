//
//  ProjectileNode.h
//  SpaceCat
//
//  Created by Charlie Massry on 1/25/15.
//  Copyright (c) 2015 Charlie Massry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ProjectileNode : SKSpriteNode

+ (instancetype) projectileAtPosition:(CGPoint)position;
- (void) moveTowardsPostion:(CGPoint)position;

@end
