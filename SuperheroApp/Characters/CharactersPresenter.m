//
//  CharactersPresenter.m
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 04..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import "CharactersPresenter.h"
#import "CharactersUseCase.h"
#import "Page.h"
#import "UseCaseHandler.h"

static const NSUInteger DEFAULT_LIMIT = 100;

@interface CharactersPresenter()

@property(nonatomic, weak) id<CharactersMvpView> view;
@property(nonatomic, strong) UseCaseHandler *useCaseHandler;
@property(nonatomic, strong) Page *currentPage;

@end

@implementation CharactersPresenter

- (instancetype)init {
    return [self initWithUseCaseHandler:[UseCaseHandler new]];
}

- (instancetype)initWithUseCaseHandler:(UseCaseHandler *)useCaseHandler {
    self = [super init];
    
    if (self) {
        self.useCaseHandler = useCaseHandler;
        self.currentPage = [[Page alloc] initWithLimit:DEFAULT_LIMIT andOffset:0];
    }
    
    return self;
}

- (void)takeView:(id<MvpView>)view {
    self.view = (id<CharactersMvpView>)view;
    [self loadCharacters];
}

- (void)loadCharacters {
    
    [self.view setLoadingIndicator:YES];
    self.currentPage = [[Page alloc] initWithLimit:DEFAULT_LIMIT andOffset:0];
    CharactersUseCaseRequest *request = [[CharactersUseCaseRequest alloc] initWithPage:self.currentPage];
    
    __weak CharactersPresenter *weakSelf = self;
    
    [self.useCaseHandler execute:[CharactersUseCase new] withRequest:request success:^(id<UseCaseResponse> response) {
        [weakSelf.view setLoadingIndicator:NO];
        
        CharactersUseCaseResponse *charactersResponse = (CharactersUseCaseResponse *)response;
        
        if (charactersResponse.characters.count > 0) {
            [weakSelf.view showCharacters:charactersResponse.characters];
        }
    } error:^{
        [weakSelf.view setLoadingIndicator:NO];
        [weakSelf.view showLoadingCharactersError:@"Something wrong"];
    }];
}

- (void)loadMoreCharacters {
    
    [self.view setMoreLoadingIndicator:YES];
    self.currentPage.offset += DEFAULT_LIMIT;
    CharactersUseCaseRequest *request = [CharactersUseCaseRequest new];
    request.page = self.currentPage;
    
    [self.useCaseHandler execute:[CharactersUseCase new] withRequest:request success:^(id<UseCaseResponse> response) {
        [self.view setMoreLoadingIndicator:NO];
        
        CharactersUseCaseResponse *charactersResponse = (CharactersUseCaseResponse *)response;
        
        if (charactersResponse.characters.count > 0) {
            [self.view showCharacters:charactersResponse.characters];
        }
    } error:^{
        [self.view setMoreLoadingIndicator:NO];
        [self.view showLoadingCharactersError:@"Something wrong"];
    }];
}

@end
