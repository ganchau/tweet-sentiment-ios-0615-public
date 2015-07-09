//
//  FISSharedDataStore.h
//  TweetSentiment
//
//  Created by Gan Chau on 7/9/15.
//  Copyright (c) 2015 Gantastic App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FISSharedDataStore : NSObject

@property (nonatomic) CGFloat averagePolarity;

+ (instancetype)sharedDataStore;
- (void)getTweetsWithCompletionHandler:(void (^)(BOOL success))completionBlock;

@end
