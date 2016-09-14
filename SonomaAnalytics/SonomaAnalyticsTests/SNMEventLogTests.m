#import <Foundation/Foundation.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import "SNMEventLog.h"
#import "SonomaCore+Internal.h"

@interface SNMEventLogTests : XCTestCase

@property(nonatomic, strong) SNMEventLog *sut;

@end

@implementation SNMEventLogTests

@synthesize sut = _sut;

#pragma mark - Houskeeping

- (void)setUp {
  [super setUp];
  _sut = [SNMEventLog new];
}

- (void)tearDown {
  [super tearDown];
}

#pragma mark - Tests

- (void)testSerializingEventToDictionaryWorks {

  // If
  NSString *typeName = @"event";
  NSString *eventId = kSNMUUIDString;
  NSString *eventName = @"eventName";
  SNMDevice *device = [SNMDevice new];
  NSString *sessionId = @"1234567890";
  NSDictionary *properties = @{ @"Key" : @"Value" };
  NSTimeInterval createTime = [[NSDate date] timeIntervalSince1970];
  NSNumber *tOffset = @(createTime);

  self.sut.eventId = eventId;
  self.sut.name = eventName;
  self.sut.device = device;
  self.sut.toffset = tOffset;
  self.sut.sid = sessionId;
  self.sut.properties = properties;

  // When
  NSMutableDictionary *actual = [self.sut serializeToDictionary];

  // Then
  assertThat(actual, notNilValue());
  assertThat(actual[@"id"], equalTo(eventId));
  assertThat(actual[@"name"], equalTo(eventName));
  assertThat(actual[@"device"], notNilValue());
  assertThat(actual[@"sid"], equalTo(sessionId));
  assertThat(actual[@"type"], equalTo(typeName));
  assertThat(actual[@"properties"], equalTo(properties));
  assertThat(actual[@"device"], notNilValue());
  NSTimeInterval seralizedToffset = [actual[@"toffset"] integerValue];
  NSTimeInterval actualToffset = [[NSDate date] timeIntervalSince1970] - createTime;
  assertThat(@(seralizedToffset), lessThan(@(actualToffset)));
}

- (void)testNSCodingSerializationAndDeserializationWorks {

  // If
  NSString *typeName = @"event";
  NSString *eventId = kSNMUUIDString;
  NSString *eventName = @"eventName";
  SNMDevice *device = [SNMDevice new];
  NSString *sessionId = @"1234567890";
  NSNumber *tOffset = @(3);
  NSDictionary *properties = @{ @"Key" : @"Value" };

  self.sut.eventId = eventId;
  self.sut.name = eventName;
  self.sut.device = device;
  self.sut.toffset = tOffset;
  self.sut.sid = sessionId;
  self.sut.properties = properties;

  // When
  NSData *serializedEvent = [NSKeyedArchiver archivedDataWithRootObject:self.sut];
  id actual = [NSKeyedUnarchiver unarchiveObjectWithData:serializedEvent];

  // Then
  assertThat(actual, notNilValue());
  assertThat(actual, instanceOf([SNMEventLog class]));

  SNMEventLog *actualEvent = actual;
  assertThat(actualEvent.name, equalTo(eventName));
  assertThat(actualEvent.eventId, equalTo(eventId));
  assertThat(actualEvent.device, notNilValue());
  assertThat(actualEvent.toffset, equalTo(tOffset));
  assertThat(actualEvent.type, equalTo(typeName));
  assertThat(actualEvent.sid, equalTo(sessionId));
  assertThat(actualEvent.properties, equalTo(properties));
}

@end
