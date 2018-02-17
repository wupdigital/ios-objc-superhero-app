//
//  UseCaseScheduler.h
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 04..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UseCaseResponse;
@protocol UseCaseDelegate;

@protocol UseCaseScheduler <NSObject>

- (void)execute:(void (^)(void))executable;

- (void)notifyResponse:(id<UseCaseResponse>)response success:(void (^)(id<UseCaseResponse>))success;

- (void)notifyError:(void (^)(void))error;

@end
