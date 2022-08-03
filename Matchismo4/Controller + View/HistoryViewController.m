// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "HistoryViewController.h"

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *historyText;
@end

@implementation HistoryViewController

-(void)setHistoryToPresent:(NSMutableArray<NSAttributedString *> *)historyToPresent {
  _historyToPresent = historyToPresent;
  if (self.view.window) [self updateUI];
}

-(void)viewDidLoad {
  [super viewDidLoad];
  [self updateUI];
}

-(void)updateUI {
  NSMutableAttributedString *history =[[NSMutableAttributedString alloc] initWithAttributedString:[HistoryViewController joinNewLine:self.historyToPresent]];
  UIFont *font = [UIFont fontWithName:@"Avenir-Light" size:18];
  [history addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, history.length)];
  self.historyText.attributedText = history;
}

+(NSMutableAttributedString *)joinNewLine:(NSMutableArray<NSAttributedString *> *)array {
  NSMutableAttributedString *newString = [[NSMutableAttributedString alloc] initWithString:@""];
  NSMutableAttributedString *newLine = [[NSMutableAttributedString alloc] initWithString:@"\n"];
  for (NSAttributedString * attributedString in array) {
    [newString appendAttributedString:attributedString];
    [newString appendAttributedString:newLine];
  }
  return newString;
}

@end
