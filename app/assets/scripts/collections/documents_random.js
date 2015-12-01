module.exports = Backbone.Collection.extend({
  url: function() {
    return '/api/' + window.hash + '/' + window.slug + '/random-documents';
  },

  model: require('../models/document'),

  initialize: function(models, options) {
    if (options && options.count) {
      this.count = options.count;
    }
  },

  parse: function(resp) {
    var count = this.count ? this.count : 5;
    return _.sample(resp, count);
  }
});
