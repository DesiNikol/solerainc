//
//  ShoppingItem.m
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import "ShoppingItem.h"

@implementation ShoppingItem

-(id)initWithName:(NSString*)name withPrice:(NSNumber*)price andPriceUnit:(NSString*)priceUnit
{
    self = [super init];
    self.itemName = name;
    self.price = price;
    self.priceUnit = priceUnit;
    
    return self;
}

-(ShoppingItem*)copyItem
{
    ShoppingItem *item = [[ShoppingItem alloc] initWithName:self.itemName withPrice:self.price andPriceUnit:self.priceUnit];
    
    return item;
}

@end
