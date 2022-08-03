// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "SetPlayingCardDeck.h"
#import "SetCard.h"

@implementation SetPlayingCardDeck

- (instancetype)init {
  self = [super init];
  if (self) {
    for (NSString *suit in [SetCard validSuits]) {
      for (NSUInteger rank = 1; rank <= [SetCard maxRank]; rank++) {
        for (NSString *shading in [SetCard validShadings]) {
          for (NSString *color in [SetCard validColors]) {
            SetCard *card = [[SetCard alloc] init];
            card.rank = rank;
            card.suit = suit;
            card.color = color;
            card.shading = shading;
            [self addCard:card];
          }
        }
      }
    }
  }
  return self;
}

@end

