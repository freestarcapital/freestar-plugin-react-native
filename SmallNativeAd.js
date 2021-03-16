
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import PropTypes from 'prop-types';

var viewProps = {
   name: 'SmallNativeAd',
   propTypes: {
      ...ViewPropTypes,
      requestOptions: PropTypes.object.require,
      onNativeAdLoaded: PropTypes.func,
      onNativeAdFailedToLoad: PropTypes.func,
      onNativeAdClicked: PropTypes.func,
   }

}
module.exports = requireNativeComponent('SmallNativeAd', viewProps);
