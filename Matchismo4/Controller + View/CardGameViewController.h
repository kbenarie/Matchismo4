//
//  ViewController.h
//  Matchismo
//
//  Created by Keren Ben Arie on 20/07/2022.
// Abstract class

#import <UIKit/UIKit.h>

#import "Deck.h"
#import "CardView.h"
#import "Grid.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray<CardView *> *cardViews;
@property (strong, nonatomic, readonly) Grid  *grid;
@property (nonatomic, getter=isAllowInteract) BOOL allowInteract;
@property (nonatomic, getter=isPinched) BOOL pinched;
@property (strong, nonatomic) NSMutableArray<__kindof CardView *> *cardViewsToRemove;
- (Deck *)createDeck; // abstract
- (int)createGameMode; // abstract
- (CardView *)newCardViewWithFrame:(CGRect)frame;
- (void)setup;
- (BOOL)mapCard:(Card *)card toView:(CardView *)view;
-(int)cardsInitialAmount;
- (CGPoint)centerBoundaryPositionOfView:(UIView *)view;
- (void)updateUI;
@end

