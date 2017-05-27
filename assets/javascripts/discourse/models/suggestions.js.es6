import { ajax } from 'discourse/lib/ajax';

const Suggestions = Discourse.Model.extend({

  foo() {
    alert('yep');
  }

});

export default Suggestions;
