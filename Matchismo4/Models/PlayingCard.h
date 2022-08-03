// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import <Foundation/Foundation.h>

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;
@end

