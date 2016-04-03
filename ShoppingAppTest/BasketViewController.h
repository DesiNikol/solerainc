//
//  BasketViewController.h
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasketViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSString *selectedCurrency;
    int selectedCurrencyIndex;
}

@property (nonatomic, retain) IBOutlet UILabel *basketTotal;
@property (nonatomic, retain) IBOutlet UIView *activityView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;

-(IBAction)done:(id)sender;

@end
