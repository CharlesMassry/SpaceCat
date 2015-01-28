//
//  Util.h
//  SpaceCat
//
//  Created by Charlie Massry on 1/25/15.
//  Copyright (c) 2015 Charlie Massry. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int ProjectileSpeed = 400;

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryEnemy          = 1 << 0,  // 0001
    CollisionCategoryProjectile     = 1 << 1,  // 0010
    CollisionCategoryDebris         = 1 << 2,  // 0100
    CollisionCategoryGround         = 1 << 3   // 1000
};

@interface Util : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
