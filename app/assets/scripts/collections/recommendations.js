var $ = require('jquery');
var _ = require('underscore');
var Backbone = require('backbone');
var Document = require('../models/document');

module.exports = Backbone.Collection.extend({
  model: require('../models/document'),

  initialize: function(models, options) {
    this.id = options.id;
  },

  url: function() {
    return '/api/' + window.hash + '/' + window.slug + '/documents/' + this.id + '/similar';
  }
});
