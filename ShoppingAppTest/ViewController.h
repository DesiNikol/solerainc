//
//  ViewController.h
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>{
    
}

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) IBOutlet UIView *activityView;
@property (nonatomic, retain) IBOutlet UILabel *basketTotal;


@end

