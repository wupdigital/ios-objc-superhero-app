//
//  UseCase.h
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 04..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UseCaseRequest <NSObject>

@end

@protocol UseCaseResponse <NSObject>

@end

@interface UseCase : NSObject

@property(nonatomic, strong) id <UseCaseRequest> request;
@property (nonatomic, copy) void (^success)(id<UseCaseResponse>);
@property (nonatomic, copy) void (^error)(void);

- (void)run;

- (void)executeUseCase:(id<UseCaseRequest>) request;

@end
