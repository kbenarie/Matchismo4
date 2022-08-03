// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "CardMatchingGame.h"
#import "Turn.h"

@interface CardMatchingGame ()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSUInteger gameMode;

@end

@implementation CardMatchingGame
static int const MISMATCH_PENALTY = 2;
static int const MATCH_BONUS = 4;
static int const COST_TO_CHOOSE = 1;
static int const GAMEMODE_ADDITION_TO_GET_CARDS = 2;

- (NSMutableArray<Turn *>*)history {
  if (!_history) _history = [[NSMutableArray<Turn *> alloc] init];
  return _history;
}

- (NSMutableArray *)cards {
  if (!_cards) _cards = [[NSMutableArray alloc] init];
  return _cards;
}

- (Turn *)turn {
  if (!_turn) _turn = [[Turn alloc] init];
  return _turn;
}

- (void)clearDeckFromCards {
  [self.cards removeAllObjects];
}

- (void)initCardsWithCount:(NSInteger)count UsingDeck:(Deck *)deck {
  for (int i=0; i<count; i++){
  Card *card = [deck drawRandomCard];
  if (card){
   [self.cards addObject:card];
    }
  }
}

- (void)resetWithCardCount:(NSUInteger)count UsingDeck:(Deck *)deck {
  self.score = 0;
  [self clearDeckFromCards];
  [self initCardsWithCount:count UsingDeck:deck];
  [self.turn.chosenCards removeAllObjects];
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
  self = [super init];
  if (self) {
    if (count < 2) return self;
    [self initCardsWithCount:count UsingDeck:deck];
  }
  return self;
}

@synthesize gameMode = _gameMode;

-(void)setGameMode:(NSUInteger)mode {
  _gameMode = mode;
}

- (NSUInteger)gameMode{
  return _gameMode;
}

- (void)chooseCardAtIndex:(NSUInteger)index {
  Card *card = [self cardAtIndex:index];
  if (!card.isMatched) {
    if (card.isChosen) {
      card.chosen = NO; // flip it back
      [self.turn.chosenCards removeObject:card];
    } else {
      if ([self.turn.chosenCards count] > [self amountOfCardsFromCurrentGameMode] - 1) {
        self.turn = [[Turn alloc] init];
      }
      [self.turn.chosenCards addObject:card];
      self.score -= COST_TO_CHOOSE;
      card.chosen = YES;
    }
    if ([self.turn.chosenCards count] == [self amountOfCardsFromCurrentGameMode]) {
      [self handleChosenCardsUsingCard:card andIndex:index];
    }
  }
}

- (void)handleChosenCardsUsingCard:(Card *)card andIndex:(NSUInteger)index {
  int matchScore = [card match:self.turn.chosenCards];
  if (matchScore) {
    self.score += matchScore * MATCH_BONUS;
    for (Card *otherCard in self.turn.chosenCards) {
      otherCard.matched = YES;
    }
    self.turn.matched = YES;
    self.turn.pointsUpdate = matchScore * MATCH_BONUS;
  } else {
    int penalty = MISMATCH_PENALTY * (int)(self.gameMode + 1);
    self.score -= penalty;
    for (Card *otherCard in self.turn.chosenCards) {
      otherCard.chosen = NO;
    }
    self.turn.matched = NO;
    self.turn.pointsUpdate = penalty;
  }
  self.score -= COST_TO_CHOOSE;
  [self.history addObject:self.turn];
  }

- (Card *)cardAtIndex:(NSUInteger)index {
  if (index < [self.cards count]) {
    return self.cards[index];
  }
  return nil;
}

- (NSUInteger)amountOfCardsFromCurrentGameMode {
  return self.gameMode + GAMEMODE_ADDITION_TO_GET_CARDS;
}

@end

