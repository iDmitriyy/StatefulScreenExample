//
//  ProfileInteractor.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

final class ProfileInteractor: PresentableInteractor<ProfilePresentable>, ProfileInteractable {
  // MARK: Dependencies
  
  weak var router: ProfileRouting?
  
  private let profileService: ProfileService
  
  // MARK: Internals
  
  private let _state = BehaviorRelay<ProfileInteractorState>(value: .isLoading)
  
  private let responses = Responses()
  
  private let disposeBag = DisposeBag()
  
  init(presenter: ProfilePresentable,
       profileService: ProfileService) {
    self.profileService = profileService
    super.init(presenter: presenter)
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    loadProfile()
  }
  
  private func loadProfile() {
    profileService.profile { [weak self] result in
      switch result {
      case .success(let profile): self?.responses.$didLoadProfile.accept(profile)
      case .failure(let error): self?.responses.$profileLoadingError.accept(error)
      }
    }
  }
}

// MARK: - IOTransformer

extension ProfileInteractor: IOTransformer {
  private typealias State = ProfileInteractorState
  
  /// Метод производит биндинг переходов между всеми состояниями экрана.
  func transform(input viewOutput: ProfileViewOutput) -> Observable<ProfileInteractorState> {
    let trait = StateTransformTrait(_state: _state, disposeBag: disposeBag)
    
    let requests = makeRequests()
    
    StateTransform.transform(trait: trait, viewOutput: viewOutput, responses: responses, requests: requests)
    
    bindStatefulRouting(viewOutput, trait: trait)
    
    return trait.readOnlyState
  }
  
  private func bindStatefulRouting(_ viewOutput: ProfileViewOutput, trait: StateTransformTrait<State>) {
    let byDataLoadedState = StateTransform.byDataLoadedState
    
    viewOutput.emailUpdateTap.withLatestFrom(trait.readOnlyState).subscribe(onNext: { [weak self] state in
      switch state {
      case .dataLoaded(let profile):
        if profile.email == nil {
          // Если email'a ещё ещё нет - добавляем его
          self?.router?.routeToEmailAddition()
        } else {
          // Ессли уже есть - меняем
          self?.router?.routeToEmailChange()
        }
      default: break
      }
    }).disposed(by: trait.disposeBag)
    
    viewOutput.myOrdersTap.filteredByState(trait.readOnlyState, filter: byDataLoadedState)
      .subscribe(onNext: { [weak self] _ in
        self?.router?.routeToOrdersList()
      }).disposed(by: trait.disposeBag)
  }
}

extension ProfileInteractor {
  /// StateTransform реализует переходы между всеми состояниями. Функции должны быть чистыми и детерминированными
  private enum StateTransform: StateTransformer {
    /// case .isLoading
    static let byDataLoadedState: (State) -> Bool = { state -> Bool in
      guard case .dataLoaded = state else { return false }; return true
    }
    
    /// case .isLoading
    static let byIsLoadingState: (State) -> Bool = { state -> Bool in
      guard case .isLoading = state else { return false }; return true
    }
    
    static func transform(trait: StateTransformTrait<State>,
                          viewOutput: ProfileViewOutput,
                          responses: Responses,
                          requests: Requests) {
      StateTransform.transitions {
        // isLoading => dataLoaded
        responses.didLoadProfile.filteredByState(trait.readOnlyState, filter: byIsLoadingState)
          .map { profile in State.dataLoaded(profile) }
        
        // isLoading => loadingError
        responses.profileLoadingError.filteredByState(trait.readOnlyState, filter: byIsLoadingState)
          .map { error in State.loadingError(error) }
        
        // dataLoaded => isLoading
        // Рефрешим данные при pullToRefresh
        viewOutput.pullToRefresh.filteredByState(trait.readOnlyState, filter: byDataLoadedState)
          .do(onNext: requests.loadProfile)
          .map { State.isLoading }
        
        // loadingError => isLoading
        // При нажатии на кнопку "Повторить" пробуем загрузить данные ешё раз
        viewOutput.retryButtonTap.filteredByState(trait.readOnlyState) { state in
          guard case .loadingError = state else { return false }; return true
        }
        .do(onNext: requests.loadProfile)
        .map { State.isLoading }
      }.bindToAndDisposedBy(trait: trait)
    }
  }
}

// MARK: - Help Methods

extension ProfileInteractor {
  private func makeRequests() -> Requests {
    Requests(loadProfile: { [weak self] in self?.loadProfile() })
  }
}

// MARK: - Nested Types

extension ProfileInteractor {
  private struct Responses {
    @PublishObservable var didLoadProfile: Observable<Profile>
    @PublishObservable var profileLoadingError: Observable<Error>
  }
  
  private struct Requests {
    let loadProfile: VoidClosure
  }
}
