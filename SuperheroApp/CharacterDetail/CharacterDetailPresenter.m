//
//  CharacterDetailPresenter.m
//  SuperheroApp
//
//  Created by Balazs Varga on 2018. 02. 09..
//  Copyright © 2018. W.UP. All rights reserved.
//

#import "CharacterDetailPresenter.h"
#import "GetCharacterUseCase.h"
#import "UseCaseHandler.h"

@interface CharacterDetailPresenter()

@property(nonatomic, weak) id<CharacterDetailMvpView> view;
@property(nonatomic, strong) UseCaseHandler *useCaseHandler;

@end

@implementation CharacterDetailPresenter

- (instancetype)init {
    return [self initWithUseCaseHandler:[UseCaseHandler new]];
}

- (instancetype)initWithUseCaseHandler:(UseCaseHandler *)useCaseHandler {
    self = [super init];
    
    if (self) {
        self.useCaseHandler = useCaseHandler;
    }
    
    return self;
}

- (void)takeView:(id<MvpView>)view {
    self.view = (id<CharacterDetailMvpView>)view;
}

- (void)loadCharacter:(NSString *)characterId {
    [self.view showLoadingIndicator];
    
    GetCharacterRequest *request = [GetCharacterRequest new];
    request.characterId = characterId;
    
    [self.useCaseHandler execute:[GetCharacterUseCase new] withRequest:request success:^(id<UseCaseResponse> response) {
        [self.view hideLoadingIndicator];
        GetCharacterResponse *characterResponse = (GetCharacterResponse *)response;
        [self.view showCharacter:characterResponse.character];
    } error:^{
        [self.view hideLoadingIndicator];
        [self.view showErrorMessage:@"Something wrong!"];
    }];
}

@end
