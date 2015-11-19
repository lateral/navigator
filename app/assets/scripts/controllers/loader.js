var $ = require('jquery');
var Backbone = require('backbone');
Backbone.Marionette = require('backbone.marionette');

module.exports = Backbone.Marionette.Controller.extend({
  initialize: function(app) {
    this.app = app;

    $(document).ajaxStart($.proxy(this.show, this));
    $(document).ajaxStop($.proxy(this.hide, this));
  },

  show: function() {
    $(this.app.loader.el).stop().fadeIn(200);
  },

  hide: function() {
    $(this.app.loader.el).stop().fadeOut(200);
  }
})

