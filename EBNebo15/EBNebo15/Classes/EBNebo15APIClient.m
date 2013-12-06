#import "EBNebo15APIClient.h"

static NSString * const kEBNebo15APIBaseURLString = @"http://hackaton.2-ibeacon.nebo15.me/";

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

#pragma mark - Check in/out user

- (void)checkInWithMember:(EBMember *)member completion:(void (^)(BOOL))completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@persons/%@.json", kEBNebo15APIBaseURLString, [member.name stringByReplacingOccurrencesOfString:@" " withString:@""]] parameters:@{@"id":member.facebookID,
                                                                                                                                                                                   @"name":member.name,
                                                                                                                                                                                   @"email":member.email,
                                                                                                                                                                                   @"link":member.link,
                                                                                                                                                                                   @"userpic":member.facebookID,
                                                                                                                                                                                   @"statusID":@(member.statusID)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO);
    }];
}

- (void)checkOutWithMember:(EBMember *)member completion:(void (^)(BOOL))completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager DELETE:[NSString stringWithFormat:@"%@persons/%@.json", kEBNebo15APIBaseURLString, [member.name stringByReplacingOccurrencesOfString:@" " withString:@""]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(YES);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - User list

- (void)getUserListWithCompletion:(void(^)(BOOL, NSArray*))completion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@person.json", kEBNebo15APIBaseURLString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completion(YES, [responseObject isKindOfClass:[NSDictionary class]]? [responseObject allValues]:nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(NO, nil);
    }];
}

@end
