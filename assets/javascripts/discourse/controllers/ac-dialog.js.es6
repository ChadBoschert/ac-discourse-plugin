import { ajax } from 'discourse/lib/ajax';

export default Ember.Controller.extend({
  actions: {
    show_post(post_id) { 
      // TODO: Find a better way to route to a post w/o opening a new window
      window.open('/p/' + post_id);
    },
    show_activity(user_id) {
      console.log(user_id)
      ajax("/apt_crowd/lookup-user/" + user_id, {
        type: "POST", data: { }
      }).then(response => {
        window.open('/u/' + encodeURI(response.user.username) + '/activity'); 
      });
    },
    invite_peer(topic_id, user_id) {
      // TODO: Use this.siteSettings.apt_crowd_api_uri to post engagement tracking
      ajax("/apt_crowd/invite/" + topic_id, {
        type: "POST",
        data: { user_id: user_id }
      }).then(response => {
        console.log(response);
        if (response.invited) { alert( response.user.name + ' has been invited to the conversation.'); }
      }).catch(e => { console.log(e); }).finally(() => { });
    },
    silence(topic_id) {
      ajax("/apt_crowd/silence/" + topic_id, {
        type: "POST",
        data: { }
      }).then(response => {
        console.log(response);
      }).catch(e => { console.log(e); }).finally(() => { 
        this.send('closeModal');
      });
    }
  }
});
