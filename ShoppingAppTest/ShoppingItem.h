//
//  ShoppingItem.h
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingItem : NSObject

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *priceUnit;

-(id)initWithName:(NSString*)name withPrice:(NSNumber*)price andPriceUnit:(NSString*)priceUnit;
-(ShoppingItem*)copyItem;

@end
