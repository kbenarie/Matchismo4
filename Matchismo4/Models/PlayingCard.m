// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Keren Ben Arie.

#import "PlayingCard.h"
#import "Card.h"

@implementation PlayingCard

static int const RANK_MATCH_SCORE = 4;
static int const SUIT_MATCH_SCORE = 1;
static float const LESS_MATCHES_THAN_CARDS_PENALTY = 0.1f;
static int const MINIMAL_SCORE_TO_APPLY_PENALTY = 1;

- (int)match:(NSArray *)otherCards {
  int score = 0;
  int matchesCount = 0;
  NSMutableArray *mutableOtherCards = [[NSMutableArray alloc] initWithArray:otherCards];
  [mutableOtherCards removeObject:self];
  for (Card *otherCard in mutableOtherCards) {
    if ([otherCard isKindOfClass:[PlayingCard class]]) {
      PlayingCard *otherPlayingCard = (PlayingCard *) otherCard;
      if ([self.suit isEqualToString:otherPlayingCard.suit]) {
        score += SUIT_MATCH_SCORE;
        matchesCount++;
      } else if (self.rank == otherPlayingCard.rank) {
        score += RANK_MATCH_SCORE;
        matchesCount++;
      }
    }
  }
    if (matchesCount < [otherCards count] && score > MINIMAL_SCORE_TO_APPLY_PENALTY) {
      score -= (score * LESS_MATCHES_THAN_CARDS_PENALTY);
    }
  return score;
}

- (NSString *)contents {
  NSArray *rankStrings = [PlayingCard rankStrings];
  return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit {
  if ([[PlayingCard validSuits] containsObject:suit]){
    _suit = suit;
  }
}

- (NSString *)suit {
  return _suit ? _suit : @"?";
}

+ (NSUInteger)maxRank {
  return [[self rankStrings] count]-1;

}

- (void)setRank:(NSUInteger)rank {
  if (rank <= [PlayingCard maxRank]) {
    _rank = rank;
  }
}

+ (NSArray *)rankStrings {
  return @[@"?", @"A", @"2", @"3",
           @"4", @"5", @"6", @"7",
           @"8", @"9", @"10", @"J",
           @"Q"];
}

+ (NSArray *)validSuits {
  return @[@"♥", @"♠", @"♣",@"♦"];
}

@end


