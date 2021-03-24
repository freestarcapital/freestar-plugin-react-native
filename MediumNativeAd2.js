
import { requireNativeComponent, ViewPropTypes } from 'react-native';
import PropTypes from 'prop-types';

var viewProps = {
   name: 'MediumNativeAd2',
   propTypes: {
      ...ViewPropTypes,
      requestOptions: PropTypes.object.require,
      onNativeAdLoaded: PropTypes.func,
      onNativeAdFailedToLoad: PropTypes.func,
      onNativeAdClicked: PropTypes.func,
   }

}
module.exports = requireNativeComponent('MediumNativeAd2', viewProps);
