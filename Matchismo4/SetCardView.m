// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "SetCardView.h"
#import "SetCard.h"

@interface SetCardView ()
@end

@implementation SetCardView
static NSString* const DIAMOND = @"diamond";
static NSString* const OVAL = @"oval";
static NSString* const SQUIGGLE = @"squiggle";
float const CORNER_RADIUS = 0.1;
float const MARGIN_WIDTH = 0.2;
float const STROKE_WIDTH = 1.0;
float const SYMBOL_HEIGHT = 0.2;
float const SYMBOL_OFFSET = 0.05;
@synthesize selected = _selected;
@synthesize enabled = _enabled;

- (void)drawRect:(CGRect)rect {
  if (self.selected) {
          UIBezierPath *selectBounds = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                                  cornerRadius:[self cornerRadius]];
          [selectBounds setLineWidth:30];
          [[UIColor purpleColor] setStroke];
          [selectBounds stroke];
      }
  // draw the blank card
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width * CORNER_RADIUS];

    [roundedRect addClip];

    // use this for match
    UIColor *cellBackgroundColor = !self.isEnabled ? [UIColor colorWithWhite:0.8 alpha:0.5] : [UIColor whiteColor];

    [cellBackgroundColor setFill];
    UIRectFill(self.bounds);

    // adjust self to color's definitions
    [[self getUIColorForSetCard:self.color] setFill];
    [[self getUIColorForSetCard:self.color] setStroke];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    // set rect of drawing on blank card
    CGRect setRect = CGRectInset(self.bounds, self.bounds.size.width * MARGIN_WIDTH,
                                 self.bounds.size.height * SYMBOL_HEIGHT * 2);

    // draw suit on blank card
    UIBezierPath *symbolPath = [self drawSetSuit:setRect];
    [symbolPath setLineWidth:STROKE_WIDTH];

    CGFloat heightOffset = SYMBOL_HEIGHT + SYMBOL_OFFSET;
    CGFloat offsetSymbol = [self adjustCardOffsetToRank];


  // adjust beizer path to right shading
  CGContextTranslateCTM(context, 0.0, -offsetSymbol);
    for (int i = 0; i < self.rank; i++) {
        if ([self.shading isEqualToString:UNFILLED]) {
            [symbolPath stroke];
        }
        else if ([self.shading isEqualToString:SOLID]) {
            [symbolPath fill];
        }
        else if ([self.shading isEqualToString:STRIPPED]) {
            [symbolPath stroke];
            CGContextSaveGState(context);
            [symbolPath addClip];
            [self addStripes:symbolPath.bounds];
            CGContextRestoreGState(context);
        }
        CGContextTranslateCTM(context, 0.0, self.bounds.size.height * heightOffset);
    }
    CGContextRestoreGState(context);
}

-(CGFloat)adjustCardOffsetToRank {
  CGFloat heightOffset = SYMBOL_HEIGHT + SYMBOL_OFFSET;
  if (self.rank == 2) {
    return self.bounds.size.height * heightOffset / 2;
  }
  else if (self.rank == 3) {
    return self.bounds.size.height * heightOffset;
  }
  return 0.0;
}


- (UIBezierPath *)drawSetSuit:(CGRect) rect {
    UIBezierPath *suit = nil;
    suit = [self BezierSuitMappingWithRect:rect][self.suit];
    return suit;
}

- (NSDictionary<NSString *,UIBezierPath *> *)BezierSuitMappingWithRect:(CGRect) rect {
  return @{DIAMOND:[self drawDiamondSetSuit:rect],
           SQUIGGLE:[self drawSquiggleSuit:rect],
           OVAL:[self drawOvalSetSuit:rect]};
}

+ (NSDictionary *)colorsMapping {
  return @{PURPLE:[UIColor purpleColor], GREEN:[UIColor greenColor], RED:[UIColor redColor]};
}

- (UIBezierPath *)drawSquiggleSuit:(CGRect) rect {
    UIBezierPath *squiggle = [UIBezierPath bezierPath];

    [squiggle moveToPoint:CGPointMake(rect.origin.x , rect.origin.y + rect.size.height * 0.5)];

    [squiggle addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height * 0.125)
                     controlPoint1:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.25)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.125, rect.origin.y + rect.size.height * 0.125)];

    [squiggle addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.625, rect.origin.y + rect.size.height * 0.25)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.365, rect.origin.y + rect.size.height * 0.125)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.25)];

    [squiggle addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.875, rect.origin.y)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y + rect.size.height * 0.25)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y)];

    [squiggle addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.5)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.25)];

    [squiggle addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y + rect.size.height * 0.875)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.75)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.875, rect.origin.y + rect.size.height * 0.875)];

    [squiggle addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.365, rect.origin.y + rect.size.height * 0.75)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.625, rect.origin.y + rect.size.height * 0.875)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.75)];

    [squiggle addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.125, rect.origin.y + rect.size.height)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height * 0.75)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height)];

    [squiggle addCurveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.5)
                     controlPoint1:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)
                     controlPoint2:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.75)];

    [squiggle closePath];


    return squiggle;
}

- (UIBezierPath *)drawDiamondSetSuit:(CGRect) rect {
    UIBezierPath *diamondSymbol = [UIBezierPath bezierPath];
    [diamondSymbol moveToPoint:CGPointMake(rect.origin.x,
                                           rect.origin.y + rect.size.height * 0.5)];
    [diamondSymbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5,
                                              rect.origin.y)];
    [diamondSymbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,
                                              rect.origin.y + rect.size.height * 0.5)];
    [diamondSymbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5,
                                              rect.origin.y + rect.size.height)];
    [diamondSymbol closePath];
    return diamondSymbol;
}

- (UIBezierPath *)drawOvalSetSuit:(CGRect) rect {
    UIBezierPath *ovalSuit = [UIBezierPath bezierPathWithOvalInRect:rect];
    return ovalSuit;
}

- (UIColor *)getUIColorForSetCard:(NSString *) setCardColor {
    UIColor *uiColor = [UIColor blackColor];
    uiColor = [SetCardView colorsMapping][setCardColor];
    return uiColor;
}

#define STRIPE_LINE_GAP 0.1

- (void)addStripes:(CGRect) rect {
    UIBezierPath *stripes = [UIBezierPath bezierPath];
    CGFloat lineGap = rect.size.width * STRIPE_LINE_GAP;
    for (CGFloat i = 0; i < rect.size.width; i += lineGap) {
        [stripes moveToPoint:CGPointMake(rect.origin.x + i, rect.origin.y)];
        [stripes addLineToPoint:CGPointMake(rect.origin.x + i, rect.origin.y + rect.size.height)];
    }
    [stripes stroke];
}

- (void)setShading:(NSString *)shading {
    _shading = nil;
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color {
    _color = nil;
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
    [self setNeedsDisplay];
}


- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        [self setNeedsDisplay];
    }
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        if (enabled) {
            [self addGestureRecognizer:self.tapGesture];
        } else {
            [self removeGestureRecognizer:self.tapGesture];
              }
        _enabled = enabled;
    }
}

#pragma mark - Initialization

-(void)setup {
//
}

-(void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

  }
  return self;
}

@end
