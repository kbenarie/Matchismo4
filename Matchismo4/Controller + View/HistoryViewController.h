// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<NSAttributedString *> *historyToPresent;
+(NSAttributedString *)joinNewLine:(NSMutableArray<NSAttributedString *> *)array;
@end

