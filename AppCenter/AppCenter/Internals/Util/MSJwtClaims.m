// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import <Foundation/Foundation.h>

#import "MSJwtClaims.h"
#import "MSAppCenterInternal.h"
#import "MSLogger.h"

static NSString *const kMSJwtPartsSeparator = @".";
static NSString *const kMSSubjectClaim = @"sub";
static NSString *const kMSExpirationClaim = @"exp";

@implementation MSJwtClaims

- (instancetype)initWithSubject:(NSString *)subject expiration:(NSDate *)expiration {
  self = [super init];
  if (self) {
    _subject = subject;
    _expiration = expiration;
  }
  return self;
}

+ (MSJwtClaims *)parse:(NSString *_Nullable)jwt {
  if (jwt == nil) {
    MSLogError([MSAppCenter logTag], @"Failed to parse JWT, token is nil.");
    return nil;
  }
  NSArray *parts = [jwt componentsSeparatedByString:kMSJwtPartsSeparator];
  if ([parts count] < 2) {
    MSLogError([MSAppCenter logTag], @"Failed to parse JWT, not enough parts.");
    return nil;
  }
  NSString *base64ClaimsPart = parts[1];
  @try {
    NSError *error;
    NSData *claimsPartData = [[NSData alloc] initWithBase64EncodedString:base64ClaimsPart options:0];
    NSDictionary *claims = [NSJSONSerialization JSONObjectWithData:claimsPartData options:0 error:&error];
    if ([claims objectForKey:kMSExpirationClaim] == nil || [claims objectForKey:kMSSubjectClaim] == nil) {
      MSLogError([MSAppCenter logTag], @"Deserialized claims is missing `sub` or `exp`.");
      return nil;
    }
    NSObject *expirationTimeIntervalSince1970 = [claims objectForKey:kMSExpirationClaim];
    if ([expirationTimeIntervalSince1970 isKindOfClass:[NSNumber class]]) {
      return [[MSJwtClaims alloc] initWithSubject:[claims objectForKey:kMSSubjectClaim]
                                   expiration:[[NSDate alloc] initWithTimeIntervalSince1970:[((NSNumber *)expirationTimeIntervalSince1970) intValue]]];
    }
    return nil;
  } @catch (NSException *e) {
    MSLogError([MSAppCenter logTag], @"Failed to parse JWT: %@", e);
    return nil;
  }
}

@end
