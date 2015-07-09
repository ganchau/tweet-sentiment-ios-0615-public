//
//  FISTweetViewController.m
//  TweetSentiment
//
//  Created by Gan Chau on 7/9/15.
//  Copyright (c) 2015 Gantastic App. All rights reserved.
//

#import "FISTweetViewController.h"
#import "FISSharedDataStore.h"

@interface FISTweetViewController()

@property (nonatomic, strong) FISSharedDataStore *sharedData;
@property (weak, nonatomic) IBOutlet UILabel *averagePolarityLabel;

@end

@implementation FISTweetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sharedData = [FISSharedDataStore sharedDataStore];
    
    [self.sharedData getTweetsWithCompletionHandler:^(BOOL success) {
        NSLog(@"Average Polarity: %f", self.sharedData.averagePolarity);
        
        // add to the main thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.averagePolarityLabel.text = [NSString stringWithFormat:@"%.2f", self.sharedData.averagePolarity];
        }];
        
    }];
    

}

@end