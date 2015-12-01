var PageableCollection = require('backbone.paginator');

module.exports = Backbone.Collection.extend({
  url: function() {
    return '/api/' + window.hash + '/' + window.slug + '/documents';
  },
  model: require('../models/document')
});
