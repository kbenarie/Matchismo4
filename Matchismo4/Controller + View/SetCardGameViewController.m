// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "SetCardGameViewController.h"
#import "SetPlayingCardDeck.h"
#import "SetCard.h"
#import "Turn.h"
#import "SetCardView.h"
#import "Grid.h"

@interface SetCardGameViewController ()

@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehaviour;
@property (weak, nonatomic) IBOutlet UIView *card;
@property (strong, nonatomic) Deck *deck;

@end

@implementation SetCardGameViewController

static int const SET_GAME_MODE = 1;

-(int)cardsInitialAmount {
  return 12;
}
#pragma mark - Lazy Inits

-(UIDynamicAnimator *)animator {
  if (!_animator) _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.card];
  return _animator;
}

-(UIAttachmentBehavior *)attachmentBehaviour {
  if (!_attachmentBehaviour) _attachmentBehaviour = [[UIAttachmentBehavior alloc] init];
  return _attachmentBehaviour;
}

- (Deck *)deck {
  if (!_deck) _deck = [[SetPlayingCardDeck alloc] init];
  return _deck;
}

#pragma mark - methods

- (Deck *)createDeck {
  return [[SetPlayingCardDeck alloc] init];
}

-(int)createGameMode {
  return SET_GAME_MODE;
}

- (CardView *)newCardViewWithFrame:(CGRect)frame { return [[SetCardView alloc] initWithFrame:frame];
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

@end

