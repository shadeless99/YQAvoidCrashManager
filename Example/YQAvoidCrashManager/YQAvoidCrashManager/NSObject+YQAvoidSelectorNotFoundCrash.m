#import "NSObject+YQAvoidSelectorNotFoundCrash.h"
#import "YQAvoidCrashConfig.h"
#import <objc/runtime.h>

@interface YQDoNothingSelectorClass : NSObject

+ (instancetype)sharedInstance;

@end

@implementation YQDoNothingSelectorClass

+ (instancetype)sharedInstance {
	
	static YQDoNothingSelectorClass *class = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		class = [[self alloc] init];
	});
	return class;
}

void doNothingSelector() {}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
	class_addMethod([self class], sel,(IMP)doNothingSelector,"v@:");
	return YES;
}

+ (BOOL)resolveClassMethod:(SEL)sel {
	class_addMethod([self class], sel, (IMP)doNothingSelector, "v@:");
	return YES;
}

@end

@implementation NSObject (YQAvoidSelectorNotFoundCrash)

+ (void)avoidNotFoundSelCrash {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethodSignature];
		[self exchangeForwardInvocation];
	});
}

+ (void)exchangeMethodSignature {
	SEL originalSelector = @selector(methodSignatureForSelector:);
	SEL swizzleSelector = @selector(yq_methodSignatureForSelector:);
	
	YQSWIZZLEWITHCLASS(nil, originalSelector, swizzleSelector);
}

+ (void)exchangeForwardInvocation {
	SEL originalSelector = @selector(forwardInvocation:);
	SEL swizzleSelector = @selector(yq_forwardInvocation:);
	
	YQSWIZZLEWITHCLASS(nil, originalSelector, swizzleSelector);
}

- (NSMethodSignature *)yq_methodSignatureForSelector:(SEL)sel{
	NSMethodSignature *signature;
	signature = [self yq_methodSignatureForSelector:sel];
	if (signature) {
		return signature;
	}
	
	signature = [[YQDoNothingSelectorClass sharedInstance] yq_methodSignatureForSelector:sel];
	if (signature){
		return signature;
	}
	
	return nil;
}

- (void)yq_forwardInvocation:(NSInvocation *)anInvocation{
	[anInvocation invokeWithTarget:[YQDoNothingSelectorClass sharedInstance]];
	NSLog(@"******* unrecognized selctor invoked %@ ", self);
}

@end
