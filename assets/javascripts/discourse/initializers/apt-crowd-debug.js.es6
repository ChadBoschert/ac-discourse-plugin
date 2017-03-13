//TODO conditionally load this helper
import { registerHelper } from 'discourse-common/lib/helpers';

registerHelper('debug', function(optionalValue) {
  console.log("Current Context");
  console.log("====================");
  console.log(this);

  if (optionalValue) {
    console.log("Value");
    console.log("====================");
    console.log(optionalValue);
  }
});

export default {
  name: 'default',
  initialize() {
    console.log($('#apt-crowd-response-display').html());
    console.log($('#apt-crowd-response-display').data('apt-crowd-response'));
  }
};
