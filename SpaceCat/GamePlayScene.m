//
//  GamePlayScene.m
//  SpaceCat
//
//  Created by Charlie Massry on 1/25/15.
//  Copyright (c) 2015 Charlie Massry. All rights reserved.
//

#import "GamePlayScene.h"
#import "MachineNode.h"
#import "SpaceCatNode.h"
#import "ProjectileNode.h"
#import "SpaceDogNode.h"
#import "GroundNode.h"
#import "Util.h"
#import <AVFoundation/AVFoundation.h>


@interface GamePlayScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;

@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;

@property (nonatomic) AVAudioPlayer *backgroundMusic;

@end


@implementation GamePlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 1.25;
        self.minSpeed = SpaceDogMinSpeed;
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        MachineNode *machine = [MachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        
        SpaceCatNode *spaceCat = [SpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y-2)];
        [self addChild:spaceCat];
        
        [self addSpaceDog];
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self;
        GroundNode *ground = [GroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
        [self setupSounds];
    }
    return self;
}

-(void) didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

-(void) setupSounds {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];
    
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint position = [touch locationInNode:self];
        [self shootProjectileTowardsPosition:position];
    }
}

-(void)shootProjectileTowardsPosition:(CGPoint)position {
    SpaceCatNode *spaceCat = (SpaceCatNode*)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    MachineNode *machine = (MachineNode *)[self childNodeWithName:@"Machine"];
    
    
    ProjectileNode *projectile = [ProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y+machine.frame.size.height-15)];
    [self addChild:projectile];
    [projectile moveTowardsPostion:position];
    
    [self runAction:self.laserSFX];
}

- (void) addSpaceDog {
    NSUInteger randomSpaceDog = [Util randomWithMin:0 max:2];
    
    SpaceDogNode *spaceDog = [SpaceDogNode spaceDogOfType:randomSpaceDog];
    float dy = [Util randomWithMin:SpaceDogMinSpeed max:SpaceDogMaxSpeed];
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy);
    
    float y = self.frame.size.height + spaceDog.size.height;
    float x = [Util randomWithMin:10+spaceDog.size.width
                             max:self.frame.size.width-spaceDog.size.width-10];
    spaceDog.position = CGPointMake(x, y);
    [self addChild:spaceDog];
}

-(void) update:(NSTimeInterval)currentTime {
    
    if ( self.lastUpdateTimeInterval ) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    if (self.timeSinceEnemyAdded > 1.5) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    if (self.totalGameTime > 480 ) {
        // 8 minutes
        self.addEnemyTimeInterval = 0.5;
        self.minSpeed = -160;
    } else if (self.totalGameTime > 240 ) {
        // 4 minutes
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    } else if ( self.totalGameTime > 120 ) {
        // 2 minutes
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    } else if ( self.totalGameTime > 30 ) {
        // 30 seconds
        self.addEnemyTimeInterval = 1.00;
        self.minSpeed = -100;
    }
}

- (void) didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ( firstBody.categoryBitMask == CollisionCategoryEnemy && secondBody.categoryBitMask == CollisionCategoryProjectile) {
        NSLog(@"BAM!");
        SpaceDogNode *spaceDog = (SpaceDogNode *)firstBody.node;
        ProjectileNode *projectile = (ProjectileNode *)secondBody.node;

        if ([spaceDog isDamaged]) {
            [self runAction:self.explodeSFX];

            [spaceDog removeFromParent];
            [projectile removeFromParent];

            [self createDebrisAtPosition:contact.contactPoint];
        }
        
    } else if (firstBody.categoryBitMask == CollisionCategoryEnemy && secondBody.categoryBitMask == CollisionCategoryGround) {
        NSLog(@"Hit the deck!");
        SpaceDogNode *spaceDog = (SpaceDogNode *)firstBody.node;
        [self runAction:self.damageSFX];
        [spaceDog removeFromParent];
    }
}

- (void) createDebrisAtPosition:(CGPoint)position {
    NSUInteger numberOfPieces = [Util randomWithMin:5 max:20];
    
    for (int i=0; i < numberOfPieces; i++) {
        NSUInteger randomPiece = [Util randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%lu", (unsigned long)randomPiece];
        
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        [self addChild:debris];
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = CollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = CollisionCategoryGround | CollisionCategoryDebris;
        debris.name = @"Debris";
        debris.physicsBody.velocity = CGVectorMake([Util randomWithMin:-150 max:150],
                                                   [Util randomWithMin:150 max:350]);
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{
            [debris removeFromParent];
        }];
    }
}

@end
