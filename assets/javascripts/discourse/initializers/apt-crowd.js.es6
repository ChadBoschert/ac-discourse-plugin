import { registerHelper } from 'discourse-common/lib/helpers';
import { withPluginApi } from 'discourse/lib/plugin-api';

//TODO conditionally load this helper
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

registerHelper('eq', function(args) {
    return args[0] === args[1];
});

function initializeDetails(api) {
  api.decorateCooked($elem => {
    var $aptCrowdResponse = $('#apt-crowd-response-display');

    if ($aptCrowdResponse.length > 0) {
      var topicId = $aptCrowdResponse.data('topic-id');

      bootbox.alert($aptCrowdResponse.html(), function() {
        $.post('/apt_crowd/silence/' + topicId)
      });
    }
  });
}

export default {
  name: "apt-crowd-init",

  initialize() {
    withPluginApi('0.5', initializeDetails);
  }
};
