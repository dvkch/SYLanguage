//
//  SYLanguage.h
//  SYLanguageExample
//
//  Created by Stan Chevallier on 27/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYLanguage : NSObject
+ (void)setUserLanguage:(NSString *)userLanguage;
+ (NSString *)userLanguage;
@end

