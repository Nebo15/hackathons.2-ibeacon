#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface EBNebo15APIClient : AFHTTPRequestOperationManager

+ (EBNebo15APIClient *)sharedClient;

@end
