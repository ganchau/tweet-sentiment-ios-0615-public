//
//  FISSharedDataStore.m
//  TweetSentiment
//
//  Created by Gan Chau on 7/9/15.
//  Copyright (c) 2015 Gantastic App. All rights reserved.
//

#import "FISSharedDataStore.h"
#import <STTwitter/STTwitter.h>

@implementation FISSharedDataStore

+ (instancetype)sharedDataStore {
    static FISSharedDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISSharedDataStore alloc] init];
    });
    
    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _averagePolarity = 0;
    }
    return self;
}

// Consumer Key : zfkFrXsTV6teGOZtMwHx09lwI
// Consumer Secret : VO3NYpNoXpP6fKdOztXeCrCDB8iS9yySFdBneVEqv7uuxuJk3n

- (void)getTweetsWithCompletionHandler:(void (^)(BOOL))completionBlock
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"zfkFrXsTV6teGOZtMwHx09lwI"
                                                            consumerSecret:@"VO3NYpNoXpP6fKdOztXeCrCDB8iS9yySFdBneVEqv7uuxuJk3n"];
    
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        [twitter getSearchTweetsWithQuery:@"FlatironSchool"
                             successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                 NSLog(@"Success retrieving tweets:");
                                 
                                 __block CGFloat totalPolarityScore = 0;
                                 __block CGFloat polarityCount = 0;
                                 
                                 for (NSDictionary *tweetDictionary in statuses) {
                                     NSString *tweet = tweetDictionary[@"text"];
                                     //NSLog(@"%@", tweet);
                                     
                                     [self analyzeSentimentWithTweet:tweet
                                                       blockPolarity:^(NSUInteger polarity, NSString *text) {
                                                           NSLog(@"text: %@, polarity: %lu", text, polarity);
                                                           totalPolarityScore += polarity;
                                                           polarityCount++;
                                                           
                                                           if (polarityCount == 15) {
                                                               self.averagePolarity = totalPolarityScore / polarityCount;
                                                               completionBlock(YES);
                                                           }
                                                           
                                                       }];
                                 }
                                 
                                 self.averagePolarity = (CGFloat)totalPolarityScore / (CGFloat)polarityCount;
                                 
                                 
                             } errorBlock:^(NSError *error) {
                                 NSLog(@"Error retrieving tweets: %@", error.description);
                             }];
        
        
        
    } errorBlock:^(NSError *error) {
        NSLog(@"Error verifying credentials: %@", error.description);
    }];
}

- (void)analyzeSentimentWithTweet:(NSString *)tweet blockPolarity:(void (^)(NSUInteger, NSString *))completionBlock
{
    NSString *escapedText = [tweet stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *baseUrlString = @"http://www.sentiment140.com/api/classify?";
    NSString *urlString = [NSString stringWithFormat:@"%@text=%@", baseUrlString, escapedText];
    
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:url
                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                               NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:0
                                                                                                        error:nil];
                                               NSUInteger polarity = [result[@"results"][@"polarity"] floatValue];
                                               NSString *text = result[@"results"][@"text"];
                                               
                                               completionBlock(polarity, text);
                                           }];
    [task resume];
    
}


@end
