#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "EBMember.h"

@interface EBNebo15APIClient : AFHTTPRequestOperationManager

+ (EBNebo15APIClient *)sharedClient;
- (void)checkInWithMember:(EBMember*)member completion:(void(^)(BOOL))completion;
- (void)checkOutWithMember:(EBMember*)member completion:(void(^)(BOOL))completion;

@end
