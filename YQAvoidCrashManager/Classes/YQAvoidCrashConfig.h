#ifndef YQAvoidCrashConfig_h
#define YQAvoidCrashConfig_h

#define YQSWIZZLEWITHCLASS(cls, originalSelector, swizzleSelector) { \
		Class class;\
		if (cls) { \
			class = cls; \
		} else { \
			class = [self class]; \
		} \
		Method originalMethod = class_getInstanceMethod(class, originalSelector);\
		Method swizzleMethod = class_getInstanceMethod(class, swizzleSelector);\
		BOOL didAddMethod = class_addMethod(class, \
											originalSelector, \
											method_getImplementation(swizzleMethod),\
											method_getTypeEncoding(swizzleMethod));\
		\
		if (didAddMethod) { \
			class_replaceMethod(class, \
								swizzleSelector, \
								method_getImplementation(originalMethod),\
								method_getTypeEncoding(originalMethod));\
		} else {\
			method_exchangeImplementations(originalMethod, swizzleMethod);\
		}\
}


#endif /* YQAvoidCrashConfig_h */
