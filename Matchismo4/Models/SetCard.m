// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "SetCard.h"

// TODO: change place to H. here for now because of arm duplicates error.
NSString* const DIAMOND = @"diamond";
NSString* const OVAL = @"oval";
NSString* const SQUIGGLE = @"squiggle";
NSString* const PURPLE = @"purple";
NSString* const GREEN = @"green";
NSString* const RED = @"red";
NSString* const SOLID = @"solid";
NSString* const STRIPPED = @"stripped";
NSString* const UNFILLED = @"unfilled";

@implementation SetCard

static int const SCORE = 4;
static NSString *SUIT = @"suit";
static NSString *RANK = @"rank";
static NSString *COLOR = @"color";
static NSString *SHADING = @"shading";

- (int)match:(NSArray<Card *> *)otherCards {
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

+ (NSArray<NSString *> *)rankStrings {
  return @[@"?",@"1", @"2", @"3"];
}

+ (NSArray<NSString *> *)validSuits {
  return @[SQUIGGLE, OVAL, DIAMOND];
}
+ (NSArray<NSString *> *)validColors {
  return @[PURPLE,GREEN,RED];
}

+ (NSArray<NSString *> *)validShadings {
  return @[SOLID,STRIPPED,UNFILLED];
}

@end
