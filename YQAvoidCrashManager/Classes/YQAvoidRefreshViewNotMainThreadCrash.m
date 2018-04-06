#import "YQAvoidRefreshViewNotMainThreadCrash.h"
#import "YQAvoidCrashManager.h"
#import "YQAvoidCrashConfig.h"
#import <objc/runtime.h>

@implementation YQAvoidRefreshViewNotMainThreadCrash

+ (void)avoidCrash {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self exchangeMethod];
	});
}

+ (void)exchangeMethod {
	SEL oriLayout = @selector(setNeedsLayout);
	SEL swiLayout = @selector(yq_setNeedsLayout);
	YQSWIZZLEWITHCLASS(nil, oriLayout, swiLayout);

	SEL oriDisplay = @selector(setNeedsDisplay);
	SEL swiDisplay = @selector(yq_setNeedsDisplay);
	YQSWIZZLEWITHCLASS(nil, oriDisplay, swiDisplay);

	SEL oriDisplayInRect = @selector(setNeedsDisplayInRect:);
	SEL swiDisplayInRect = @selector(yq_setNeedsDisplayInRect:);
	YQSWIZZLEWITHCLASS(nil, oriDisplayInRect, swiDisplayInRect);

	SEL oriUpdateConstraints = @selector(setNeedsUpdateConstraints);
	SEL swiUpdateConstraints = @selector(yq_setNeedsUpdateConstraints);
	YQSWIZZLEWITHCLASS(nil, oriUpdateConstraints, swiUpdateConstraints);
}

- (void)yq_setNeedsLayout {
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self yq_setNeedsLayout];
	} else {
		NSException *exception = [[NSException alloc]initWithName:@"SetNeedsLayout" reason:[NSString stringWithFormat:@"%s try to update UI not on main thread %@ ",__FUNCTION__, self] userInfo:nil];
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"setNeedsLayout not main thread"];
		dispatch_async(dispatch_get_main_queue(),^{
			[self yq_setNeedsLayout];
		});
	}
}

- (void)yq_setNeedsDisplay {
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self yq_setNeedsDisplay];
	} else {
		
		NSException *exception = [[NSException alloc]initWithName:@"SetNeedsDisplay" reason:[NSString stringWithFormat:@"%s try to update UI not on main thread %@ ",__FUNCTION__, self] userInfo:nil];
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"SetNeedsDisplay not main thread"];
	
		dispatch_async(dispatch_get_main_queue(),^{
			[self yq_setNeedsDisplay];
		});
	}
}

- (void)yq_setNeedsDisplayInRect:(CGRect)rect {
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {

		[self yq_setNeedsDisplayInRect:rect];
	} else {
		
		NSException *exception = [[NSException alloc]initWithName:@"SetNeedsDisplayInRect" reason:[NSString stringWithFormat:@"%s try to update UI not on main thread %@ ",__FUNCTION__, self] userInfo:nil];
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"SetNeedsDisplayInRect not main thread"];
		dispatch_async(dispatch_get_main_queue(),^{
			[self yq_setNeedsDisplayInRect:rect];
		});
	}
}

- (void)yq_setNeedsUpdateConstraints {
	if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
		
		[self yq_setNeedsUpdateConstraints];
	} else {
		
		NSException *exception = [[NSException alloc]initWithName:@"SetNeedsUpdateConstraints" reason:[NSString stringWithFormat:@"%s try to update UI not on main thread %@ ",__FUNCTION__, self] userInfo:nil];
		[YQAvoidCrashManager errorWithException:exception errorSituation:@"SetNeedsUpdateConstraints not main thread"];
		dispatch_async(dispatch_get_main_queue(),^{
			[self yq_setNeedsUpdateConstraints];
		});
	}
}

@end
