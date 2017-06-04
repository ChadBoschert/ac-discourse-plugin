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


function suggest_handler(m, t) {
  t.then(function() {

    // TODO: m.user_id is undefined when we transistion to this route so we have to reload the model; find
    //       a way to avoid the reload. Note: m.user_id has a value when the page is refreshed.
    Discourse.Topic.find(m.id, {}).then(function (model) {

      
      if (Discourse.User.current().id == model.user_id && model.apt_crowd_request != null && (model.apt_crowd_request_seen == null || model.apt_crowd_request_seen == false))   
      {
        if (document.readyState === 'complete') {
          // TODO: This is a bit of a hack to ensure the modal actually renders when transitioning between routes
          setTimeout(function() {
            console.log('setTimeout');
            showModal('ac-dialog', { model: model, title: 'ac_dialog.title', onClose: function() { alert('test'); } });
          }, 1000);
        } else {
          $(document).ready(function() {
            showModal('ac-dialog', { model: model, title: 'ac_dialog.title', onClose: function() { alert('test'); } });
          });
        }
      }


    });

  });
}


function initializeSuggestions(api) {
  console.log('extend-for-suggestons.js.es6 > initializeSuggestions()');
  const Topic = api.container.lookupFactory('route:topic');
  console.log(Topic)
  Topic.reopen({
    // https://stackoverflow.com/questions/17437016/ember-transition-rendering-complete-event
    afterModel: suggest_handler
  });

}

export default {
  name: "extend-for-suggestions",

  initialize() {
    withPluginApi('0.5', initializeSuggestions);
  }
};
