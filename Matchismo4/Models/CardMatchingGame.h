// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import <Foundation/Foundation.h>
#import "Turn.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)resetWithCardCount:(NSUInteger)count UsingDeck:(Deck *)deck;
-(void)setGameMode:(NSUInteger)mode;
-(NSUInteger)gameMode;
- (void)addCards:(int)amount;
@property (nonatomic, getter=isStarted) BOOL started;
@property (nonatomic,strong) Turn *turn;
@property (nonatomic, strong, readonly) NSMutableArray *cards;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, strong) NSMutableArray<Turn *> *history;
@end


