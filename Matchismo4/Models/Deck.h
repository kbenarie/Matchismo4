// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.
#import <Foundation/Foundation.h>

#import "Card.h"

@interface Deck : NSObject

-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(void)addCard:(Card *)card;
-(Card *)drawRandomCard;
@property (strong, nonatomic) NSMutableArray *cards;


@end

