//
//  AFNClient.m
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/2/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import "AFNClient.h"

static NSString * const AFCurrencies = @"http://apilayer.net/";


//http://www.apilayer.net/api/live?access_key=e1eb5baca6018545eac1a221254012f2


@implementation AFNClient

+ (instancetype)sharedClient {
    static AFNClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFNClient alloc] initWithBaseURL:[NSURL URLWithString:AFCurrencies]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        _sharedClient.apiKey = @"e1eb5baca6018545eac1a221254012f2";
        _sharedClient.source = @"GBP";
    });
    
    return _sharedClient;
}

@end

