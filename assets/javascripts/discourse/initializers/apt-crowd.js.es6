import { registerHelper } from 'discourse-common/lib/helpers';
import { withPluginApi } from 'discourse/lib/plugin-api';
import showModal from 'discourse/lib/show-modal';

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
    console.log($aptCrowdResponse);
    if ($aptCrowdResponse.length > 0) {
      var topicId = $aptCrowdResponse.data('topic-id');

/*      bootbox.alert($aptCrowdResponse.html(), function() {
        $.post('/apt_crowd/silence/' + topicId)
      });
*/
/*
      const ModalController = api.container.lookupFactory("controller:modal");
      console.log(ModalController);
      ModalController.reopen({
        actions: {
          foo() {
	    alert('bar');
          }
        }
      });
      // http://localhost:3000/u/gfleck/activity/topics
      $(document).ready(function () {
        Discourse.Topic.find(743, {}).then(function (model) {
          var m = showModal('ac-dialog', { model, title: 'ac_dialog.title' });
          console.log(m);
        });
        
      });
*/
      //const TopicController = api.container.lookupFactory("controller:topic.fromParamsNear");


      $(document).ready(function () {

        Discourse.Topic.find(743, {}).then(function (model) {
          //var m = showModal('ac-dialog', { model, title: 'ac_dialog.title' });
//          console.log(m);
           console.log(model);
        });
        
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
