var $ = require('jquery');
var Backbone = require('backbone');
var _ = require('underscore');

var IntroView = require('../views/intro_view');
var HomeView = require('../views/home_view');
var ResultsView = require('../views/results_view');
var HeaderView = require('../views/header_view');

var LoaderController = require('../controllers/loader');
var ErrorController = require('../controllers/error');
var SettingsController = require('../controllers/settings');

var DocumentModel = require('../models/document');

var SearchCollection = require('../collections/documents_search');
var RandomDocumentsCollection = require('../collections/documents_random');
var RecommendationsCollection = require('../collections/recommendations');

module.exports = Backbone.Router.extend({

  routes: {
    ':hash/:slug(/)': 'navigator',
    ':hash/:slug/results/:id(/)': 'results',
    '*path': 'index'
  },

  initialize: function(options) {
    this.loader = new LoaderController(App);
    this.settings = new SettingsController(App);
    this.error = new ErrorController(App);
    this.bind('all', this._trackPageview);
  },

  index: function() {
    App.header.reset();
    App.contents.show(new IntroView());
  },

  navigator: function(hash, slug) {
    window.hash = hash;
    window.slug = slug;
    App.header.show(new HeaderView({ home: true }));
    var documents = new RandomDocumentsCollection([], { count: 5 });
    documents.fetch();
    App.contents.show(new HomeView({ collection: documents }));
  },

  results: function(hash, slug, id) {
    window.hash = hash;
    window.slug = slug;
    App.header.show(new HeaderView({ results: true }));
    var doc = new DocumentModel({ id: id });
    doc.fetch();
    var recommendations = new RecommendationsCollection([], { id: doc.get('id') })
    recommendations.fetch();
    App.contents.show(new ResultsView({ model: doc, collection: recommendations }));
  },

  _trackPageview: function() {
    var url = Backbone.history.getFragment();
    ga('send', 'pageview', '/' + url);
  }
});
