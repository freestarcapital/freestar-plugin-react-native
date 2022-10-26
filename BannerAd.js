
import { requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types';

var props = {
   name: 'BannerAd',
   propTypes: {
      requestOptions: PropTypes.object.require
   }

}
module.exports = requireNativeComponent('BannerAd', props);
