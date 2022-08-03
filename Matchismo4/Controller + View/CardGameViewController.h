//
//  ViewController.h
//  Matchismo
//
//  Created by Keren Ben Arie on 20/07/2022.
// Abstract class

#import <UIKit/UIKit.h>

#import "Deck.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck; // abstract
- (int)createGameMode; // abstract
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@end

