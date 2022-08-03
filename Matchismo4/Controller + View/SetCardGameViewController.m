// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "SetCardGameViewController.h"
#import "SetPlayingCardDeck.h"
#import "SetCard.h"
#import "Turn.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

static int const SET_GAME_MODE = 1;
static NSString *const NO_MATCH = @" Not a set! Penalty: ";
static NSString *const MATCH = @" Are a set! Got ";

- (Deck *)createDeck {
  return [[SetPlayingCardDeck alloc] init];
}

-(int)createGameMode {
  return SET_GAME_MODE;
}

-(NSDictionary *)getAttributesForCard:(Card *)card {
  SetCard *setCard = (SetCard *) card;
  UIColor *color = [SetCardGameViewController colorsMapping][setCard.color];
  return [SetCardGameViewController shadingsMappingWithColor:color][setCard.shading];
}

- (NSAttributedString *)titleForCard:(Card *)card {
  if (!card.isChosen) {
    return [[NSMutableAttributedString alloc] initWithString:@""];
  }
  return [self attributedTitle:card];
}

- (NSAttributedString *)attributedTitle:(Card *)card {
NSAttributedString *attributredContents =[[NSMutableAttributedString alloc] initWithString:card.contents attributes:[self getAttributesForCard:card]];
return attributredContents;
}

- (NSAttributedString *)getAttributedTurnDescription:(Turn *)turn {
  NSMutableAttributedString *score = [[NSMutableAttributedString alloc] initWithString:@""];
  if ([turn.chosenCards count] == SET_GAME_MODE + 2) {
    NSString *match = [[NSString alloc] initWithFormat:@"%@%ld points!",turn.matched ? MATCH : NO_MATCH, turn.pointsUpdate];
    [score appendAttributedString:[[NSMutableAttributedString alloc] initWithString:match]];
  }
  NSMutableAttributedString *attributedCards = [[NSMutableAttributedString alloc] initWithString:@""];
  for (Card *card in turn.chosenCards) {
    SetCard *setCard = (SetCard *) card;
    [attributedCards appendAttributedString:[self attributedTitle:setCard]];
  }
  [attributedCards appendAttributedString:score];
  return attributedCards;
}

+ (NSDictionary *)shadingsMappingWithColor:(UIColor *)color {
  return @{SOLID:@{NSForegroundColorAttributeName: color},
           STRIPPED:@{NSStrokeColorAttributeName: color,
                     NSStrokeWidthAttributeName: @(-5),
                     NSForegroundColorAttributeName:[color colorWithAlphaComponent:0.2F]},
           UNFILLED:@{NSStrokeColorAttributeName: color,
                      NSStrokeWidthAttributeName: @(5)}
  };
}

+ (NSDictionary *)colorsMapping {
  return @{PURPLE:[UIColor purpleColor], GREEN:[UIColor greenColor], RED:[UIColor redColor]};
}

@end

