//
//  SpaceDogNode.h
//  SpaceCat
//
//  Created by Charlie Massry on 1/27/15.
//  Copyright (c) 2015 Charlie Massry. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef NS_ENUM(NSUInteger, SpaceDogType) {
    SpaceDogTypeA,
    SpaceDogTypeB
};

@interface SpaceDogNode : SKSpriteNode

@property (nonatomic, getter=isDamaged) BOOL damaged;
@property (nonatomic) SpaceDogType type;

+ (instancetype) spaceDogOfType:(SpaceDogType)type;

@end
