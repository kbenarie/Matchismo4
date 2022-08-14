//
//  ViewController.m
//  Matchismo
//
//  Created by Keren Ben Arie on 20/07/2022.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardView.h"
#import "Grid.h"

@interface CardGameViewController ()
@property (strong, nonatomic) NSMutableArray<__kindof CardView *> *cardViewsToRemove;
@property (strong, nonatomic) Grid *grid;
@property (nonatomic, strong) Deck *deck;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (nonatomic, getter=isAllowInteract) BOOL allowInteract;
@property (nonatomic, getter=isPinched) BOOL pinched;
@end

@implementation CardGameViewController

-(int)cardsInitialAmount {
  return 0;
}

- (NSMutableArray<CardView *> *)cardViewsToRemove {
    if (!_cardViewsToRemove) {
        _cardViewsToRemove = [NSMutableArray array];
    }
    return _cardViewsToRemove;
}

- (NSMutableArray<CardView *> *)cardViews {
  if (!_cardViews) {
    _cardViews = [NSMutableArray array];
  }
  return _cardViews;
}

- (BOOL)isNeedForAddToBoard {
    BOOL result = NO;
    self.grid.minimumCellsNumber += self.game.cards.count - self.cardViews.count;
    for (NSUInteger i = self.cardViews.count, j = self.boardView.subviews.count; i < self.game.cards.count; i++, j++) {
        NSUInteger row = j / self.grid.columns;
        NSUInteger column = j % self.grid.columns;
        CardView *cardView = [self newCardViewWithFrame:[self.grid frameOfCellAtRow:row inColumn:column]];
        [cardView.tapGesture addTarget:self action:@selector(tapOnCard:)];
        cardView.center = [self centerBoundaryPositionOfView:cardView];
        [self.cardViews addObject:cardView];
        [self.boardView addSubview:cardView];
        result = YES;
    }
    return result;
}

- (BOOL)isNeedForRemoveFromBoard {
    BOOL result = NO;
    for (CardView *view in self.boardView.subviews) {
        if (view.matched) {
            [self.cardViewsToRemove addObject:view];
            result = YES;
        }
    }
    self.grid.minimumCellsNumber -= self.cardViewsToRemove.count;
    return result;
}

- (Grid *)
grid {
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.size = self.boardView.bounds.size;
      _grid.cellAspectRatio = 5.0 / 8.0; // TODO: understand
        _grid.minimumCellsNumber = 0;
    }
    return _grid;
}

- (CardMatchingGame *)game {
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self cardsInitialAmount] usingDeck:[self createDeck]];

  _game.gameMode = [self createGameMode];
  return _game;
}

- (Deck *)createDeck { // abstract
  return nil;
}

- (int)createGameMode { // abstract
  return 0;
}

- (IBAction)touchResetButton:(UIButton *)sender {
  [self.game resetWithCardCount:[self.cardViews count] UsingDeck:[self createDeck]];
  [self updateUI];
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
  NSUInteger mode = sender.selectedSegmentIndex;
  [self.game setGameMode:mode];
}

- (NSAttributedString *)titleForCard:(Card *)card {
  return nil;
}

- (NSAttributedString *)getAttributedTurnDescription:(Turn *)turn {
  return nil;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
  return [UIImage imageNamed:card.isChosen ?  @"cardfront" : @"cardback"];
}
- (void)tapOnCard:(UITapGestureRecognizer *)gesture {
    if (!self.isAllowInteract) {
        return;
    }
    if (![gesture.view isKindOfClass:[CardView class]]) {
        NSLog(@"The Sender of Tap Gesture is NOT CardView");
        return;
    }
    if (self.isPinched) {
        [self updateBoard];
        return;
    }
    CardView *cardView = (CardView *)gesture.view;
    NSUInteger index = [self.cardViews indexOfObject:cardView];
    [self.game chooseCardAtIndex:index];
    [self updateUI];
}

- (void)pinchOnBoard:(UIPinchGestureRecognizer *)gesture {
    if (!self.isAllowInteract) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.numberOfTouches == 2) {
            CGPoint a = [gesture locationOfTouch:0 inView:self.boardView];
            CGPoint b = [gesture locationOfTouch:1 inView:self.boardView];
            CGPoint center = CGPointMake((a.x + b.x) / 2, (a.y + b.y) / 2);
            [UIView animateWithDuration:0.5 animations:^{
                for (CardView *view in self.boardView.subviews) {
                    view.center = center;
                }
            } completion:^(BOOL finished) {
                self.pinched = YES;
            }];
        }
    }
}

//#pragma mark Device Rotation
//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    self.grid.size = self.boardView.bounds.size;
//    [self updateBoard];
//}


#pragma mark - Operations

- (void)updateUI {
    BOOL isNeedForUpdateBoard = NO;
//    self.resetButton.hidden = !self.game.isStarted;
    if (![self is:self.grid.size equalTo:self.boardView.bounds.size]) {
        self.grid.size = self.boardView.bounds.size;
        isNeedForUpdateBoard |= YES;
    }
    isNeedForUpdateBoard |= self.isNeedForAddToBoard;
    [self mapping];
    isNeedForUpdateBoard |= self.isNeedForRemoveFromBoard;
    if (isNeedForUpdateBoard) {
        [self updateBoard];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)updateBoard {
    self.allowInteract = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         for (int i = 0, j = 0; i < self.boardView.subviews.count; i++) {
                             CardView *view = self.boardView.subviews[i];
                             if ([self.cardViewsToRemove containsObject:view]) {
                                 view.center = [self centerBoundaryPositionOfView:view];
                                 continue;
                             }
                             NSUInteger row = j / self.grid.columns;
                             NSUInteger column = j % self.grid.columns;
                             CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];
                             view.frame = frame;
                             j++;
                         }
                     }
                     completion:^(BOOL finished) {
                         for (UIView *view in self.cardViewsToRemove) {
                             [view removeFromSuperview];
                         }
                         [self.cardViewsToRemove removeAllObjects];
                         self.pinched = NO;
                         self.allowInteract = YES;
                     }];
}

- (void)mapping {
    for (int i = 0; i<self.cardViews.count; i++) {
        CardView *cardView = [self.cardViews objectAtIndex:i];
        Card *card = [self.game cardAtIndex:i];
        [self mapCard:card toView:cardView];
    }
}

- (CGPoint)centerBoundaryPositionOfView:(UIView *)view {
    CGFloat y = view.center.y;
    CGFloat x = self.view.bounds.size.width + (view.frame.size.width / 2);
    return CGPointMake(x, y);
}

- (void)clear {
    for (CardView *view in self.boardView.subviews) {
        [view removeFromSuperview];
    }
    [self.cardViews removeAllObjects];
    self.game = nil;
    self.grid = nil;
}

- (BOOL)is:(CGSize)size1 equalTo:(CGSize)size2 {
    return size1.height == size2.height && size1.width == size2.width;
}

#pragma mark - Abstract
- (CardView *)newCardViewWithFrame:(CGRect)frame { return [[CardView alloc] initWithFrame:frame]; }

- (void)setup {
  return;
}

- (BOOL)mapCard:(Card *)card toView:(CardView *)view { return NO; }



#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonSetup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateUI];
}

#pragma mark - Initialization
- (void) commonSetup {
    [self.boardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(pinchOnBoard:)]];
    self.pinched = NO;
    self.allowInteract = YES;
    [self setup];
}



@end

