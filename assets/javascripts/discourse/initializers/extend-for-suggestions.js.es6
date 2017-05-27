import { withPluginApi } from 'discourse/lib/plugin-api';
import showModal from 'discourse/lib/show-modal';

function suggest_handler(m, t) {
  t.then(function() {
    console.log(document.readyState);
    if (Discourse.User.current().id == m.user_id && (m.apt_crowd_request_seen == null || m.apt_crowd_request_seen == false))   
    {
      if (document.readyState === 'complete') {
        // TODO: This is a bit of a hack to ensure the modal actually renders when transitioning between routes
        setTimeout(function() {
          showModal('ac-dialog', { model: m, title: 'ac_dialog.title', onClose: function() { alert('test'); } });
        }, 1000);
      } else {
        $(document).ready(function() {
          showModal('ac-dialog', { model: m, title: 'ac_dialog.title', onClose: function() { alert('test'); } });
        });
      }
    }
  });
}

function initializeSuggestions(api) {
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
