// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Grid : NSObject
// Determinted once.
@property (nonatomic) NSInteger minimumCellsNumber;
@property (nonatomic) CGSize cellSize;
@property (nonatomic) CGFloat cellAspectRatio;
@property (nonatomic) CGFloat minCellWidth;
@property (nonatomic) CGFloat maxCellWidth;   
@property (nonatomic) CGFloat minCellHeight;
@property (nonatomic) CGFloat maxCellHeight;

// Flexiable.
@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger rows;
@property (nonatomic) NSInteger columns;

- (CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;
-(instancetype)initWithMinimumCellsNumber:(NSInteger)minimumCellsNumber andCellSize:(CGSize)cellSize;

@end
