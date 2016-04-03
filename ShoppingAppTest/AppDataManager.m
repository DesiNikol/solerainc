//
//  AppDataManager.m
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

/** 
 *   AppDataManager - handles the data management in the app, network quieries, and
 *   basket computations
**/

#import "AppDataManager.h"
#import "ShoppingItem.h"
#import "AFNClient.h"

@implementation AppDataManager

static AppDataManager *sharedObject = nil;
static dispatch_once_t onceToken;

+(AppDataManager *)sharedObject
{
    
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
        
        sharedObject.currency = @"British pounds";
        sharedObject.itemsInBasket = [[NSMutableArray alloc] init];
        sharedObject.currentCurrencyFactor = 1.0;
        
        [sharedObject loadItems];
        
        [sharedObject loadCurrencies];
    });
    return sharedObject;
}

-(void)loadItems{
    
    ShoppingItem *peas = [[ShoppingItem alloc] initWithName:@"Peas" withPrice:[NSNumber numberWithFloat:0.95] andPriceUnit:@"bag"];
    ShoppingItem *eggs = [[ShoppingItem alloc] initWithName:@"Eggs" withPrice:[NSNumber numberWithFloat:2.10] andPriceUnit:@"dozen"];
    ShoppingItem *milk = [[ShoppingItem alloc] initWithName:@"Milk" withPrice:[NSNumber numberWithFloat:1.30] andPriceUnit:@"bottle"];
    ShoppingItem *beans = [[ShoppingItem alloc] initWithName:@"Beans" withPrice:[NSNumber numberWithFloat:0.73] andPriceUnit:@"can"];
    
    self.shoppingItems = [[NSMutableArray alloc] initWithObjects:peas, eggs, milk, beans, nil];
}

-(void)addItem:(ShoppingItem*)item
{
    [self.itemsInBasket addObject:item];
}

-(void)removeItem:(ShoppingItem*)item
{
    for(ShoppingItem *it in self.itemsInBasket){
        if([it.itemName isEqualToString:item.itemName])
        {
            [self.itemsInBasket removeObject:it];
            break;
        }
    }
}

-(void)computeBasket
{
    float result = 0;
    for(ShoppingItem *it in self.itemsInBasket){
        result += (it.price.floatValue * self.currentCurrencyFactor);
    }
    
    self.basketTotal = result;
}

-(int)numberOfItemsInBasket:(ShoppingItem*)item
{
    int result = 0;
    for(ShoppingItem *it in self.itemsInBasket){
        if([it.itemName isEqualToString:item.itemName])
        {
            result ++;
        }
    }
    
    return result;
}

/* Currencies and networking */

-(NSString*)currencyAtIndex:(int)index
{
    NSString *symbol = [self.currencies objectAtIndex:index];
    if([symbol isEqualToString:@"USD"])
    {
        return @"US dollar";
    }else if([symbol isEqualToString:@"GBP"])
    {
        return @"British pounds";
    }else if([symbol isEqualToString:@"AUD"])
    {
        return @"Austrailian dollar";
    }else if([symbol isEqualToString:@"CAD"])
    {
        return @"Canadian dollar";
    }
    
    return @"";
}

/** Loading available currencies - please, note that the provided link retuns null  **/

-(void)loadCurrencies
{
    /// !!!! File at specified link does not Exist !!!!  - I will use preset from below
    
    self.currencies = [NSMutableArray arrayWithObjects:@"USD", @"GBP", @"AUD", @"CAD", nil];
    
    /// !!!! File at specified link does not Exist !!!!  - using preset.
    
    //link in the exercise returns null:
    
    [AFNClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [AFNClient sharedClient].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", nil];
    
    [[AFNClient sharedClient] GET:@"currencies.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSLog(@"results %@",JSON);
        //NSArray *results = (NSArray*)[JSON objectForKey:@"currencies"];
        
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        
        NSLog(@"err %@", error.debugDescription);
    }];
}

/** Loading the curruncies rate  **/

-(void)loadRate:(NSString*)symbol{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[AFNClient sharedClient].apiKey forKey:@"access_key"];
   // [params setObject:[AFNClient sharedClient].source forKey:@"source"];
    
    /* Base plan does not support currncy switching so will use one more currency, i.e. GBP, and find
     the cross rate */
    
    NSString *queryCurrencies = [NSString stringWithFormat:@"GBP,%@",symbol];
    [params setObject:queryCurrencies forKey:@"currencies"];
    
    [AFNClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [AFNClient sharedClient].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", nil];
    
    [[AFNClient sharedClient] GET:@"api/live" parameters:params progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSLog(@"results %@",JSON);
        NSDictionary *results = (NSDictionary*)[JSON objectForKey:@"quotes"];
        NSString *resultNewToUSD = [results objectForKey:[NSString stringWithFormat:@"USD%@",symbol]];
        NSString *resultGBPtoUSD = [results objectForKey:@"USDGBP"];
        
        float crossGBPtoUSD = resultGBPtoUSD.floatValue;
        float crossNewToUSD = resultNewToUSD.floatValue;
        
        float newToGBP = crossNewToUSD / crossGBPtoUSD;
        
        self.currentCurrencyFactor = newToGBP;
        
        [self computeBasket];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRecomputeBasket" object:nil];
        
        NSLog(@"%@ to GBP is %f; %f %f",symbol, newToGBP, resultNewToUSD.floatValue, resultGBPtoUSD.floatValue);
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        
        NSLog(@"err %@", error.debugDescription);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to load rates" message:@"This service is not available - please, try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRecomputeBasket" object:nil];
    }];
}


@end
