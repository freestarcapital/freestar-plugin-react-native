
import { requireNativeComponent } from 'react-native';
import PropTypes from 'prop-types';

var viewProps = {
   name: 'MediumNativeAd4',
   propTypes: {
      requestOptions: PropTypes.object.require
   }

}
module.exports = requireNativeComponent('MediumNativeAd4', viewProps);
