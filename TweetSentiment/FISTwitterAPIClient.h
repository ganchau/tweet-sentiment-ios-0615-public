//
//  FISTwitterAPIClient.h
//  TweetSentiment
//
//  Created by Gan Chau on 7/9/15.
//  Copyright (c) 2015 Gantastic App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISTwitterAPIClient : NSObject

// Consumer Key : zfkFrXsTV6teGOZtMwHx09lwI
// Consumer Secret : VO3NYpNoXpP6fKdOztXeCrCDB8iS9yySFdBneVEqv7uuxuJk3n

- (void)getTweetsWithCompletionHandler:(void (^)(NSArray * repositories))completionBlock;

@end
