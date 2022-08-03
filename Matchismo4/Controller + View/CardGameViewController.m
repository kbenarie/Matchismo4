//
//  ViewController.m
//  Matchismo
//
//  Created by Keren Ben Arie on 20/07/2022.
//

#import "HistoryViewController.h"
#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCard.h"

@interface CardGameViewController ()

@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) NSMutableArray<NSAttributedString *> *descriptionsHistory;
@end

@implementation CardGameViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
      HistoryViewController *destination = (HistoryViewController *)segue.destinationViewController;
      destination.historyToPresent = self.descriptionsHistory;
  }
}
- (NSMutableArray<NSAttributedString *> *)descriptionsHistory {
  if (!_descriptionsHistory) _descriptionsHistory = [[NSMutableArray alloc] init];
  return _descriptionsHistory;
}

- (CardMatchingGame *)game {
  if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
  _game.gameMode = [self createGameMode];
  return _game;
}

- (Deck *)deck {
  if (!_deck) _deck = [self createDeck];
  return _deck;
}

- (Deck *)createDeck { // abstract
  return nil;
}

- (int)createGameMode { // abstract
  return 0;
}

- (IBAction)touchCardButton:(UIButton *)sender {
  NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:cardIndex];
  [self updateUI];
}

- (IBAction)touchResetButton:(UIButton *)sender {
  [self.game resetWithCardCount:[self.cardButtons count] UsingDeck:[self createDeck]];
  [self updateUI];
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
  NSUInteger mode = sender.selectedSegmentIndex;
  [self.game setGameMode:mode];
}

- (void)updateUI {
  for (UIButton *cardButton in self.cardButtons) {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
    Card *card = [self.game cardAtIndex:cardIndex];
    [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
  }
  NSAttributedString *turnDescription = [self getAttributedTurnDescription:self.game.turn];
  self.currentResultLabel.attributedText = turnDescription;
  [self.descriptionsHistory addObject:turnDescription];
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
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

@end
