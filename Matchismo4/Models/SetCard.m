// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "SetCard.h"
#import <UIKit/UIKit.h>

@implementation SetCard

static int const SCORE = 4;
static NSString *SUIT = @"suit";
static NSString *RANK = @"rank";
static NSString *COLOR = @"color";
static NSString *SHADING = @"shading";
NSString* const PURPLE = @"purple";
NSString* const GREEN = @"green";
NSString* const RED = @"red";
NSString* const SOLID = @"solid";
NSString* const STRIPPED = @"striped";
NSString* const UNFILLED = @"unfilled";

- (int)match:(NSArray *)otherCards {
  int score = SCORE;
  NSMutableArray *cards = [[NSMutableArray alloc] initWithArray:otherCards];
  NSMutableSet *rankSet = [[NSMutableSet alloc] init];
  NSMutableSet *suitSet = [[NSMutableSet alloc] init];
  NSMutableSet *shadingSet = [[NSMutableSet alloc] init];
  NSMutableSet *colorSet = [[NSMutableSet alloc] init];
  for (SetCard *card in cards) {
    [rankSet addObject:[[NSNumber alloc] initWithInt:(int)card.rank]];
    [suitSet addObject:card.suit];
    [shadingSet addObject:card.shading];
    [colorSet addObject:card.color];
    }
  if ([@[@(rankSet.count), @(suitSet.count), @(shadingSet.count), @(colorSet.count)] containsObject:@(2)]) {
    score = 0;
  }
  return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [SetCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit {
  if ([[SetCard validSuits] containsObject:suit]) {
    _suit = suit;
  }
}

- (NSString *)suit {
  return _suit ? _suit : @"?";
}

+ (NSUInteger)maxRank {
  return [[self rankStrings] count]-1;

}

- (void)setRank:(NSUInteger)rank {
  if (rank <= [SetCard maxRank]) {
    _rank = rank;
  }
}

+ (NSArray *)rankStrings {
  return @[@"?",@"1", @"2", @"3"];
}

+ (NSArray *)validSuits {
  return @[@"▲", @"●", @"■"];
}

+ (NSArray *)validColors {
  return @[PURPLE,GREEN,RED];
}

+ (NSArray *)validShadings {
  return @[SOLID,STRIPPED,UNFILLED];
}

@end
