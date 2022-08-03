// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "Turn.h"
#import "Card.h"

@implementation Turn

- (NSMutableArray*)chosenCards {
  if (!_chosenCards) _chosenCards = [[NSMutableArray<Card *> alloc] init];
  return _chosenCards;
}

@end
