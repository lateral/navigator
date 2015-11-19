var $ = require('jquery');
var Backbone = require('backbone');
Backbone.Marionette = require('backbone.marionette');
var Router = require('./routers/root_router');

// Standard Google Universal Analytics code
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-45843453-7', 'auto');
ga('set', 'checkProtocolTask', function(){});
ga('require', 'displayfeatures');

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
