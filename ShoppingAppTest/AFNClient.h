//
//  AFNClient.h
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/2/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNClient : AFHTTPSessionManager

@property(nonatomic, strong)NSString *apiKey, *source;

+ (instancetype)sharedClient;

@end
