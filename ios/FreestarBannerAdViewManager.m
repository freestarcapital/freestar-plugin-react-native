//
//  FreestarBannerAdViewManager.m
//  CocoaAsyncSocket
//
//  Created by Vdopia Developer on 6/30/20.
//

#import "FreestarBannerAdViewManager.h"
@import FreestarAds;

static NSString* EVENT_AD_LOADED = @"onBannerAdLoaded";
static NSString* EVENT_AD_FAILED_TO_LOAD = @"onBannerAdFailedToLoad";
static NSString* EVENT_AD_CLICKED = @"onBannerAdClicked";

@interface FreestarBannerAdViewManager () <FreestarBannerAdDelegate>

@property FreestarBannerAd *ad;
@property FreestarBannerAdSize requestedSize;
@property RCTBubblingEventBlock loadedCallback;
@property RCTBubblingEventBlock loadFailedCallback;
@property RCTBubblingEventBlock clickedCallback;

@end

@implementation FreestarBannerAd (ReactBridge)

- (void)setRequestOptions:(NSDictionary *)options {
    NSString *sizeKey = options[@"size"];
    if (sizeKey && ![[sizeKey uppercaseString] isEqualToString:@"MREC"]) {
        if([[sizeKey lowercaseString] isEqualToString:@"banner"]) {
            [((FreestarBannerAdViewManager *)self.delegate) setRequestedSize:FreestarBanner320x50];
        } else if([[sizeKey lowercaseString] isEqualToString:@"leaderboard"]) {
            [((FreestarBannerAdViewManager *)self.delegate) setRequestedSize:FreestarBanner728x90];
        }
    } else if ([[sizeKey uppercaseString] isEqualToString:@"MREC"]) {
        [((FreestarBannerAdViewManager *)self.delegate) setRequestedSize:FreestarBanner300x250];
    }
    
    NSDictionary *targetingParams = options[@"targetingParams"];
    if(targetingParams && targetingParams.count > 0) {
        [targetingParams enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* obj, BOOL * _Nonnull stop) {
            [self addCustomTargeting:key as:obj];
        }];
    }
    
    NSString *placement = options[@"placement"];
    
    [self loadPlacement:placement];
}

- (void)setOnBannerAdLoaded:(RCTBubblingEventBlock)loadedBlock {
    ((FreestarBannerAdViewManager *)self.delegate).loadedCallback = loadedBlock;
}

- (void)setOnBannerAdFailedToLoad:(RCTBubblingEventBlock)failedBlock {
    ((FreestarBannerAdViewManager *)self.delegate).loadFailedCallback = failedBlock;
}

- (void)setOnBannerAdClicked:(RCTBubblingEventBlock)clickedBlock {
    ((FreestarBannerAdViewManager *)self.delegate).clickedCallback = clickedBlock;
}

@end



@implementation FreestarBannerAdViewManager

RCT_EXPORT_MODULE(BannerAd);

RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);

RCT_EXPORT_VIEW_PROPERTY(onBannerAdLoaded, RCTBubblingEventBlock);


- (UIView *)view {
    self.ad = [[FreestarBannerAd alloc] initWithDelegate:self andSize:FreestarBanner320x50];
    self.ad.fixedSize = true;
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

#pragma mark - FreestarBannerAdDelegate



- (void)freestarBannerLoaded:(FreestarBannerAd *)ad {
    [self sendEvent:self.loadedCallback type:EVENT_AD_LOADED payload:@{}];
}

- (void)freestarBannerFailed:(FreestarBannerAd *)ad because:(FreestarNoAdReason)reason {
    [self sendEvent:self.loadFailedCallback type:EVENT_AD_FAILED_TO_LOAD payload:@{
        @"errorCode" : @(reason)
    }];
}

- (void)freestarBannerClicked:(FreestarBannerAd *)ad {
    [self sendEvent:self.clickedCallback type:EVENT_AD_CLICKED payload:@{}];
}

- (void)freestarBannerClosed:(FreestarBannerAd *)ad {}
- (void)freestarBannerShown:(FreestarBannerAd *)ad {}

@end
