//
//  ItemCollectionViewCell.h
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIButton *addBtn, *removeBtn;
@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *item, *price, *numberInBasket;

@end
