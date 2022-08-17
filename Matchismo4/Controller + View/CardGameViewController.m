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
@property (strong, nonatomic) Grid *grid;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation CardGameViewController

#pragma mark - abstract methods

-(int)cardsInitialAmount {
  return 0;
}

- (BOOL)isNeedRemoveFromBoard {
  return NO;
}

- (Deck *)createDeck {
  return nil;
}

- (int)createGameMode {
  return 0;
}

- (CardView *)newCardViewWithFrame:(CGRect)frame {
  return [[CardView alloc] initWithFrame:frame];
}

- (void)setup {
  return;
}

- (BOOL)mapCard:(Card *)card toView:(CardView *)view{
  return NO;
}

#pragma mark - Lazy Initiallizations

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

- (Grid *)grid {
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.size = self.boardView.bounds.size;
      _grid.cellAspectRatio = 5.0 / 8.0;
        _grid.minimumNumberOfCells = 0;
    }
    return _grid;
}

- (CardMatchingGame *)game {
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self cardsInitialAmount] usingDeck:[self createDeck]];

  _game.gameMode = [self createGameMode];
  return _game;
}

#pragma mark - Game Changes

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
  NSUInteger mode = sender.selectedSegmentIndex;
  [self.game setGameMode:mode];
}

- (IBAction)touchResetButton:(UIButton *)sender {
  [self clear];
  [self updateUI];
  }

#pragma mark - Board Updates Check

-(NSUInteger)rowFromIndex:(NSUInteger) index {
  return index / self.grid.columnCount;
}

-(NSUInteger)columnFromIndex:(NSUInteger) index {
  return index % self.grid.columnCount;
}

  - (BOOL)isNeedAddToBoard {
    BOOL result = NO;
    self.grid.minimumNumberOfCells += self.game.cards.count - self.cardViews.count;
    for (NSUInteger i = self.cardViews.count, j = self.boardView.subviews.count; i < self.game.cards.count; i++, j++) {
      CardView *cardView = [self newCardViewWithFrame:[self.grid frameOfCellAtRow:[self rowFromIndex:j] inColumn:[self columnFromIndex:j]]];
      [cardView.tapGesture addTarget:self action:@selector(tapOnCard:)];
      cardView.center = [self centerBoundaryPositionOfView:cardView];
      [self.cardViews addObject:cardView];
      [self.boardView addSubview:cardView];
      result = YES;
    }
    return result;
  }

- (void)mapCardsToCardViews {
  for (int i = 0; i<[self.cardViews count]; i++) {
    CardView *cardView = [self.cardViews objectAtIndex:i];
    Card *card = [self.game cardAtIndex:i];
    [self mapCard:card toView:cardView];
  }
  
}

#pragma mark - Gesture Operations

  - (void)tapOnCard:(UITapGestureRecognizer *)gesture {
    if (!self.isAllowInteract) {
      return;
    }
    if (![gesture.view isKindOfClass:[CardView class]]) {
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


  - (IBAction)panOnBoard:(UIPanGestureRecognizer *)panGesture {
    if (self.isPinched) {
      for (UIView* cardView in self.cardViews) {
        cardView.center = [panGesture locationInView:self.boardView];
      }
    }
  }

  - (IBAction)pinchOnBoard:(UIPinchGestureRecognizer *)gesture {
    if (!self.isAllowInteract) {
      return;
    } else if (gesture.numberOfTouches == 2) {
      CGPoint a = [gesture locationOfTouch:0 inView:self.boardView];
      CGPoint b = [gesture locationOfTouch:1 inView:self.boardView];
      CGPoint center = CGPointMake((a.x + b.x) / 2, (a.y + b.y) / 2);
      [UIView animateWithDuration:0.5
                       animations:^{
        for (CardView *view in self.boardView.subviews) {
          view.center = center;
        }
      } completion:^(BOOL finished) {
        self.pinched = YES;
      }];
    }
  }


- (void)rotationOfBoard:(NSNotification *)note {
  self.grid.size = self.boardView.bounds.size;
  if (!self.isPinched) {
    [self updateBoard];
    [self updateUI];
    }
  }


#pragma mark - Operations

  - (void)updateUI {
    BOOL isNeedForUpdateBoard = NO;
    if (![self is:self.grid.size equalTo:self.boardView.bounds.size]) {
      self.grid.size = self.boardView.bounds.size;
      isNeedForUpdateBoard |= YES;
    }
    isNeedForUpdateBoard |= self.isNeedAddToBoard;
    [self mapCardsToCardViews];
    isNeedForUpdateBoard |= self.isNeedRemoveFromBoard;
    if (isNeedForUpdateBoard) {
      [self updateBoard];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
  }

-(CGRect)getNewFrameFromIndex:(NSUInteger) index {
  NSUInteger row = index / self.grid.columnCount;
  NSUInteger column = index % self.grid.columnCount;
  return [self.grid frameOfCellAtRow:row inColumn:column];
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
        view.frame = [self getNewFrameFromIndex:j];
        j++;
      }
    }
                     completion:^(BOOL finished) {
      for (CardView *view in self.cardViewsToRemove) {
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
    [self.boardView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(panOnBoard:)]];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
       addObserver:self selector:@selector(rotationOfBoard:)
       name:UIDeviceOrientationDidChangeNotification
       object:[UIDevice currentDevice]];
    self.pinched = NO;
    self.allowInteract = YES;
    [self setup];
  }


@end

