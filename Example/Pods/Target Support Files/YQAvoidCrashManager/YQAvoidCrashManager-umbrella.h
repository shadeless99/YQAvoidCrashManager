#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+YQAvoidCrash.h"
#import "NSDictionary+YQAvoidCrash.h"
#import "NSMutableArray+YQAvoidCrash.h"
#import "NSMutableDictionary+YQAvoidCrash.h"
#import "NSObject+YQAvoidKVOCrash.h"
#import "NSObject+YQAvoidSelectorNotFoundCrash.h"
#import "YQAvoidCrashConfig.h"
#import "YQAvoidCrashManager.h"
#import "YQAvoidRefreshViewNotMainThreadCrash.h"

FOUNDATION_EXPORT double YQAvoidCrashManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char YQAvoidCrashManagerVersionString[];

