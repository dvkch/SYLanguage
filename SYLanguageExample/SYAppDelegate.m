//
//  SYAppDelegate.m
//  SYLanguageExample
//
//  Created by Stan Chevallier on 27/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYAppDelegate.h"
#import "SYViewController.h"
#import "SYLanguage.h"

@interface SYAppDelegate ()
@property (nonatomic, assign) BOOL fr;
@end

@implementation SYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self switchLanguage];
    return YES;
}

- (void)switchLanguage
{
    self.fr = !self.fr;
    [SYLanguage setUserLanguage:(self.fr ? @"fr" : @"en")];
    [self loadInterfaceForCurrentLanguage];
    NSLog(@"Switched to %@", [SYLanguage userLanguage]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self switchLanguage];
    });
}

- (void)loadInterfaceForCurrentLanguage
{
    SYViewController *vc = [[SYViewController alloc] init];
    self.window = [[UIWindow alloc] init];
    [self.window makeKeyAndVisible];
    [self.window setFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:vc];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window.layer setMasksToBounds:YES];
    [self.window.layer setOpaque:NO];
}

@end
