// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Turn.h"
#import "PlayingCard.h"

@implementation PlayingCardGameViewController
static int const MATCH_GAME_MODE = 0;
static NSString *const NO_MATCH = @" Don't Match! Penalty: ";
static NSString *const MATCH = @" Match! Got ";

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (int)createGameMode {
  return MATCH_GAME_MODE;
}

- (NSAttributedString *)titleForCard:(Card *)card {
  if (!card.isChosen) {
    return [[NSMutableAttributedString alloc] initWithString:@""];
  }
  return [self attributedTitleForCard:card];
}

-(NSAttributedString *)attributedTitleForCard:(Card *)card {
  NSMutableAttributedString *attributredContents =[[NSMutableAttributedString alloc] initWithString:card.contents];
  UIFont *font = [UIFont fontWithName:@"Avenir-Light" size:18];
  [attributredContents addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributredContents.length)];
  return attributredContents;
}

- (NSAttributedString *)getAttributedTurnDescription:(Turn *)turn {
  NSMutableAttributedString *score = [[NSMutableAttributedString alloc] initWithString:@""];
  if ([turn.chosenCards count] == MATCH_GAME_MODE + 2) {
    NSString *match = [[NSString alloc] initWithFormat:@"%@%ld points!",turn.matched ? MATCH : NO_MATCH, turn.pointsUpdate];
    [score appendAttributedString:[[NSMutableAttributedString alloc] initWithString:match]];
  }
  NSMutableAttributedString *attributedCards = [[NSMutableAttributedString alloc] initWithString:@""];
  for (Card *card in turn.chosenCards) {
    PlayingCard *playingCard = (PlayingCard *) card;
    NSMutableAttributedString *playingCardAttributed = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitleForCard:playingCard]];
    [attributedCards appendAttributedString:playingCardAttributed];
  }
  [attributedCards appendAttributedString:score];
  return attributedCards;
}

@end

