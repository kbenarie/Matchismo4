// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "Turn.h"

@implementation Turn

- (instancetype)initWithCard:(Card *)card {
  self = [super init];
  if (self){
    _chosenCards = [[NSMutableArray alloc] initWithArray:@[card]];
      }
  return self;
}

- (NSMutableArray*)chosenCards {
  if (!_chosenCards) _chosenCards = [[NSMutableArray<Card *> alloc] init];
  return _chosenCards;
}


@end
