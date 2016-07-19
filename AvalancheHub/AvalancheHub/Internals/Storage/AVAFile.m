#import "AVAFile.h"

@implementation AVAFile

- (instancetype)initWithPath:(NSString *)filePath fileId:(NSString *)fileId creationDate:(NSDate *)creationDate {
  if (self = [super init]) {
    _filePath = filePath;
    _fileId = fileId;
    _creationDate = creationDate;
  }
  return self;
}

@end