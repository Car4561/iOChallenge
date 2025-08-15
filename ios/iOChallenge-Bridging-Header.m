//
//  iOChallenge-Bridging-Header.m
//  iOChallenge
//
//  Created by Carlos Llerena on 8/15/25.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(SecureCardModule, RCTEventEmitter)

RCT_EXTERN_METHOD(openSecureView:(NSString *)cardId
                  token:(NSString *)token
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
