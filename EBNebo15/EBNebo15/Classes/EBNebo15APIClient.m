#import "EBNebo15APIClient.h"

static NSString * const kEBNebo15APIBaseURLString = @"<# API Base URL #>";

@implementation EBNebo15APIClient

+ (EBNebo15APIClient *)sharedClient {
    static EBNebo15APIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kEBNebo15APIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

@end
