import { registerHelper } from 'discourse-common/lib/helpers';
import { withPluginApi } from 'discourse/lib/plugin-api';

function suggest_handler(m, t) {
  t.then(function() {
    console.log(m);
  });
};

function initializeSuggestions(api) {
  console.log('extend-for-suggestons.js.es6 > initializeSuggestions()');
  /*
  const Topic = api.container.factoryFor('route:topic');
  Topic.reopenClass({
    // https://stackoverflow.com/questions/17437016/ember-transition-rendering-complete-event
    afterModel: suggest_handler
  });*/

};

export default {
  name: "extend-for-suggestions",

  initialize() {
    withPluginApi('0.5', initializeSuggestions);
  }
};
