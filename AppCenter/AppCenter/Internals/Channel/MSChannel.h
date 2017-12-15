#import <Foundation/Foundation.h>

#import "MSChannelConfiguration.h"
#import "MSConstants+Internal.h"
#import "MSEnable.h"
#import "MSLog.h"
#import "MSSender.h"
#import "MSSenderDelegate.h"
#import "MSStorage.h"

@protocol MSChannelDelegate;
@protocol MSChannel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^MSEnqueueCompletionBlock)(BOOL);
typedef void (^MSForceFlushCompletionBlock)();

/**
 Defines a channel which manages a queue of log items.
 */
@protocol MSChannel <NSObject, MSSenderDelegate, MSEnable>

@required

/**
 * The configuration used by this channel.
 */
@property(nonatomic) MSChannelConfiguration *configuration;

/**
 * Initializes a new `MSChannelDefault` instance.
 *
 * @param sender A sender instance that is used to send batches of log items to
 * the backend.
 * @param storage A storage instance to store and read enqueued log items.
 * @param configuration The configuration used by this channel.
 * @param logsDispatchQueue Queue used to process logs.
 *
 * @return A new `MSChannelDefault` instance.
 */
- (instancetype)initWithSender:(id<MSSender>)sender
                       storage:(id<MSStorage>)storage
                 configuration:(MSChannelConfiguration *)configuration
             logsDispatchQueue:(dispatch_queue_t)logsDispatchQueue;

/**
 * Enqueues a new log item.
 *
 * @param item The log item that should be enqueued.
 * @param completion A completion block that gets called after the item was enqueued.
 */
- (void)enqueueItem:(id<MSLog>)item withCompletion:(nullable MSEnqueueCompletionBlock)completion;

/**
 * Delete all logs from storage.
 *
 * @param error Error describing why all logs are deleted.
 */
- (void)deleteAllLogsWithError:(NSError *)error;

/**
 *  Add delegate.
 *
 *  @param delegate delegate.
 */
- (void)addDelegate:(id<MSChannelDelegate>)delegate;

/**
 *  Remove delegate.
 *
 *  @param delegate delegate.
 */
- (void)removeDelegate:(id<MSChannelDelegate>)delegate;

/**
 * Force flush logs.
 *
 * @param completion Completion block to be called when flush logs process is completed.
 */
- (void)forceFlushWithCompletion:(MSForceFlushCompletionBlock)completion;

/**
 * Cancel stopping logs flushing;
 */
- (void)cancelForceFlushing;


@end

NS_ASSUME_NONNULL_END
