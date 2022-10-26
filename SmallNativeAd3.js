
import { requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types';

var props = {
   name: 'SmallNativeAd3',
   propTypes: {
      requestOptions: PropTypes.object.require
   }

}
module.exports = requireNativeComponent('SmallNativeAd3', props);
