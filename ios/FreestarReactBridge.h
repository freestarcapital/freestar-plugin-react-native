//
//  FreestarReactBridge.h
//  FreestarPlatformReactNativePlugin
//
//  Created by Lev Trubov on 6/25/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#else
#import <React-Core/React/RCTBridgeModule.h>
#endif

#if __has_include(<React/RCTEventEmitter.h>)
#import <React/RCTEventEmitter.h>
#else
#import <React-Core/React/RCTEventEmitter.h>
#endif


@interface FreestarReactBridge : RCTEventEmitter <RCTBridgeModule>

@end
