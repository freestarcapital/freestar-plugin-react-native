//
//  FreestarNativeAdViewManager.m
//  freestar-plugin-react-native
//
//  Created by Lev Trubov on 6/1/21.
//

#import "FreestarNativeAdViewManager.h"
@import FreestarAds;

static NSString* NATIVE_EVENT_AD_LOADED = @"onNativeAdLoaded";
static NSString* NATIVE_EVENT_AD_FAILED_TO_LOAD = @"onNativeAdFailedToLoad";
static NSString* NATIVE_EVENT_AD_CLICKED = @"onNativeAdClicked";

@interface FreestarNativeAdViewManager () <FreestarNativeAdDelegate>

@property FreestarNativeAd *ad;
@property RCTBubblingEventBlock loadedCallback;
@property RCTBubblingEventBlock loadFailedCallback;
@property RCTBubblingEventBlock clickedCallback;

@end

@implementation FreestarNativeAd (ReactBridge)

-(void)setRequestOptions:(NSDictionary *)options {
    NSDictionary *targetingParams = options[@"targetingParams"];
    if(targetingParams && targetingParams.count > 0) {
        [targetingParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* obj, BOOL * _Nonnull stop) {
            [self addCustomTargeting:key as:obj];
        }];
    }
    
    NSString *placement = options[@"placement"];
    
    [self loadPlacement:placement];
}

-(void)setOnNativeAdLoaded:(RCTBubblingEventBlock)loadedBlock {
    [(id)self.delegate performSelector:@selector(setLoadedCallback:) withObject:loadedBlock];
}

-(void)setOnNativeAdFailedToLoad:(RCTBubblingEventBlock)failedBlock {
    [(id)self.delegate performSelector:@selector(setLoadFailedCallback:) withObject:failedBlock];
}

-(void)setOnNativeAdClicked:(RCTBubblingEventBlock)clickedBlock {
    [(id)self.delegate performSelector:@selector(setClickedCallback:) withObject:clickedBlock];
}

@end

@implementation FreestarNativeAdViewManager

-(FreestarNativeAdSize)adSize {
    return FreestarNativeMedium;
}

- (UIView *)view {
    self.ad = [[FreestarNativeAd alloc] initWithDelegate:self andSize:[self adSize]];
    return self.ad;
}

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

- (void)sendEvent:(RCTBubblingEventBlock)callback type:(NSString *)type payload:(NSDictionary *_Nullable)payload {
  if (!callback) {
    return;
  }

  NSMutableDictionary *event = [@{
      @"type": type,
  } mutableCopy];

  if (payload != nil) {
    [event addEntriesFromDictionary:payload];
  }

  callback(event);
}

#pragma mark - FreestarNativeAdDelegate

- (void)freestarNativeClicked:(nonnull FreestarNativeAd *)ad {
    [self sendEvent:self.clickedCallback type:NATIVE_EVENT_AD_CLICKED payload:@{}];
}

- (void)freestarNativeFailed:(nonnull FreestarNativeAd *)ad because:(FreestarNoAdReason)reason {
    [self sendEvent:self.loadFailedCallback type:NATIVE_EVENT_AD_FAILED_TO_LOAD payload:@{
        @"errorCode" : @(reason)
    }];
}

- (void)freestarNativeLoaded:(nonnull FreestarNativeAd *)ad {
    [self sendEvent:self.loadedCallback type:NATIVE_EVENT_AD_LOADED payload:@{}];
}

- (void)freestarNativeShown:(nonnull FreestarNativeAd *)ad {}
- (void)freestarNativeClosed:(nonnull FreestarNativeAd *)ad {}


@end

@implementation FreestarMrecNativeAdViewManager1
RCT_EXPORT_MODULE(MediumNativeAd);
RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailedToLoad, RCTBubblingEventBlock);
@end

@implementation FreestarMrecNativeAdViewManager2
RCT_EXPORT_MODULE(MediumNativeAd2);
RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailedToLoad, RCTBubblingEventBlock);
@end

@implementation FreestarMrecNativeAdViewManager3
RCT_EXPORT_MODULE(MediumNativeAd3);
RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailedToLoad, RCTBubblingEventBlock);
@end

@implementation FreestarMrecNativeAdViewManager4
RCT_EXPORT_MODULE(MediumNativeAd4);
RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailedToLoad, RCTBubblingEventBlock);
@end

@implementation FreestarSmallNativeAdViewManager

-(FreestarNativeAdSize)adSize {
    return FreestarNativeSmall;
}

@end

@implementation FreestarSmallNativeAdViewManager1
RCT_EXPORT_MODULE(SmallNativeAd);
RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailedToLoad, RCTBubblingEventBlock);
@end

@implementation FreestarSmallNativeAdViewManager2
RCT_EXPORT_MODULE(SmallNativeAd2);
RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailedToLoad, RCTBubblingEventBlock);
@end

@implementation FreestarSmallNativeAdViewManager3
RCT_EXPORT_MODULE(SmallNativeAd3);
RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailedToLoad, RCTBubblingEventBlock);
@end

@implementation FreestarSmallNativeAdViewManager4
RCT_EXPORT_MODULE(SmallNativeAd4);
RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdLoaded, RCTBubblingEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onNativeAdFailedToLoad, RCTBubblingEventBlock);
@end
