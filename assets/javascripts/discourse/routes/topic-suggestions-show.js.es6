/*
export default Discourse.Route.extend({

  model(params) {
    var model = this.modelFor('topic');
    console.log(model);
    return model;
  },

  afterModel(model) {
    showModal("ac-dialog", { model: this.currentUser });
  },

  setupController(controller, model) {
    controller.setProperties({
      model: model,
      user: this.controllerFor("user").get("model")
    });
  },

  actions: {
    showInvite() {
      showModal("ac-dialog", { model: this.currentUser });
      this.controllerFor("modal").reset();
    }
  }
});
*/
