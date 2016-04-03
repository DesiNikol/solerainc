//
//  BasketViewController.m
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import "BasketViewController.h"
#import "AppDataManager.h"

@interface BasketViewController ()

@end

@implementation BasketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView reloadAllComponents];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecomputeBasket) name:@"DidRecomputeBasket" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.basketTotal.text = [NSString stringWithFormat:@"%.2f %@", [AppDataManager sharedObject].basketTotal, [AppDataManager sharedObject].currency];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)done:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)changeCurrency:(id)sender{
    self.pickerView.hidden = NO;
    self.toolbar.hidden = NO;
}

-(IBAction)save:(id)sender{

    self.pickerView.hidden = YES;
    self.toolbar.hidden = YES;
    
    [AppDataManager sharedObject].currency = [[AppDataManager sharedObject] currencyAtIndex:selectedCurrencyIndex];
    [AppDataManager sharedObject].currentCurrencySymbol = [[AppDataManager sharedObject].currencies objectAtIndex:selectedCurrencyIndex];
    
    self.activityView.hidden = NO;
    
    [[AppDataManager sharedObject] loadRate:[AppDataManager sharedObject].currentCurrencySymbol];
    
}

-(void)didRecomputeBasket{
    
    self.activityView.hidden = YES;
    
    self.basketTotal.text = [NSString stringWithFormat:@"%.2f %@", [AppDataManager sharedObject].basketTotal, [AppDataManager sharedObject].currency];
}

-(IBAction)cancel:(id)sender{
    
    self.pickerView.hidden = YES;
    self.toolbar.hidden = YES;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [AppDataManager sharedObject].currencies.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[AppDataManager sharedObject] currencyAtIndex:(int)row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedCurrencyIndex = (int)row;
    selectedCurrency = [[AppDataManager sharedObject] currencyAtIndex:(int)row];
}


@end
