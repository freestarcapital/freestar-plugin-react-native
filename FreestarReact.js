import { requireNativeComponent, ViewPropTypes } from 'react-native';
import PropTypes from 'prop-types';

import {NativeModules, NativeEventEmitter, Platform} from 'react-native';
import type EmitterSubscription from 'EmitterSubscription';

const FreestarReactBridge = NativeModules.FreestarReactBridge;
const emitter = new NativeEventEmitter(FreestarReactBridge);

const INTERSTITIAL_CALLBACKS = [
  "onInterstitialLoaded",
  "onInterstitialClicked",
  "onInterstitialShown",
  "onInterstitialFailed",
  "onInterstitialDismissed"];
const REWARD_CALLBACKS_NONFINISHED = [
  "onRewardedLoaded",
  "onRewardedFailed",
  "onRewardedShowFailed",
  "onRewardedShown",
  "onRewardedDismissed"];
const REWARD_CALLBACK_FINISHED = "onRewardedCompleted";

module.exports = {
  initWithAdUnitID: (apiKey: string) => FreestarReactBridge.initWithAdUnitID(apiKey),
  setDemographics: (
    age: int,
    birthday: date,
    gender: string,
    maritalStatus: string,
    ethnicity: string
  ) => FreestarReactBridge.setDemographics(age,birthday.toISOString(),gender,maritalStatus,ethnicity),
  setLocation: (
    dmaCode: string,
    postalCode: string,
    currPostal: string,
    latitude: string,
    longitude: string
  ) => FreestarReactBridge.setLocation(dmaCode,postalCode,currPostal,latitude,longitude),
  setAppInfo: (
    appName: string,
    publisherName: string,
    appDomain: string,
    publisherDomain: string,
    storeURL: string,
    category: string
  ) => FreestarReactBridge.setAppInfo(appName,publisherName,appDomain,publisherDomain,storeURL,category),
  setCoppaStatus: (coppa: boolean) => FreestarReactBridge.setCoppaStatus(coppa),
  loadInterstitialAd: (placement: string) => FreestarReactBridge.loadInterstitialAd(placement),
  showInterstitialAd: (placement: string) => FreestarReactBridge.showInterstitialAd(placement),
  loadRewardAd: (placement: string) => FreestarReactBridge.loadRewardAd(placement),
  showRewardAd: (
    placement: string,
    rewardName: string,
    rewardAmount: int,
    userID: string,
    secretKey: string
  ) => FreestarReactBridge.showRewardAd(placement, rewardName,rewardAmount,userID,secretKey),
  subscribeToInterstitialCallbacks: (callback: Function) => {
    INTERSTITIAL_CALLBACKS.map((event) => {
      emitter.removeAllListeners(event);
      emitter.addListener(event, (body) => {
        callback(event, body.placement);
      });
    });
  },
 subscribeToInterstitialCallbacks2: (callback: Function) => {
   INTERSTITIAL_CALLBACKS.map((event) => {
     emitter.removeAllListeners(event);
     emitter.addListener(event, (body) => {
       callback(event, body.placement, body);
     });
   });
 },
  unsubscribeFromInterstitialCallbacks: () => {
    INTERSTITIAL_CALLBACKS.map((event) => {
      emitter.removeAllListeners(event);
    });
  },
  subscribeToRewardCallbacks: (callback: Function) => {
    REWARD_CALLBACKS_NONFINISHED.map((event) => {
      emitter.removeAllListeners(event);
      emitter.addListener(event, (body) => {
        callback(event, body.placement);
      });
    });
    emitter.removeAllListeners(REWARD_CALLBACK_FINISHED);
    emitter.addListener(REWARD_CALLBACK_FINISHED, (body) => {
      callback(REWARD_CALLBACK_FINISHED, body.placement, body.rewardName, body.rewardAmount)
    });
  },
  subscribeToRewardCallbacks2: (callback: Function) => {
    REWARD_CALLBACKS_NONFINISHED.map((event) => {
      emitter.removeAllListeners(event);
      emitter.addListener(event, (body) => {
        callback(event, body.placement, body);
      });
    });
    emitter.removeAllListeners(REWARD_CALLBACK_FINISHED);
    emitter.addListener(REWARD_CALLBACK_FINISHED, (body) => {
      callback(REWARD_CALLBACK_FINISHED, body.placement, body.rewardName, body.rewardAmount)
    });
  },
  unsubscribeFromRewardCallbacks: () => {
    REWARD_CALLBACKS_NONFINISHED.map((event) => {
      emitter.removeAllListeners(event);
    });
    emitter.removeAllListeners(REWARD_CALLBACK_FINISHED);
  },
  setCustomSegmentProperty: (key: string, value: string) =>
    FreestarReactBridge.setCustomSegmentProperty(key,value),
  getCustomSegmentProperty: (key: string, callback: Function) =>
    FreestarReactBridge.getCustomSegmentProperty(key, callback),
  getAllCustomSegmentProperties: (callback: Function) =>
    FreestarReactBridge.getAllCustomSegmentProperties(callback),
  deleteCustomSegmentProperty: (key: string) =>
    FreestarReactBridge.deleteCustomSegmentProperty(key),
  deleteAllCustomSegmentProperties: () =>
    FreestarReactBridge.deleteAllCustomSegmentProperties()

};

export { default as BannerAd } from './BannerAd';

export { default as MrecBannerAd } from './MrecBannerAd';
export { default as MrecBannerAd2 } from './MrecBannerAd2';
export { default as MrecBannerAd3 } from './MrecBannerAd3';
export { default as MrecBannerAd4 } from './MrecBannerAd4';

export { default as SmallNativeAd } from './SmallNativeAd';
export { default as SmallNativeAd2 } from './SmallNativeAd2';
export { default as SmallNativeAd3 } from './SmallNativeAd3';
export { default as SmallNativeAd4 } from './SmallNativeAd4';

export { default as MediumNativeAd } from './MediumNativeAd';
export { default as MediumNativeAd2 } from './MediumNativeAd2';
export { default as MediumNativeAd3 } from './MediumNativeAd3';
export { default as MediumNativeAd4 } from './MediumNativeAd4';
