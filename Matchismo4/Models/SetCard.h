// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "Card.h"

@interface SetCard : Card
@property (strong,nonatomic) NSString* color;
@property (strong, nonatomic) NSString* shading;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
+ (NSArray *)validSuits;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;
+ (NSUInteger)maxRank;
extern NSString* const PURPLE;
extern NSString* const GREEN;
extern NSString* const RED;
extern NSString* const SOLID;
extern NSString* const STRIPPED;
extern NSString* const UNFILLED;
@end



