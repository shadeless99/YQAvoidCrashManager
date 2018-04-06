#import "NSObject+YQAvoidKVOCrash.h"
#import "YQAvoidCrashConfig.h"
#import "YQAvoidCrashManager.h"
#import <objc/runtime.h>

static const void *mapKey = &mapKey;

@interface NSObject()

@property (nonatomic,strong) NSMapTable<id, NSHashTable<NSString *> *> *map;

@end

@implementation NSObject (YQAvoidKVOCrash)

- (NSMapTable<id,NSHashTable<NSString *> *> *)map {
	NSMapTable *map = objc_getAssociatedObject(self, &mapKey);
	if (map) {
		return map;
	} else {
		map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
		objc_setAssociatedObject(self, &mapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		return map;
	}
}

- (void)setMap:(NSMapTable<id,NSHashTable<NSString *> *> *)map {
	if (map) {
		objc_setAssociatedObject(self, mapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

+ (void)avoidCrash {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self addObserver];
		[self removeObserver];
	});
}

/**
  * AddObserver
 */
+ (void)addObserver {
	
	SEL originalSelector = @selector(addObserver:forKeyPath:options:context:);
	SEL swizzleSelector = @selector(yq_addObserver:forKeyPath:options:context:);
	
	YQSWIZZLEWITHCLASS(nil, originalSelector, swizzleSelector);
}

- (void)yq_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
	
	if (!observer || !keyPath) {
		return;
	}

	NSHashTable *hashTable = [self.map objectForKey:observer];
	
	if (!hashTable) {
		hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality capacity:0];
		[hashTable addObject:keyPath];
		[self.map setObject:hashTable forKey:observer];
		[self yq_addObserver:observer forKeyPath:keyPath options:options context:context];
		return;
	}
	
	if ([hashTable containsObject:keyPath]) {
		NSException *exception = [[NSException alloc] initWithName:@"AddObserver" reason:[NSString stringWithFormat:@"%s don't add the same observer and keypath %@ ",__FUNCTION__, self] userInfo:nil];
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"duplicate addObserver"];
		return;
	}
	
	[hashTable addObject:keyPath];
	[self yq_addObserver:observer forKeyPath:keyPath options:options context:context];
	
}

/**
  * RemoveObserver
 */
+ (void)removeObserver {
	SEL originalSelector = @selector(removeObserver:forKeyPath:);
	SEL swizzleSelector = @selector(yq_removeObserver:forKeyPath:);
	YQSWIZZLEWITHCLASS(nil, originalSelector, swizzleSelector);
}

- (void)yq_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
	if(!observer || !keyPath){
		return;
	}

	NSHashTable *hashTable = [self.map objectForKey:observer];
	if (!hashTable) {
		return;
	}
	if (![hashTable containsObject:keyPath]) {
		NSException *exception = [[NSException alloc] initWithName:@"RemoveObserver" reason:[NSString stringWithFormat:@"%s don't remove the keypath not existed %@ ",__FUNCTION__, self] userInfo:nil];
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"duplicate remove observer"];
		return;
	}
	[hashTable removeObject:keyPath];
	[self yq_removeObserver:observer forKeyPath:keyPath];
}

@end
