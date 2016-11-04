//
//  SYViewController.m
//  SYLanguageExample
//
//  Created by Stan Chevallier on 27/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYViewController.h"
#import "SYLanguage.h"

@interface SYViewController ()
@property (nonatomic, weak) IBOutlet UILabel *labelCode;
@property (nonatomic, weak) IBOutlet UILabel *labelFormat;
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation SYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.labelCode.text = NSLocalizedString(@"TEST_STRING", nil);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterFullStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    self.labelFormat.text = [df stringFromDate:[NSDate date]];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"html"];
    [self.webView loadHTMLString:[NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL] baseURL:nil];
}

@end
