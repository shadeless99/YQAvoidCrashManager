#import <Foundation/Foundation.h>

// 想要收集crash信息可以注册这个通知
extern NSString *YQAvoidCrashNotification;

@interface YQAvoidCrashManager : NSObject

/**
 * 打开YQAvoidCrash
 */
+ (void)startAvoid;

/**
 *  获取堆栈主要崩溃精简化的信息
 *
 *  @param callStackSymbols 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */
+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols;

/**
 *  提示崩溃的信息(控制台输出、通知)
 *
 *  @param exception   捕获到的异常
 *  @param errorSituation 错误的情况
 */
+ (void)errorWithException:(NSException *)exception errorSituation:(NSString *)errorSituation;

@end
