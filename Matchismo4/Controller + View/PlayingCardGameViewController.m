// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Turn.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()
@property (strong, nonatomic) Deck *deck;
@end

@implementation PlayingCardGameViewController
static int const MATCH_GAME_MODE = 0;
static NSString *const NO_MATCH = @" Don't Match! Penalty: ";
static NSString *const MATCH = @" Match! Got ";

//- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
//  if (!self.playingCardView.faceUp) [self drawRandomPlayingCard];
//  self.playingCardView.faceUp = !self.playingCardView.faceUp;
//}

- (CardView *)newCardViewWithFrame:(CGRect)frame { return [[PlayingCardView alloc] initWithFrame:frame]; }


-(int)cardsInitialAmount {
  return 30;
}

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (Deck *)deck {
  if (!_deck) _deck = [[PlayingCardDeck alloc] init];
  return _deck;
}



- (int)createGameMode {
  return MATCH_GAME_MODE;
}

- (BOOL)mapCard:(Card *)card toView:(CardView *)view {
    if (![card isKindOfClass:[PlayingCard class]] ||
        ![view isKindOfClass:[PlayingCardView class]]) {
        return NO;
    }
    PlayingCardView *cardView = (PlayingCardView *)view;
    PlayingCard *playingCard = (PlayingCard *)card;
    cardView.rank = playingCard.rank;
    cardView.suit = playingCard.suit;
    cardView.selected = playingCard.isChosen;
    cardView.enabled = !playingCard.isMatched;
    return YES;
}



@end

