
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import PropTypes from 'prop-types';

var viewProps = {
   name: 'MrecBannerAd4',
   propTypes: {
      ...ViewPropTypes,
      requestOptions: PropTypes.object.require,
      onBannerAdLoaded: PropTypes.func,
      onBannerAdFailedToLoad: PropTypes.func,
      onBannerAdClicked: PropTypes.func,
   }

}
module.exports = requireNativeComponent('MrecBannerAd4', viewProps);
