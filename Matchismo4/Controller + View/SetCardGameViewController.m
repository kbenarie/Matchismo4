// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "SetCardGameViewController.h"
#import "SetPlayingCardDeck.h"
#import "SetCard.h"
#import "Turn.h"
#import "SetCardView.h"
#import "Grid.h"

@interface SetCardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cardLimitReachedLabel;
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@property (weak, nonatomic) IBOutlet UIButton *cardsRequest;
@property (strong, nonatomic) Deck *deck;

@end

@implementation SetCardGameViewController

static int const SET_GAME_MODE = 1;
static int const CARDS_AMOUNT_LIMIT = 81;

-(int)cardsInitialAmount {
  return 12;
}

-(int)extraCardsNumber {
  return 3;
}

#pragma mark - Lazy Inits

- (Deck *)deck {
  if (!_deck) _deck = [[SetPlayingCardDeck alloc] init];
  return _deck;
}

#pragma mark - methods

- (IBAction)requestMoreCards:(UIButton *)sender {
  if ([self.game.cards count] >= CARDS_AMOUNT_LIMIT) {
    [UIView transitionWithView:self.cardLimitReachedLabel
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        self.cardLimitReachedLabel.text = @"Thats enough, Nir!";
    } completion: ^(BOOL finished){
      self.cardLimitReachedLabel.text = @"";
    }];
  } else {
    [self.game addCards:[self extraCardsNumber]];
    [self updateUI];
  }
}

- (Deck *)createDeck {
  NSLog(@"being called");
  return [[SetPlayingCardDeck alloc] init];
}

-(int)createGameMode {
  return SET_GAME_MODE;
}

- (CardView *)newCardViewWithFrame:(CGRect)frame {
  return [[SetCardView alloc] initWithFrame:frame];
}

- (BOOL)mapCard:(Card *)card toView:(CardView *)view {
    if (![card isKindOfClass:[SetCard class]] ||
        ![view isKindOfClass:[SetCardView class]]) {
        return NO;
    }
    SetCardView *cardView = (SetCardView *)view;
    SetCard *setCard = (SetCard *)card;
    cardView.rank = setCard.rank;
    cardView.suit = setCard.suit;
    cardView.color = setCard.color;
    cardView.shading = setCard.shading;
    cardView.selected = setCard.isChosen;
    cardView.enabled = !setCard.isMatched;
    return YES;
}

- (BOOL)isNeedRemoveFromBoard {
    BOOL result = NO;
    for (CardView *view in self.boardView.subviews) {
        if (!view.enabled) {
            [self.cardViewsToRemove addObject:view];
            result = YES;
        }
    }
    self.grid.minimumNumberOfCells -= [self.cardViewsToRemove count];
    return result;
}

@end

