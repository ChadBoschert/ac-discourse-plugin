import Ember from 'ember';
import showModal from 'discourse/lib/show-modal';

export default Ember.Component.extend({
  topic: undefined,

  init(){
  	this._super(...arguments);
  	console.log(this);
  },

  didInsertElement() {
  	this._super(...arguments);
    //debugger;
  	/*this.appEvents.on('post-stream:posted', arg => {
      console.log('post-stream:posted')
      //Ember.run.scheduleOnce('afterRender', null, highlight, postNumber);
      console.log(arg);
    });*/
  },

  didRender() {
    this._super(...arguments);

    if (this.topic){
      var t = this.topic;
      Em.run.schedule('afterRender', function() {
        console.log('afterRender:' + t.id);
        showModal('ac-dialog', { model: t, title: 'ac_dialog.title'});
      });
      //showModal('ac-dialog', { model: model, title: 'ac_dialog.title', onClose: function() { alert('test'); } });
    }
  },

  willDestroyElement() {
  	this._super();
  	//this.appEvents.off('post-stream:posted');
  }
})