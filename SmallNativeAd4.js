
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import PropTypes from 'prop-types';

var viewProps = {
   name: 'SmallNativeAd4',
   propTypes: {
      ...ViewPropTypes,
      requestOptions: PropTypes.object.require,
      onNativeAdLoaded: PropTypes.func,
      onNativeAdFailedToLoad: PropTypes.func,
      onNativeAdClicked: PropTypes.func,
   }

}
module.exports = requireNativeComponent('SmallNativeAd4', viewProps);
