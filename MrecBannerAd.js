
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import PropTypes from 'prop-types';

var viewProps = {
   name: 'MrecBannerAd',
   propTypes: {
      ...ViewPropTypes,
      requestOptions: PropTypes.object.require,
      onAdLoaded: PropTypes.func,
      onAdFailedToLoad: PropTypes.func,
      onAdClicked: PropTypes.func,
   }

}
module.exports = requireNativeComponent('MrecBannerAd', viewProps);
