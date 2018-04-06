#import "NSDictionary+YQAvoidCrash.h"
#import "YQAvoidCrashConfig.h"
#import "YQAvoidCrashManager.h"
#import <objc/runtime.h>

@implementation NSDictionary (YQAvoidCrash)

+ (void)avoidCrash {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {
	SEL originalSelector = @selector(dictionaryWithObjects:forKeys:count:);
	SEL swizzleSelector = @selector(yq_dictionaryWithObjects:forKeys:count:);
	
	YQSWIZZLEWITHCLASS(nil, originalSelector, swizzleSelector);
}

+ (instancetype)yq_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cout {
	id instance = nil;
	
	@try {
		instance = [self yq_dictionaryWithObjects:objects forKeys:keys count:cout];
	} @catch (NSException *exception) {

		[YQAvoidCrashManager errorWithException:exception errorSituation:@"avoid dic key-value is nil"];
		
		NSUInteger index = 0;
		id  _Nonnull __unsafe_unretained newObjects[cout];
		id  _Nonnull __unsafe_unretained newkeys[cout];
		
		for (int i = 0; i < cout; i++) {
			if (objects[i] && keys[i]) {
				newObjects[index] = objects[i];
				newkeys[index] = keys[i];
				index++;
			}
		}
		instance = [self yq_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
	} @finally {
		return instance;
	}
}

@end
