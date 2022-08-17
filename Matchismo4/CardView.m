// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "CardView.h"

@implementation CardView

float const DEFAULT_FACE_CARD_SCALE_FACTOR = 0.90;
float const CORNER_FONT_STANDART_HEIGHT = 180.0;
static float const CORNER_RADIUS = 12.0;

@synthesize tapGesture = _tapGesture;

-(UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
    }
    return _tapGesture;
}

- (void)setSelected:(BOOL)selected {
}

-(void)setSuit:(NSString *)suit {
  _suit = suit;
  [self setNeedsDisplay];
}

-(void)setRank:(NSInteger)rank {
  _rank = rank;
  [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp {
  _faceUp = faceUp;
  [self setNeedsDisplay];
}

-(CGFloat)cornerScaleFactor {
  return self.bounds.size.height / CORNER_FONT_STANDART_HEIGHT;
}

-(CGFloat)cornerRadius {
  return CORNER_RADIUS * [self cornerScaleFactor];
}

-(CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

#pragma mark - Initialization
- (void)commonSetup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    [self setup];
}

-(void)setup {
  return;
}

-(void)awakeFromNib {
  [super awakeFromNib];
  [self commonSetup];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonSetup];
  }
  return self;
}
@end
