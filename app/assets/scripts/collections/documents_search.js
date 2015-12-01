module.exports = Backbone.Collection.extend({
  model: require('../models/document'),

  initialize: function(models, options) {
    this.keywords = options.keywords;
  },

  url: function() {
    return '/api/' + window.hash + '/' + window.slug + '/documents?keywords=' + encodeURIComponent(this.keywords);
  }
});
