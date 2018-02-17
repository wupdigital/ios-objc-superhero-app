//
//  CharactersUseCase.m
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 04..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import "CharactersUseCase.h"
#import "CharactersDataSource.h"
#import "CharactersRepository.h"
#import "Page.h"

@interface CharactersUseCase()

@property(nonatomic, strong) id<CharactersDataSource> charactersDataSource;

@end

@implementation CharactersUseCase

- (instancetype)init {
    return [self initWithDataSource:[CharactersRepository new]];
}

- (instancetype)initWithDataSource:(id<CharactersDataSource>)charactersDataSource {
    self = [super init];
    
    if (self) {
        self.charactersDataSource = charactersDataSource;
    }
    
    return self;
}

- (void)executeUseCase:(id<UseCaseRequest>)request {
    NSAssert([request isKindOfClass:[CharactersUseCaseRequest class]], @"Use case request must be an instance of CharactersUseCaseRequest class");
    
    CharactersUseCaseRequest *charactersRequest = (CharactersUseCaseRequest *)request;
    
    __weak CharactersUseCase *weakSelf = self;
    
    [self.charactersDataSource loadCharacters:charactersRequest.page complete:^(NSArray<Character *> *characters) {
        CharactersUseCaseResponse * response = [CharactersUseCaseResponse new];
        response.characters = characters;
        weakSelf.success(response);
    } error:^{
        weakSelf.error();
    }];
    
}

- (void)onCharactersLoaded:(NSArray<Character *> *)characters {
    CharactersUseCaseResponse * response = [CharactersUseCaseResponse new];
    response.characters = characters;
    self.success(response);
}

- (void)onCharactersNotLoaded {
    self.error();
}

@end

@implementation CharactersUseCaseRequest

- (instancetype)initWithPage:(Page *)page {
    self = [super init];
    
    if (self) {
        self.page = page;
    }
    
    return self;
}

@end

@implementation CharactersUseCaseResponse

@end
