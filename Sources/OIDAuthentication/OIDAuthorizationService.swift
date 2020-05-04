//
//  OIDAuthorizationService.swift
//  AuthenticationKit
//
//  Created by Adam Young on 23/09/2019.
//

import AuthenticationServices
import Combine
import Foundation

public final class OIDAuthorizationService {

  private static let urlSessionConfiguration: URLSessionConfiguration = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    configuration.urlCache = nil
    return configuration
  }()

  public static let shared = OIDAuthorizationService()

  private let dataTaskQueue = DispatchQueue(label: "AuthenticationKit.HTTP.DataTask",
                                            qos: .utility)
  private let streamDataQueue = DispatchQueue(label: "AuthenticationKit.HTTP.StreamData",
                                              qos: .utility)

  private let urlSession: URLSession
  private let decoder: JSONDecoder

  private var authorizationSession: OIDAuthorizationSession?

  init(urlSession: URLSession = .init(configuration: OIDAuthorizationService.urlSessionConfiguration),
       decoder: JSONDecoder = .default) {
    self.urlSession = urlSession
    self.decoder = decoder
  }

  public func authorize(discoveryURL: URL, clientID: String, scopes: Set<String>, redirectURL: URL,
                        additionalParameters: [String: String],
                        presentationContextProvider: ASWebAuthenticationPresentationContextProviding)
    -> AnyPublisher<UserCredential, OIDAuthorizationError> {
      guard authorizationSession == nil else {
        return Fail(error: OIDAuthorizationError.authorizationInProgress)
          .eraseToAnyPublisher()
      }

      let authorizationSession = OIDAuthorizationSession(discoveryURL: discoveryURL, clientID: clientID, scopes: scopes,
                                                         redirectURL: redirectURL,
                                                         additionalParameters: additionalParameters)

      return discoverServiceConfiguration(for: discoveryURL)
        .map { serviceConfiguration -> OIDAuthorizationRequest in
          authorizationSession.update(with: serviceConfiguration)
          let authorizationRequest = OIDAuthorizationRequest(serviceConfiguration: serviceConfiguration,
                                                             clientID: clientID, scopes: scopes,
                                                             redirectURL: redirectURL, responseType: .code,
                                                             additionalParameters: additionalParameters)
          authorizationSession.update(with: authorizationRequest)
          return authorizationRequest
      }
      .receive(on: DispatchQueue.main)
      .flatMap { [unowned self] authorizationRequest in
        self.performAuthorization(request: authorizationRequest,
                                  presentationContextProvider: presentationContextProvider)
      }
      .tryMap { authorizationResponse in
        authorizationSession.update(with: authorizationResponse)
        guard let request = authorizationResponse.tokenExchangeRequest(withAdditionalParameters: additionalParameters) else {
          throw OIDAuthorizationError.noAuthorizationCode
        }

        authorizationSession.update(with: request)
        return request
      }
      .mapError { error in
        error as! OIDAuthorizationError
      }
      .flatMap { [unowned self] tokenRequest in
        self.performTokenExchange(request: tokenRequest)
      }
      .map { tokenResponse in
        authorizationSession.update(with: tokenResponse)
        return UserCredential(serviceConfiguration: authorizationSession.serviceConfiguration!,
                              tokenResponse: tokenResponse)
      }
      .eraseToAnyPublisher()
  }

}

extension OIDAuthorizationService {

  private func discoverServiceConfiguration(for discoveryURL: URL)
    -> AnyPublisher<OIDServiceConfiguration, OIDAuthorizationError> {
      var urlRequest = URLRequest(url: discoveryURL)
      urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

      return urlSession.dataTaskPublisher(for: urlRequest)
        .retry(3)
        .mapError { _ in .network }
        .subscribe(on: dataTaskQueue)
        .receive(on: streamDataQueue)
        .map { $0.data }
        .flatMap { [unowned self] data in
          Just(data)
            .decode(type: OIDServiceConfiguration.self, decoder: self.decoder)
            .mapError { .decoding($0) }
      }
      .eraseToAnyPublisher()
  }

  private func performAuthorization(
    request: OIDAuthorizationRequest, presentationContextProvider: ASWebAuthenticationPresentationContextProviding)
    -> AnyPublisher<OIDAuthorizationResponse, OIDAuthorizationError> {
      Future<OIDAuthorizationResponse, OIDAuthorizationError> { promise in
        let url = request.authorizationRequestURL()
        let callbackURLScheme = request.callbackURLScheme

        let webAuthenticationSession =
          ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme) { callbackURL, error in
            if let error = error {
              promise(.failure(OIDAuthorizationError.webAuthenticationSession(error)))
              return
            }

            guard let callbackURL = callbackURL else {
              promise(.failure(OIDAuthorizationError.webAuthenticationSessionCallbackURL))
              return
            }

            let response = OIDAuthorizationResponse(request: request, callbackURL: callbackURL)
            promise(.success(response))
        }

        webAuthenticationSession.presentationContextProvider = presentationContextProvider

        let safariOpened = webAuthenticationSession.start()
        if !safariOpened {
          webAuthenticationSession.cancel()
          promise(.failure(OIDAuthorizationError.unableToOpenWebView))
          return
        }
      }
      .subscribe(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  private func performTokenExchange(request: OIDTokenRequest) -> AnyPublisher<OIDTokenResponse, OIDAuthorizationError> {
    let urlRequest = request.urlRequest()
    return urlSession.dataTaskPublisher(for: urlRequest)
      .retry(3)
      .mapError { _ in .network }
      .subscribe(on: dataTaskQueue)
      .receive(on: streamDataQueue)
      .map { $0.data }
      .flatMap { [unowned self] data in
        Just(data)
          .decode(type: OIDTokenResponse.self, decoder: self.decoder)
          .mapError { .decoding($0) }
    }
    .eraseToAnyPublisher()
  }

}
