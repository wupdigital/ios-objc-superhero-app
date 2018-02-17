//
//  UseCaseHandler.h
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 04..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UseCase;
@protocol UseCaseRequest;
@protocol UseCaseResponse;
@protocol UseCaseScheduler;

@interface UseCaseHandler : NSObject

- (instancetype)initWithScheduler:(id<UseCaseScheduler>)scheduler NS_DESIGNATED_INITIALIZER;

- (void)execute:(UseCase *)useCase withRequest:(id<UseCaseRequest>)request success:(void (^)(id<UseCaseResponse>))success error:(void (^)(void))error;

@end
