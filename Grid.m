// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "Grid.h"

@interface Grid ()
@property (nonatomic) BOOL resolved;
@property (nonatomic) BOOL unresolvable;
@end

@implementation Grid

-(instancetype)initWithMinimumCellsNumber:(NSInteger)minimumCellsNumber andCellSize:(CGSize)cellSize {
  self = [super init];
  if (self) {
    _minimumCellsNumber = minimumCellsNumber;
    _cellSize = cellSize;
  }
  return self;
}

- (void)validate
{
    if (self.resolved) return;    // already valid, nothing to do
    if (self.unresolvable) return;  // already tried to validate and couldn't

    double overallWidth = ABS(self.size.width);
    double overallHeight = ABS(self.size.height);
    double aspectRatio = ABS(self.cellAspectRatio);

    if (!self.minimumCellsNumber || !aspectRatio || !overallWidth || !overallHeight) {
        self.unresolvable = YES;
        return; // invalid inputs
    }

    double minCellWidth = self.minimumCellsNumber;
    double minCellHeight = self.minCellHeight;
    double maxCellWidth = self.maxCellWidth;
    double maxCellHeight = self.maxCellHeight;

    BOOL flipped = NO;
    if (aspectRatio > 1) {
        flipped = YES;
        overallHeight = ABS(self.size.width);
        overallWidth = ABS(self.size.height);
        aspectRatio = 1.0/aspectRatio;
        minCellWidth = self.minCellHeight;
        minCellHeight = self.minCellWidth;
        maxCellWidth = self.maxCellHeight;
        maxCellHeight = self.maxCellWidth;
    }

    if (minCellWidth < 0) minCellWidth = 0;
    if (minCellHeight < 0) minCellHeight = 0;

    int columnCount = 1;
    while (!self.resolved && !self.unresolvable) {
        double cellWidth = overallWidth / (double)columnCount;
        if (cellWidth <= minCellWidth) {
            self.unresolvable = YES;
        } else {
            double cellHeight = cellWidth / aspectRatio;
            if (cellHeight <= minCellHeight) {
                self.unresolvable = YES;
            } else {
                int rowCount = (int)(overallHeight / cellHeight);
                if ((rowCount * columnCount >= self.minimumCellsNumber) &&
                    ((maxCellWidth <= minCellWidth) || (cellWidth <= maxCellWidth)) &&
                    ((maxCellHeight <= minCellHeight) || (cellHeight <= maxCellHeight))) {
                    if (flipped) {
                        self.rows = columnCount;
                        self.columns = rowCount;
                      self.cellSize = CGSizeMake( cellHeight,  cellWidth);
                    } else {
                        self.rows = rowCount;
                        self.columns = columnCount;
                        self.cellSize = CGSizeMake(cellWidth, cellHeight);
                    }
                    self.resolved = YES;
                }
                columnCount++;
            }
        }
    }

    if (!self.resolved) {
        self.rows = 0;
        self.columns = 0;
        self.cellSize = CGSizeZero;
    }
}

- (void)setResolved:(BOOL)resolved
{
    self.unresolvable = NO;
    _resolved = resolved;
}

- (BOOL)inputsAreValid
{
    [self validate];
    return self.resolved;
}

- (CGPoint)centerOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column
{
    CGPoint center = CGPointMake(self.cellSize.width/2, self.cellSize.height/2);
    center.x += column * self.cellSize.width;
    center.y += row * self.cellSize.height;
    return center;
}

- (CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column
{
    CGRect frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
    frame.origin.x += column * self.cellSize.width;
    frame.origin.y += row * self.cellSize.height;
    return frame;
}

- (void)setMinimumCellsNumber:(NSInteger)minimumCellsNumber
{
    if (_minimumCellsNumber != minimumCellsNumber) self.resolved = NO;
  _minimumCellsNumber = minimumCellsNumber;
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(size, _size)) self.resolved = NO;
    _size = size;
}

- (void)setCellAspectRatio:(CGFloat)cellAspectRatio
{
    if (ABS(cellAspectRatio) != ABS(_cellAspectRatio)) self.resolved = NO;
    _cellAspectRatio = cellAspectRatio;
}

- (void)setMinCellHeight:(CGFloat)minCellHeight
{
    if (minCellHeight != _minCellHeight) self.resolved = NO;
    _minCellHeight = minCellHeight;
}

- (void)setMaxCellHeight:(CGFloat)maxCellHeight
{
    if (maxCellHeight != _maxCellHeight) self.resolved = NO;
    _maxCellHeight = maxCellHeight;
}

- (void)setMinCellWidth:(CGFloat)minCellWidth
{
    if (minCellWidth != _minCellHeight) self.resolved = NO;
    _minCellWidth = minCellWidth;
}

- (void)setMaxCellWidth:(CGFloat)maxCellWidth
{
    if (maxCellWidth != _maxCellWidth) self.resolved = NO;
    _maxCellWidth = maxCellWidth;
}

- (NSInteger)rows
{
    [self validate];
    return _rows;
}

- (NSInteger)columns
{
    [self validate];
    return _columns;
}

- (CGSize)cellSize
{
    [self validate];
    return _cellSize;
}

@end
