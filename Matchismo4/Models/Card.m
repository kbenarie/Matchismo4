// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards {
  int score = 0;
  for (Card *card in otherCards) {
    if ([card.contents isEqualToString:self.contents]) {
      score = 1;
    }
  }
  return score;
}

@end

