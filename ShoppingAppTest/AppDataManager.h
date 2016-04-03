//
//  AppDataManager.h
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingItem.h"

@interface AppDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *shoppingItems;
@property (nonatomic, strong) NSMutableArray *itemsInBasket;
@property (nonatomic, strong) NSMutableArray *currencies;
@property (nonatomic, strong) NSString *currency, *currentCurrencySymbol;
@property (nonatomic, assign) float basketTotal, currentCurrencyFactor;

+(AppDataManager *)sharedObject;
-(void)computeBasket;

-(void)addItem:(ShoppingItem*)item;
-(void)removeItem:(ShoppingItem*)item;

-(int)numberOfItemsInBasket:(ShoppingItem*)item;

-(NSString*)currencyAtIndex:(int)index;
-(void)loadRate:(NSString*)symbol;

@end
