//
//  ViewController.m
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/1/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import "ViewController.h"
#import "ItemCollectionViewCell.h"
#import "ShoppingItem.h"
#import "AppDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.activityView.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded) name:@"DataLoaded" object:nil];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.basketTotal.text = [NSString stringWithFormat:@"My basket: %.2f %@", [AppDataManager sharedObject].basketTotal, [AppDataManager sharedObject].currency];
    
    [self.collectionView reloadData];
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(IBAction)reloadData:(id)sender{
    
    self.activityView.hidden = NO;
}

-(void)dataLoaded{
    
    self.activityView.hidden = YES;
    [self.collectionView reloadData];
}


#pragma mark UICollectionViewDelegate methods

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCollectionViewCell *cell = (ItemCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    ShoppingItem *shoppingItem = [[AppDataManager sharedObject].shoppingItems objectAtIndex:indexPath.item];
    NSString *imgName = [NSString stringWithFormat:@"%@.png", [shoppingItem.itemName lowercaseString]];
    cell.image.image = [UIImage imageNamed:imgName];
    cell.item.text = shoppingItem.itemName;
    NSString *currency = [AppDataManager sharedObject].currency;
    cell.price.text = [NSString stringWithFormat:@"%.2f %@ (per %@)", shoppingItem.price.floatValue * [AppDataManager sharedObject].currentCurrencyFactor, currency, shoppingItem.priceUnit];
    cell.tag = indexPath.item;
    cell.addBtn.tag = indexPath.item;
    cell.removeBtn.tag = indexPath.item;
    
    [cell.addBtn addTarget:self action:@selector(addItem:) forControlEvents:UIControlEventTouchUpInside];
    [cell.removeBtn addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.numberInBasket.text = [NSString stringWithFormat:@"%d in basket", [[AppDataManager sharedObject] numberOfItemsInBasket:shoppingItem ]];
    
    return cell;
}

-(void)addItem:(UIButton*)sender{
    
    ShoppingItem *shoppingItem = [[AppDataManager sharedObject].shoppingItems objectAtIndex:sender.tag];
    [[AppDataManager sharedObject] addItem:[shoppingItem copyItem]];
    [self computeBasketTotal];
}

-(void)removeItem:(UIButton*)sender{
    
    ShoppingItem *shoppingItem = [[AppDataManager sharedObject].shoppingItems objectAtIndex:sender.tag];
    [[AppDataManager sharedObject] removeItem:[shoppingItem copyItem]];
    [self computeBasketTotal];
}

-(void)computeBasketTotal{
    
    [[AppDataManager sharedObject] computeBasket];
    
    self.basketTotal.text = [NSString stringWithFormat:@"My basket: %.2f %@", [AppDataManager sharedObject].basketTotal, [AppDataManager sharedObject].currency];
    
    [self.collectionView reloadData];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [AppDataManager sharedObject].shoppingItems.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
