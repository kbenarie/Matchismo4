// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import <Foundation/Foundation.h>

@interface Turn : NSObject
@property (strong, nonatomic) NSMutableArray* chosenCards;
@property (nonatomic, getter=isMatched) BOOL matched;
@property (nonatomic, getter=getPointsUpdate) NSInteger pointsUpdate;
@end
