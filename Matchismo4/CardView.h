// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.
#import <UIKit/UIKit.h>

@interface CardView : UIView
@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) NSInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (strong, nonatomic, readonly) UITapGestureRecognizer *tapGesture;
-(CGFloat)cornerRadius;
-(CGFloat)cornerScaleFactor;
-(CGFloat)cornerOffset;
@end
