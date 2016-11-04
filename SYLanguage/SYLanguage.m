//
//  SYLanguage.m
//  SYLanguageExample
//
//  Created by Stan Chevallier on 27/07/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYLanguage.h"
#import <objc/runtime.h>

static char *kNSBundle_ForcedLanguageBundle;

@implementation NSObject (SYLanguage)

+ (void)sy_swizzle:(SEL)originalSelector with:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end

@implementation NSBundle (SYLanguage)

+ (void)initSYLanguage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sy_swizzle:@selector(localizedStringForKey:value:table:)
                    with:@selector(sy_localizedStringForKey:value:table:)];

        [self sy_swizzle:@selector(pathForResource:ofType:inDirectory:)
                    with:@selector(sy_pathForResource:ofType:inDirectory:)];
        
        [self sy_swizzle:@selector(pathForResource:ofType:)
                    with:@selector(sy_pathForResource:ofType:)];
    });
}

- (void)setForcedLanguageBundle:(NSBundle *)forcedLanguageBundle
{
    objc_setAssociatedObject(self, kNSBundle_ForcedLanguageBundle, forcedLanguageBundle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSBundle *)forcedLanguageBundle
{
    return objc_getAssociatedObject(self, kNSBundle_ForcedLanguageBundle);
}

- (NSString *)sy_localizedStringForKey:(NSString *)key value:(nullable NSString *)value table:(nullable NSString *)tableName NS_FORMAT_ARGUMENT(1)
{
    NSBundle *bundle = [self forcedLanguageBundle] ?: self;
    return [bundle sy_localizedStringForKey:key value:value table:tableName];
}

- (nullable NSString *)sy_pathForResource:(nullable NSString *)name ofType:(nullable NSString *)ext
{
    NSString *result = [[self forcedLanguageBundle] sy_pathForResource:name ofType:ext];
    return result ?: [self sy_pathForResource:name ofType:ext];
}

- (nullable NSString *)sy_pathForResource:(nullable NSString *)name ofType:(nullable NSString *)ext inDirectory:(nullable NSString *)subpath
{
    NSString *result = [[self forcedLanguageBundle] sy_pathForResource:name ofType:ext inDirectory:subpath];
    return result ?: [self sy_pathForResource:name ofType:ext inDirectory:subpath];
}

@end

@implementation NSUserDefaults (SYLanguage)

+ (void)initSYLanguage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sy_swizzle:@selector(objectForKey:) with:@selector(sy_objectForKey:)];
    });
}

- (nullable id)sy_objectForKey:(nonnull NSString *)defaultName
{
    if ([defaultName isEqualToString:@"AppleLanguages"] ||
        [defaultName isEqualToString:@"NSLanguages"])
    {
        NSString *userLanguage = [SYLanguage userLanguage];
        if (userLanguage) return @[userLanguage];
    }
    if ([defaultName isEqualToString:@"AppleLocale"])
    {
        NSString *userLanguage = [SYLanguage userLanguage];
        if (userLanguage) return userLanguage;
    }
    return [self sy_objectForKey:defaultName];
}

@end

@implementation NSDateFormatter (SYLanguage)

+ (void)initSYLanguage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sy_swizzle:@selector(init) with:@selector(sy_init)];
    });
}

- (instancetype)sy_init
{
    NSDateFormatter *f = [self sy_init];
    [f setLocale:[NSLocale localeWithLocaleIdentifier:[SYLanguage userLanguage]]];
    return f;
}

@end

@implementation NSNumberFormatter (SYLanguage)

+ (void)initSYLanguage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self sy_swizzle:@selector(init) with:@selector(sy_init)];
    });
}

- (instancetype)sy_init
{
    NSNumberFormatter *f = [self sy_init];
    [f setLocale:[NSLocale localeWithLocaleIdentifier:[SYLanguage userLanguage]]];
    return f;
}

@end

@implementation SYLanguage

+ (void)load
{
    [NSBundle        initSYLanguage];
    [NSUserDefaults  initSYLanguage];
    [NSDateFormatter initSYLanguage];
}

+ (void)setUserLanguage:(NSString *)userLanguage
{
    if (userLanguage.length)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
        [[NSBundle mainBundle] setForcedLanguageBundle:[NSBundle bundleWithPath:path]];
        
        [[NSUserDefaults standardUserDefaults] setObject:userLanguage forKey:@"UserLanguage"];
        [[NSUserDefaults standardUserDefaults] setObject:@[userLanguage] forKey:@"AppleLanguages"];
    }
    else
    {
        [[NSBundle mainBundle] setForcedLanguageBundle:nil];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserLanguage"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userLanguage
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserLanguage"];
}

@end

