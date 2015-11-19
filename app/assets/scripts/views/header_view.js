var $ = require('jquery');
var _ = require('underscore');
var Backbone = require('backbone');
var SearchCollection = require('../collections/documents_search');
var SearchView = require('../views/search_view');

module.exports = Backbone.View.extend({

  template: require('../templates/header.hbs'),

  events: {
    'click a': 'home',
    'keyup input': 'keyup'
  },

  initialize: function(options) {
    this.options = options;
    this.homeUrl = '/' + window.hash + '/' + window.slug;
  },

  home: function(event) {
    if ('/' + Backbone.history.fragment == this.homeUrl) {
      Backbone.history.loadUrl(Backbone.history.fragment);
    }
  },

  keyup: function(event) {
    var val = $(event.target).val()
    if (val == '') { return; }
    collection = new SearchCollection(null, { keywords: val });
    if (this.fetch && this.fetch.readyState > 0 && this.fetch.readyState < 4) {
      this.fetch.abort();
    }
    this.fetch = collection.fetch();
    App.contents.show(new SearchView({ collection: collection }));
    this.$('h2').hide();
    this.$('#search').show();
  },

  render: function() {
    $(this.el).html(this.template({ home_url: this.homeUrl }));

    this.$('h2').hide();
    if (this.options.home) { this.$('#home').show(); }
    if (this.options.results) { this.$('#results').show(); }
  }
});
