//
//  FreestarMrecAdViewManager.m
//  freestar-plugin-react-native
//
//  Created by Lev Trubov on 6/1/21.
//

#import "FreestarMrecAdViewManager.h"
@import FreestarAds;

static NSString* EVENT_AD_LOADED = @"onBannerAdLoaded";
static NSString* EVENT_AD_FAILED_TO_LOAD = @"onBannerAdFailedToLoad";
static NSString* EVENT_AD_CLICKED = @"onBannerAdClicked";

@interface FreestarMrecAdViewManager () <FreestarBannerAdDelegate>

@property FreestarBannerAd *ad;
@property RCTBubblingEventBlock loadedCallback;
@property RCTBubblingEventBlock loadFailedCallback;
@property RCTBubblingEventBlock clickedCallback;

@end

@implementation FreestarMrecAdViewManager

RCT_EXPORT_VIEW_PROPERTY(requestOptions, NSDictionary);

RCT_EXPORT_VIEW_PROPERTY(onBannerAdLoaded, RCTBubblingEventBlock);

- (UIView *)view {
    self.ad = [[FreestarBannerAd alloc] initWithDelegate:self andSize:FreestarBanner300x250];
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

-(void)freestarBannerLoaded:(FreestarBannerAd *)ad {
    [self sendEvent:self.loadedCallback type:EVENT_AD_LOADED payload:@{}];
}

-(void)freestarBannerFailed:(FreestarBannerAd *)ad because:(FreestarNoAdReason)reason {
    [self sendEvent:self.loadFailedCallback type:EVENT_AD_FAILED_TO_LOAD payload:@{
        @"errorCode" : @(reason)
    }];
}

-(void)freestarBannerClicked:(FreestarBannerAd *)ad {
    [self sendEvent:self.clickedCallback type:EVENT_AD_CLICKED payload:@{}];
}

-(void)freestarBannerClosed:(FreestarBannerAd *)ad {}
-(void)freestarBannerShown:(FreestarBannerAd *)ad {}


@end

@implementation FreestarMrecAdViewManager1
RCT_EXPORT_MODULE(MrecBannerAd);
@end

@implementation FreestarMrecAdViewManager2
RCT_EXPORT_MODULE(MrecBannerAd2);
@end

@implementation FreestarMrecAdViewManager3
RCT_EXPORT_MODULE(MrecBannerAd3);
@end

@implementation FreestarMrecAdViewManager4
RCT_EXPORT_MODULE(MrecBannerAd4);
@end
