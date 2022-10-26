//
//  FreestarReactBridge.m
//  FreestarPlatformReactNativePlugin
//
//  Created by Lev Trubov on 6/25/20.
//  Copyright © 2020 Freestar. All rights reserved.
//

#import "FreestarReactBridge.h"
@import FreestarAds;

@interface FreestarReactBridge () <FreestarInterstitialDelegate, FreestarRewardedDelegate, FreestarThumbnailAdDelegate>

@property NSMutableDictionary<NSString*,FreestarThumbnailAd*> *thumbnailAds;
@property NSMutableDictionary<NSString*,FreestarInterstitialAd*> *interstitialAds;
@property NSMutableDictionary<NSString*,FreestarRewardedAd*> *rewardAds;

@end

@implementation FreestarReactBridge

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

+ (BOOL)requiresMainQueueSetup
{
  return YES;  // only do this if your module initialization relies on calling UIKit!
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

#pragma mark - init

RCT_EXPORT_METHOD(initWithAdUnitID:(NSString *)apiKey) {
    self.thumbnailAds = [NSMutableDictionary dictionary];
    self.interstitialAds = [NSMutableDictionary dictionary];
    self.rewardAds = [NSMutableDictionary dictionary];
    [Freestar initWithAppKey:apiKey];
}

#pragma mark - targeting

RCT_EXPORT_METHOD(setDemographics:(NSInteger)age
                  birthday:(NSDate *)birthday
                  gender:(NSString *)gender
                  maritalStatus:(NSString *)maritalStatus
                  ethnicity:(NSString *)ethnicity
                  ) {
    FreestarDemographics *dem = [Freestar demographics];
    [dem setAge:age];
    unsigned unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:birthday];
    [dem setBirthdayYear:comps.year month:comps.month day:comps.day];

    [self processGender:gender.lowercaseString forDemographics:dem];
    [self processMaritalStatus:maritalStatus.lowercaseString forDemographics:dem];
    [dem setEthnicity:ethnicity];
}

-(void)processGender:(NSString *)gender forDemographics:(FreestarDemographics *)dem {
    if ([gender isEqualToString:@"m"] ||
        [gender isEqualToString:@"male"]) {
        [dem setGender:FreestarGenderMale];
    } else if ([gender isEqualToString:@"f"] ||
               [gender isEqualToString:@"female"]) {
        [dem setGender:FreestarGenderFemale];
    } else if ([gender isEqualToString:@"o"] ||
               [gender isEqualToString:@"other"]) {
        [dem setGender:FreestarGenderOther];
    }
}

-(void)processMaritalStatus:(NSString *)ms forDemographics:(FreestarDemographics *)dem {
    if([ms containsString:@"single"]) {
        [dem setMaritalStatus:FreestarMaritalStatusSingle];
    }else if([ms containsString:@"married"]) {
        [dem setMaritalStatus:FreestarMaritalStatusMarried];
    }else if([ms containsString:@"divorced"]) {
        [dem setMaritalStatus:FreestarMaritalStatusDivorced];
    }else if([ms containsString:@"widowed"]) {
        [dem setMaritalStatus:FreestarMaritalStatusWidowed];
    }else if([ms containsString:@"separated"]) {
        [dem setMaritalStatus:FreestarMaritalStatusSeparated];
    }else if([ms containsString:@"other"]) {
        [dem setMaritalStatus:FreestarMaritalStatusOther];
    }
}

RCT_EXPORT_METHOD(setLocation:(NSString *)dmaCode
                  postalCode:(NSString *)postalCode
                  currPostal:(NSString *)currPostal
                  latitide:(NSString *)latitude
                  longitude:(NSString *)longitude
                  ) {
    FreestarLocation *loc = [Freestar location];
    loc.dmacode = dmaCode;
    loc.postalcode = postalCode;
    loc.currpostal = currPostal;
    loc.location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];

}

#pragma mark - events

- (NSArray<NSString *> *)supportedEvents{
    return @[@"onInterstitialLoaded",
             @"onInterstitialClicked",
             @"onInterstitialShown",
             @"onInterstitialFailed",
             @"onInterstitialDismissed",
             @"onRewardedLoaded",
             @"onRewardedFailed",
             @"onRewardedShowFailed",
             @"onRewardedCompleted",
             @"onRewardedShown",
             @"onRewardedDismissed",
             @"onThumbnailAdLoaded",
             @"onThumbnailAdClicked",
             @"onThumbnailAdShown",
             @"onThumbnailAdFailed",
             @"onThumbnailAdDismissed"
    ];
}

#pragma mark - launching Thumbnail

RCT_EXPORT_METHOD(loadThumbnailAd:(NSString *)placement) {
    FreestarThumbnailAd *ad = [[FreestarThumbnailAd alloc] initWithDelegate:self];

    NSString *placementKey = placement ? placement : @"";

    self.thumbnailAds[placementKey] = ad;

    [ad loadPlacement:placement];
}

RCT_EXPORT_METHOD(showThumbnailAd:(NSString *)placement thumbnailAdGravity:(NSString *)gravity leftMargin:(int)xMargin topMargin:(int) yMargin) {

    FreestarThumbnailAdGravity gravityValue = TopLeft;

    if([gravity isEqualToString:@"TopLeft"]) {
        gravityValue = TopLeft;
    } else if([gravity isEqualToString:@"TopRight"]) {
        gravityValue = TopRight;
    } else if([gravity isEqualToString:@"BottomLeft"]) {
        gravityValue = BottomLeft;
    } else if([gravity isEqualToString:@"BottomRight"]) {
        gravityValue = BottomRight;
    }

    [FreestarThumbnailAd setGravity:gravityValue];
    [FreestarThumbnailAd setXMargin:(CGFloat)xMargin];
    [FreestarThumbnailAd setYMargin:(CGFloat)yMargin];

    NSString *placementKey = placement ? placement : @"";
    [self.thumbnailAds[placementKey] show];
}

#pragma mark - FreestarThumbnailAdDelegate delegate

-(void)onThumbnailLoaded:(FreestarThumbnailAd *)ad {
    [self sendEventWithName:@"onThumbnailAdLoaded" body:@{@"placement": ad.placement}];
}

-(void)onThumbnailFailed:(FreestarThumbnailAd *)ad because:(FreestarNoAdReason)reason {
    [self sendEventWithName:@"onThumbnailAdFailed" body:@{@"placement": ad.placement}];
}

-(void)onThumbnailShown:(FreestarThumbnailAd *)ad {
    [self sendEventWithName:@"onThumbnailAdShown" body:@{@"placement": ad.placement}];
}

-(void)onThumbnailClicked:(FreestarThumbnailAd *)ad {
    [self sendEventWithName:@"onThumbnailAdClicked" body:@{@"placement": ad.placement}];
}

- (void)onThumbnailDismissed:(FreestarThumbnailAd *)ad {
    [self sendEventWithName:@"onThumbnailAdDismissed" body:@{@"placement": ad.placement}];
}

#pragma mark - launching interstitial

RCT_EXPORT_METHOD(loadInterstitialAd:(NSString *)placement) {
    FreestarInterstitialAd *ad = [[FreestarInterstitialAd alloc] initWithDelegate:self];

    NSString *placementKey = placement ? placement : @"";

    self.interstitialAds[placementKey] = ad;
    [ad loadPlacement:placement];
}

RCT_EXPORT_METHOD(showInterstitialAd:(NSString *)placement) {
    NSString *placementKey = placement ? placement : @"";
    [self.interstitialAds[placementKey] showFrom:[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController]];
}

#pragma mark - Interstitial delegate

-(void)freestarInterstitialLoaded:(FreestarInterstitialAd *)ad {
    [self sendEventWithName:@"onInterstitialLoaded" body:@{@"placement": ad.placement}];
}

-(void)freestarInterstitialFailed:(FreestarInterstitialAd *)ad because:(FreestarNoAdReason)reason {
    [self sendEventWithName:@"onInterstitialFailed" body:@{@"placement": ad.placement}];
}

-(void)freestarInterstitialShown:(FreestarInterstitialAd *)ad {
    [self sendEventWithName:@"onInterstitialShown" body:@{@"placement": ad.placement}];
}

-(void)freestarInterstitialClicked:(FreestarInterstitialAd *)ad {
    [self sendEventWithName:@"onInterstitialClicked" body:@{@"placement": ad.placement}];
}

-(void)freestarInterstitialClosed:(FreestarInterstitialAd *)ad {
    [self sendEventWithName:@"onInterstitialDismissed" body:@{@"placement": ad.placement}];
}


#pragma mark - launching reward

RCT_EXPORT_METHOD(loadRewardAd:(NSString *)placement) {
    FreestarRewardedAd *ad = [[FreestarRewardedAd alloc] initWithDelegate:self andReward:[FreestarReward blankReward]];

    NSString *placementKey = placement ? placement : @"";

    self.rewardAds[placementKey] = ad;
    [ad loadPlacement:placement];
}

RCT_EXPORT_METHOD(showRewardAd:(NSString *)placement
                  rewardName:(NSString *)rewardName
                  amount:(NSInteger)rewardAmount
                  userID:(NSString *)userID
                  secretKey:(NSString *)secretKey) {
  FreestarReward *rew = [FreestarReward blankReward];

  rew.rewardName = rewardName;
  rew.rewardAmount = rewardAmount;
  rew.userID = userID;
  rew.secretKey = secretKey;

    NSString *placementKey = placement ? placement : @"";

    self.rewardAds[placementKey].reward = rew;
    [self.rewardAds[placementKey] showFrom:[self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController]];
}

#pragma mark - Reward delegate

-(void)freestarRewardedLoaded:(FreestarRewardedAd *)ad {
    [self sendEventWithName:@"onRewardedLoaded" body:@{@"placement": ad.placement}];
}

-(void)freestarRewardedFailed:(FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {
    [self sendEventWithName:@"onRewardedFailed" body:@{@"placement": ad.placement}];
}

-(void)freestarRewardedShown:(FreestarRewardedAd *)ad {
    [self sendEventWithName:@"onRewardedShown" body:@{@"placement": ad.placement}];
}

-(void)freestarRewardedClosed:(FreestarRewardedAd *)ad {
    [self sendEventWithName:@"onRewardedDismissed" body:@{@"placement": ad.placement}];
}

-(void)freestarRewardedFailedToStart:(FreestarRewardedAd *)ad because:(FreestarNoAdReason)reason {
    [self sendEventWithName:@"onRewardedShowFailed" body:@{@"placement": ad.placement}];
}

-(void)freestarRewardedAd:(FreestarRewardedAd *)ad received:(NSString *)rewardName amount:(NSInteger)rewardAmount {
  [self sendEventWithName:@"onRewardedCompleted"
  body:@{@"rewardName" : rewardName,
         @"rewardAmount" : @(rewardAmount),
         @"placement" : ad.placement
         }];
}

#pragma mark - support

- (UIViewController *)visibleViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];

        return [self visibleViewController:lastViewController];
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;

        return [self visibleViewController:selectedViewController];
    }

    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;

    return [self visibleViewController:presentedViewController];
}

#pragma mark - custom segment properties

RCT_EXPORT_METHOD(setCustomSegmentProperty:(NSString *)key with:(NSString *)value) {
    [FreestarCustomSegmentProperties setCustomSegmentProperty:key with:value];
}

RCT_EXPORT_METHOD(getCustomSegmentProperty:(NSString *)key callback:(RCTResponseSenderBlock)callback) {
    callback(@[[NSNull null], [FreestarCustomSegmentProperties getCustomSegmentProperty:key]]);
}

RCT_EXPORT_METHOD(getAllCustomSegmentProperties:(RCTResponseSenderBlock)callback) {
    callback(@[[NSNull null], [FreestarCustomSegmentProperties getAllCustomSegmentProperties]]);
}

RCT_EXPORT_METHOD(deleteCustomSegmentProperty:(NSString *)key) {
    [FreestarCustomSegmentProperties deleteCustomSegmentProperty:key];
}

RCT_EXPORT_METHOD(deleteAllCustomSegmentProperties) {
    [FreestarCustomSegmentProperties deleteAllCustomSegmentProperties];
}

#pragma mark - deprecated

RCT_EXPORT_METHOD(setCoppaStatus) {}

RCT_EXPORT_METHOD(setAppInfo:(NSString *)appName
                  publisher:(NSString *)publisher
                  appDomain:(NSString *)appDomain
                  publisherDomain:(NSString *)publisherDomain
                  storeURL:(NSString *)storeURL
                  category:(NSString *)iabCategory
                  ) {

}
@end


