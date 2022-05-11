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

#import <React-Core/React/RCTEventEmitter.h>

@interface FreestarReactBridge : RCTEventEmitter <RCTBridgeModule>

@end
