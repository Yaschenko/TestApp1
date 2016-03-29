//
//  DetailViewController.m
//  TestApp
//
//  Created by Yurii on 3/29/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"

@interface DetailViewController()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end
@implementation DetailViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.item.title;
    [self.webView loadHTMLString:self.item.descriptionHTML baseURL:nil];
}
@end
