//
//  UseCaseHandler.m
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 04..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import "UseCaseHandler.h"

#import "UseCase.h"
#import "UseCaseScheduler.h"
#import "UseCaseNSOperationSheduler.h"

@interface UseCaseHandler()

@property(nonatomic, strong) id<UseCaseScheduler> useCaseSheduler;

- (void)notifyResponse:(id<UseCaseResponse>)response success:(void (^)(id<UseCaseResponse>))success;

- (void)notifyError:(void (^)(void))error;

@end

@implementation UseCaseHandler

- (instancetype)init {
    return [self initWithScheduler:[[UseCaseNSOperationSheduler alloc] init]];
}

- (instancetype)initWithScheduler:(id<UseCaseScheduler>)scheduler {
    self = [super init];
    
    if (self) {
        self.useCaseSheduler = scheduler;
    }
    
    return self;
}

- (void)execute:(UseCase *)useCase withRequest:(id<UseCaseRequest>)request success:(void (^)(id<UseCaseResponse>))success error:(void (^)(void))error {
    useCase.request = request;
    useCase.success = ^(id<UseCaseResponse> response) {
        [self notifyResponse:response success:success];
    };
    
    useCase.error = ^{
        [self notifyError:error];
    };
    
    [self.useCaseSheduler execute:^{
        [useCase run];
    }];
}

- (void)notifyResponse:(id<UseCaseResponse>)response success:(void (^)(id<UseCaseResponse>))success {
    [self.useCaseSheduler notifyResponse:response success:success];
}

- (void)notifyError:(void (^)(void))error {
    [self.useCaseSheduler notifyError:error];
}

@end

