//
//  DetailsViewController.m
//  ShoppingAppTest
//
//  Created by Desi Nikolova on 4/2/16.
//  Copyright © 2016 Desi Nikolova. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)done:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
