// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MSDocumentMetadata;
@class MSDataError;
@class MSDocumentChange;

@protocol MSDataDelegate <NSObject>

@optional

/**
 * A callback that is called when the device network status gets changed from offine to online mode.
 * The Data operations are then performed against the cosmosDB.
 *
 * @param data The instance of `MSData`.
 * @param operation Operation ran.
 * @param documentMetadata Document metadata that was synchronized. `nil` if error encountered
 * @param error Error details or `nil` when the synchronization was successful
 */
- (void)data:(MSData *)data
    didCompleteRemoteOperation:(NSString *)operation
           forDocumentMetadata:(MSDocumentMetadata *_Nullable)documentMetadata
                     withError:(MSDataError *_Nullable)error;

/**
 * A callback method that will be called whenever a document change notification is received.
 *
 * @param data The instance of `MSData`.
 * @param documentChanges The details of the document changes.
 */
- (void)data:(MSData *)data didReceiveDocumentChangeNotification:(NSArray<MSDocumentChange *> *)documentChanges;

@end

NS_ASSUME_NONNULL_END
