#import "NSMutableArray+YQAvoidCrash.h"
#import "YQAvoidCrashConfig.h"
#import "YQAvoidCrashManager.h"
#import <objc/runtime.h>

@implementation NSMutableArray (YQAvoidCrash)

+ (void)avoidCrash {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {
	Class classM = NSClassFromString(@"__NSArrayM");
	SEL oriObjectAtIndex = @selector(objectAtIndex:);
	SEL swiObjectAtIndex = @selector(yq_objectAtIndex:);
	YQSWIZZLEWITHCLASS(classM, oriObjectAtIndex, swiObjectAtIndex);
	
	SEL oriInsertObject = @selector(insertObject:atIndex:);
	SEL swiInsertObject = @selector(yq_insertObject:atIndex:);
	YQSWIZZLEWITHCLASS(classM, oriInsertObject, swiInsertObject);
	
	SEL oriRemoveObject = @selector(removeObjectAtIndex:);
	SEL swiRemoveObject = @selector(yq_removeObjectAtIndex:);
	YQSWIZZLEWITHCLASS(classM, oriRemoveObject, swiRemoveObject);
	
	SEL oriGetObjects = @selector(getObjects:range:);
	SEL swiGetObjects = @selector(yq_getObjects:range:);
	YQSWIZZLEWITHCLASS(classM, oriGetObjects, swiGetObjects);
}

- (id)yq_objectAtIndex:(NSUInteger)index {
	
	id object = nil;
	
	@try {
		object = [self yq_objectAtIndex:index];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"index cross the border"];
    } @finally {
		return object;
	}
}

- (void)yq_insertObject:(id)anObject atIndex:(NSUInteger)index {
	@try {
		[self yq_insertObject:anObject atIndex:index];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"insert nil"];
	} @finally {
		
	}
}

- (void)yq_removeObjectAtIndex:(NSUInteger)index {
	@try {
		[self yq_removeObjectAtIndex:index];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"avoid crash"];
	} @finally {
		
	}
}

- (void)yq_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
	@try {
		[self yq_getObjects:objects range:range];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"index cross the border"];
	} @finally {
		
	}
}

@end
