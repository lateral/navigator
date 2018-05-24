var Router = require('./routers/root_router');

window.jQuery = $;
window.App = new Backbone.Marionette.Application();

App.addRegions({
  'header': 'header',
  'contents': '#wrapper',
  'loader': '#loader',
  'error': '#error',
});

$(function() {

  // Route links with the route class
  $(document).delegate('a.route', 'click', function(e) {
    e.preventDefault();
    Backbone.history.navigate($(this).attr('href'), true);
  });

  // Init app
  window.router = new Router();
  Backbone.history.start({ pushState: true });

});
