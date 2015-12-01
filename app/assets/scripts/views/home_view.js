var ResultView = Backbone.Marionette.ItemView.extend({
  tagName: 'li',
  className: 'result',
  template: require('../templates/_document_home.hbs'),

  initialize: function() {
    this.model.set('isMeta', this.model.get('date') || this.model.get('author'));
    this.model.set('url', '/' + window.hash + '/' + window.slug + '/results/' + this.model.get('id'));
  }
});

// var NoResultsView = Backbone.Marionette.ItemView.extend({
//   template: require('../templates/home_empty.hbs'),
//   className: 'home-empty'
// });

module.exports = Backbone.Marionette.CompositeView.extend({
  childView: ResultView,
  childViewContainer: '.random-selection',
  className: 'examples',
  // emptyView: NoResultsView,
  template: require('../templates/home.hbs')
});
