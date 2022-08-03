// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "Deck.h"

@interface Deck ()

@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

- (NSMutableArray *)cards {
  if (!_cards) {
    _cards = [[NSMutableArray alloc] init];
  }
  return _cards;
}


-(void)addCard:(Card *)card atTop:(BOOL)atTop {
  if (atTop) {
    [self.cards insertObject:card atIndex:0];
  } else {
    [self.cards addObject:card];
  }
}

-(void)addCard:(Card *)card {
  [self addCard:card atTop:NO];
}

-(Card *)drawRandomCard {
  Card *randomCard = nil;
  unsigned index = arc4random() % [self.cards count];
  randomCard = self.cards[index];
  [self.cards removeObjectAtIndex:index];
  return randomCard;
}


@end

