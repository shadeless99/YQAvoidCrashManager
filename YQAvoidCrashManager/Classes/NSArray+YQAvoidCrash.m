#import "NSArray+YQAvoidCrash.h"
#import "YQAvoidCrashConfig.h"
#import "YQAvoidCrashManager.h"
#import <objc/runtime.h>

@implementation NSArray (YQAvoidCrash)

+ (void)avoidCrash {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {
	
	Class __NSArray = NSClassFromString(@"NSArray");
	Class __NSArrayI = NSClassFromString(@"__NSArrayI");
	Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
	Class __NSArray0 = NSClassFromString(@"__NSArray0");
	
	SEL oriObjectAtIndex = @selector(objectAtIndex:);
	SEL swiObjectAtIndexI = @selector(yq_objectAtIndexI:);
	SEL swiObjectAtIndexSingleObjectArrayI = @selector(yq_objectAtIndexSingle:);
	SEL swiObjectAtIndex0 = @selector(yq_objectAtIndex0:);
	
	YQSWIZZLEWITHCLASS(__NSArrayI, oriObjectAtIndex, swiObjectAtIndexI);
	YQSWIZZLEWITHCLASS(__NSSingleObjectArrayI, oriObjectAtIndex, swiObjectAtIndexSingleObjectArrayI);
	YQSWIZZLEWITHCLASS(__NSArray0, oriObjectAtIndex, swiObjectAtIndex0);
	
	SEL oriObjectsAtIndexes = @selector(objectsAtIndexes:);
	SEL swiObjectsAtIndexes = @selector(yq_objectsAtIndexes:);
	YQSWIZZLEWITHCLASS(__NSArray, oriObjectsAtIndexes, swiObjectsAtIndexes);
	
	SEL oriGetObjects = @selector(getObjects:range:);
	SEL swiGetObjects0 = @selector(yq_getObjects0:range:);
	SEL swiGetObjectsI = @selector(yq_getObjectsI:range:);
	SEL swiGetObjectsSingle = @selector(yq_getObjectsSingle:range:);
	
	YQSWIZZLEWITHCLASS(__NSArray, oriGetObjects, swiGetObjects0);
	YQSWIZZLEWITHCLASS(__NSSingleObjectArrayI, oriGetObjects, swiGetObjectsI);
	YQSWIZZLEWITHCLASS(__NSArrayI, oriGetObjects, swiGetObjectsSingle);

	SEL oriArrayWithObjects = @selector(arrayWithObjects:count:);
	SEL swiArrayWithObjects = @selector(yq_arrayWithObjects:count:);
	YQSWIZZLEWITHCLASS(nil, oriArrayWithObjects, swiArrayWithObjects);
}


- (NSArray *)yq_objectsAtIndexes:(NSIndexSet *)indexes {
	NSArray *returnArray = nil;
	@try {
		returnArray = [self yq_objectsAtIndexes:indexes];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:[NSString stringWithFormat:@"%s",__FUNCTION__]];
	} @finally {
		return returnArray;
    }
}

- (id)yq_objectAtIndex0:(NSUInteger)index {
	id object = nil;
	@try {
		object = [self yq_objectAtIndex0:index];
	} @catch (NSException *exception) {
		NSString *info = [NSString stringWithFormat:@"%s",__FUNCTION__];
		[YQAvoidCrashManager errorWithException:exception errorSituation:info];
	} @finally {
		return object;
	}
}

- (id)yq_objectAtIndexI:(NSUInteger)index {
	id object = nil;
	@try {
		object = [self yq_objectAtIndexI:index];
	} @catch (NSException *exception) {
		NSString *info = [NSString stringWithFormat:@"%s",__FUNCTION__];
		[YQAvoidCrashManager errorWithException:exception errorSituation:info];
	} @finally {
		return object;
	}
}

- (id)yq_objectAtIndexSingle:(NSUInteger)index {
	id object = nil;
	@try {
		object = [self yq_objectAtIndexSingle:index];
	} @catch (NSException *exception) {
		NSString *info = [NSString stringWithFormat:@"%s",__FUNCTION__];
		[YQAvoidCrashManager errorWithException:exception errorSituation:info];
	} @finally {
		return object;
	}
}


+ (instancetype)yq_arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)count {
	id instance = nil;
	@try {
		instance = [self yq_arrayWithObjects:objects count:count];
	}
	@catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"初始化数组不能为空"];
		
		// 以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
		NSInteger newObjsIndex = 0;
		id  _Nonnull __unsafe_unretained newObjects[count];
		
		for (int i = 0; i < count; i++) {
			if (objects[i] != nil) {
				newObjects[newObjsIndex] = objects[i];
				newObjsIndex++;
			}
		}
		instance = [self yq_arrayWithObjects:newObjects count:newObjsIndex];
	} @finally {
		return instance;
	}
}

- (void)yq_getObjects0:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
	@try {
		[self yq_getObjects0:objects range:range];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"avoid crash --- yq_getObjects"];
	} @finally {
        
	}
}

- (void)yq_getObjectsI:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
	@try {
		[self yq_getObjectsI:objects range:range];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"avoid crash --- yq_getObjects"];
	} @finally {
        
	}
}

- (void)yq_getObjectsSingle:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
	@try {
		[self yq_getObjectsSingle:objects range:range];
	} @catch (NSException *exception) {
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"avoid crash --- yq_getObjects"];
	} @finally {
        
	}
}

@end
