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

module.exports = Backbone.Marionette.CompositeView.extend({
  childView: ResultView,
  childViewContainer: '.result-items',
  template: require('../templates/recommendations.hbs'),

  events: {
    'click .detailed-view-disable': 'detailsDisable',
    'click .detailed-view-enable': 'detailsEnable',
    'click .controls a': 'sortUpdate'
  },

  initialize: function(options) {
    this.listenTo(this.model, 'change', this.render, this);
    this.sortCollection();
  },

  detailsDisable: function(event) {
    router.settings.details.set('hide');
    this.render();
    event.preventDefault();
  },

  detailsEnable: function(event) {
    router.settings.details.set('show');
    this.render();
    event.preventDefault();
  },

  sortUpdate: function(event) {
    router.settings.sort.set($(event.target).data('sort'));
    this.sortCollection();
    event.preventDefault();
  },

  sortCollection: function() {
    this.collection.comparator = function(model) {
      var sort = router.settings.sort.get();
      if (sort == 'date') { sort = 'dateObj'; }
      return -model.get(sort);
    }
    this.collection.sort();
  },

  onRender: function() {
    this.model.set('isMeta', this.model.get('date') || this.model.get('author'));
    var showSort = (typeof this.model.get('date') !== 'undefined');
    this.$('.controls').toggle(showSort);
    this.$('.toggle-details').toggleClass('controls-visible', showSort);
    this.$('.controls a[data-sort="' + router.settings.sort.get() + '"]').addClass('active');
    this.$('.results').toggleClass('detailed-view', router.settings.details.get() == 'show');
  }
});
