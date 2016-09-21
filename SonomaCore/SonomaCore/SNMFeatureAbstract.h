/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SNMFeature.h"
#import "SNMConstants+Internal.h"
#import <Foundation/Foundation.h>

/**
 *  Abstraction of features common logic.
 * This class is intended to be subclassed only not instantiated directly.
 */
@interface SNMFeatureAbstract : NSObject <SNMFeature>

/**
 * Get a priority of the feature.
 */
- (enum SNMPriority) getPriority;

@end
