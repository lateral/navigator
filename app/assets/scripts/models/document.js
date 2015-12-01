var $ = require('jquery');
var Backbone = require('backbone');
var _ = require('underscore');
var moment  = require('moment');
var parseFormat = require('moment-parseformat');

module.exports = Backbone.Model.extend({
  url: function() {
    return '/api/' + window.hash + '/' + window.slug + '/documents/' + this.get('id');
  },

  parse: function(response) {
    var response = _.extend(response.meta, response);
    delete response.meta;

    if (response.date && response.date != '') {
      console.log(response.date);
      var options = {
        preferredOrder: {
          '/': 'DMY',
          '.': 'DMY',
          '-': 'YMD'
        }
      };
      var format = parseFormat(response.date, options);
      response.dateObj = moment(response.date, format);
      response.date = response.dateObj.format('MMMM Do, YYYY');
    }

    if (response.summary) {
      response.text = response.summary;
    }
    return response;
  }
});
