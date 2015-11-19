var $ = require('jquery');
var Backbone = require('backbone');
var store = require('store');
Backbone.Marionette = require('backbone.marionette');

module.exports = Backbone.Marionette.Controller.extend({
  initialize: function(app) {
    this.app = app;
    this.details.init();
    this.sort.init();
  },

  details: {
    init: function() {
      if (!this.get()) {
        this.set('show');
      }
    },
    get: function() {
      return store.get('details');
    },
    set: function(value) {
      store.set('details', value);
    }
  },

  sort: {
    init: function() {
      if (!this.get()) {
        this.set('similarity');
      }
    },
    get: function() {
      return store.get('sort');
    },
    set: function(value) {
      store.set('sort', value);
    }
  }
})

