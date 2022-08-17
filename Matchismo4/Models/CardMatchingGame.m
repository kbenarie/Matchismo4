// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "CardMatchingGame.h"
#import "Turn.h"

@interface CardMatchingGame ()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSUInteger gameMode;
@property (nonatomic, readwrite) Deck *deck;
@property (nonatomic, strong, readwrite) NSMutableArray *cards;
@end

@implementation CardMatchingGame
static int const MISMATCH_PENALTY = 2;
static int const MATCH_BONUS = 4;
static int const COST_TO_CHOOSE = 1;
static int const GAMEMODE_ADDITION_TO_GET_CARDS = 2;


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
  _deck = deck;
  for (int i=0; i<count; i++){
  Card *card = [deck drawRandomCard];
  if (card){
   [self.cards addObject:card];
    }
  }
//  NSLog(@"init with %d", [self.cards count]);
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

-(void)generateNextTurnAccordingToCurrentTurn {
  if (!self.turn.isMatched) {
    Card *cardToSave = [self.turn.chosenCards lastObject];
    self.turn = [[Turn alloc] initWithCard:cardToSave];
  } else {
    self.turn = [[Turn alloc] init];
  }
}

-(void)makeCardBeChosen:(Card *)card {
  [self.turn.chosenCards addObject:card];
  card.chosen = YES;
}


-(void)makeCardBeUnchosen:(Card *)card {
  card.chosen = NO;
  [self.turn.chosenCards removeObject:card];
}

-(BOOL)didStartedNewTurn {
  return ([self.turn.chosenCards count] > [self amountOfCardsFromCurrentGameMode] - 1);
}

-(BOOL)didChoseEnoughCards {
  return ([self.turn.chosenCards count] == [self amountOfCardsFromCurrentGameMode]);
}

- (void)chooseCardAtIndex:(NSUInteger)index {
  Card *card = [self cardAtIndex:index];
  if (!card.isMatched) {
    if (card.isChosen) {
      [self makeCardBeUnchosen:card];
    } else {
      if ([self didStartedNewTurn]) {
        [self generateNextTurnAccordingToCurrentTurn];
      }
      [self makeCardBeChosen:card];
    }
    if ([self didChoseEnoughCards]) {
      [self handleChosenCardsUsingCard:card andIndex:index];
    }
  }
}

-(void)makeTurnMatchedWithScore:(int) matchScore {
  self.score += matchScore * MATCH_BONUS;
  self.turn.matched = YES;
  self.turn.pointsUpdate = matchScore * MATCH_BONUS;
}


-(void)makeTurnUnmatchedWithPenalty:(int) penalty {
  self.score -= penalty;
  self.turn.matched = NO;
  self.turn.pointsUpdate = penalty;
}

-(void)matchCardsWithScore:(int) matchScore{
  for (Card *otherCard in self.turn.chosenCards) {
    otherCard.matched = YES;
  }
  [self makeTurnMatchedWithScore:matchScore];
}

-(void)unmatchCardsWithCard:(Card *)card andPenalty:(int) penalty{
  for (Card *otherCard in self.turn.chosenCards) {
    if (otherCard != card) {
      otherCard.chosen = NO;
    }
  }
  [self makeTurnUnmatchedWithPenalty:penalty];
  self.score -= COST_TO_CHOOSE;
}


- (void)handleChosenCardsUsingCard:(Card *)card andIndex:(NSUInteger)index {
  int matchScore = [card match:self.turn.chosenCards];
  if (matchScore) {
    [self matchCardsWithScore:matchScore];
  } else {
    int penalty = MISMATCH_PENALTY * (int)(self.gameMode + 1);
    [self unmatchCardsWithCard:card andPenalty:penalty];
    }
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

- (void)addCards:(int)amount {
  for (int i=0; i< amount; ++i) {
    Card *card = [self.deck drawRandomCard];
    if (card){
      [self.cards addObject:card];
    }
  }
}
@end

