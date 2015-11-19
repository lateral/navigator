var Backbone = require('backbone');
var PageableCollection = require('backbone.paginator');
var _ = require('underscore');

module.exports = Backbone.Collection.extend({
  url: function() {
    return '/api/' + window.hash + '/' + window.slug + '/documents';
  },
  model: require('../models/document')
});
