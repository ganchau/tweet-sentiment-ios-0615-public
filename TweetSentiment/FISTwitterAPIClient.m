//
//  FISTwitterAPIClient.m
//  TweetSentiment
//
//  Created by Gan Chau on 7/9/15.
//  Copyright (c) 2015 Gantastic App. All rights reserved.
//

#import "FISTwitterAPIClient.h"
#import <STTwitter/STTwitter.h>

@interface FISTwitterAPIClient ()

@property (strong, nonatomic) NSArray *twitterFeed;

@end

@implementation FISTwitterAPIClient

// Consumer Key : zfkFrXsTV6teGOZtMwHx09lwI
// Consumer Secret : VO3NYpNoXpP6fKdOztXeCrCDB8iS9yySFdBneVEqv7uuxuJk3n

- (void)getTweetsWithCompletionHandler:(void (^)(NSArray *))completionBlock
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"zfkFrXsTV6teGOZtMwHx09lwI"
                                                            consumerSecret:@"VO3NYpNoXpP6fKdOztXeCrCDB8iS9yySFdBneVEqv7uuxuJk3n"];
    
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        [twitter getSearchTweetsWithQuery:@"FlatironSchool"
                             successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                 self.twitterFeed = statuses;
                                 NSLog(@"%@", self.twitterFeed);
                                 
                             } errorBlock:^(NSError *error) {
                                 NSLog(@"%@", error.description);
                             }];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

@end
