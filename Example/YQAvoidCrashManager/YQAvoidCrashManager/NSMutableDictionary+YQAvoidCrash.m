#import "NSMutableDictionary+YQAvoidCrash.h"
#import "YQAvoidCrashConfig.h"
#import "YQAvoidCrashManager.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (YQAvoidCrash)

+ (void)avoidCrash {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {
	Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
	
	SEL oriSetObject = @selector(setObject:forKey:);
	SEL swiSetObject = @selector(yq_setObject:forKey:);
	YQSWIZZLEWITHCLASS(dictionaryM, oriSetObject, swiSetObject);
	
	SEL oriRemoveObject = @selector(removeObjectForKey:);
	SEL swiRemoveObject = @selector(sn_removeObjectForKey:);
	YQSWIZZLEWITHCLASS(dictionaryM, oriRemoveObject, swiRemoveObject);
}



- (void)yq_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
	@try {
		[self yq_setObject:anObject forKey:aKey];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"set nil value for dictionary"];
	} @finally {
        
	}
}

- (void)yq_removeObjectForKey:(id)aKey {
	@try {
		[self yq_removeObjectForKey:aKey];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"void crash for removeObjectForKey"];
	} @finally {
        
	}
}

@end
