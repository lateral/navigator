var ResultView = Backbone.Marionette.ItemView.extend({
  tagName: 'li',
  template: require('../templates/_result.hbs'),

  initialize: function() {
    this.model.set('isMeta', this.model.get('date') || this.model.get('author'));
    this.model.set('recommendations_url', '/' + window.hash + '/' + window.slug + '/results/' + this.model.get('id'));
  },

  onRender: function() {
    if (this.model.get('image')) {
      this.$el.addClass('has-image');
    }
  }
});

var EmptyView = Backbone.Marionette.ItemView.extend({
  template: require('../templates/search_empty.hbs')
});

module.exports = Backbone.Marionette.CompositeView.extend({
  childView: ResultView,
  childViewContainer: '.result-items',
  template: require('../templates/search.hbs'),
  emptyView: EmptyView,

  onRender: function() {
    this.$('.results').addClass('detailed-view')
  }
});
