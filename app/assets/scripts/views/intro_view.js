String.prototype.capitalizeFirstLetter = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}

module.exports = Backbone.View.extend({

  template: require('../templates/intro.hbs'),

  className: 'intro wrapper',

  events: {
    'click #create': 'goToNavigatorHome',
    'click [type="checkbox"]': 'checkbox',
    'keyup input': 'keyPressEventHandler'
  },

  keyPressEventHandler : function(event) {
    if (event.keyCode === 13) {
      this.$('#create').click();
    }
  },

  scrollLeft: function() {
    var that = this;
    var slider = this.$('.slider');
    slider.animate({ left: '-100%' });
    setTimeout(function() {
      slider.animate({ height: that.$('.confirmation').height() });
    }, 200);
    this.$('.meta').fadeOut();
    this.$('.intro-message').hide();
    this.$('.confirmation-message').show();
  },

  goToNavigatorHome: function(event) {
    var that = this;
    var button = $(event.target);

    if (this.validateClientSide() === true) {
      $.ajax({
        url: '/api/navigators',
        type: 'post',
        data: {
          key: this.$('#key').val(),
          name: this.$('#name').val(),
          password_protected: this.$('#password_protected').is(':checked'),
          username: this.$('#username').val()
        }
      }).done(function(data) {
        button.html('Navigator created!');
        var url = window.location.href + data.url_hash + '/' + data.slug;
        var urlLink = '<a href="' + url + '" target="_blank">' + url + '</a>';
        that.$('.confirmation .url span').html(urlLink);
        if (data.password_protected == true) {
          that.$('.confirmation .username span').html(data.username);
          that.$('.confirmation .password span').html(data.password);
        } else {
          that.$('.confirmation .username, .confirmation .password').hide();
        }
        that.scrollLeft();
      }).error(function(data) {
        if (data.status == 400) {
          var errorStr = data.responseJSON.message.capitalizeFirstLetter();
          that.$('.errors').html(errorStr).fadeIn();
          _.each(data.responseJSON.message.split(', '), function(k, v) {
            $('#' + k.split(' ')[0]).addClass('error');
          });
        } else {
          window.alert(data.status + ' - ' + data.statusText);
        }
      });
    }

    event.preventDefault();
  },

  validateClientSide: function() {
    this.$('input.error').removeClass('error');
    this.errors = [];
    this.validatePresent('key');
    this.validatePresent('name');

    if (this.$('#password_protected').is(':checked') === true) {
      this.validatePresent('username');
    }

    if (this.errors.length > 0) {
      var errorStr = this.errors.join(', ').capitalizeFirstLetter();
      this.$('.errors').html(errorStr).fadeIn();
      return false;
    } else {
      this.$('.errors').fadeOut();
    }

    return true;
  },

  validatePresent: function(id) {
    var el = this.$('#' + id);
    if (_.isEmpty(el.val())) {
      this.errors.push(id + ' is blank');
      el.addClass('error');
    }
  },

  checkbox: function(event) {
    this.$('.authentication').slideToggle(this.$('[type="checkbox"]').is(':checked'));
  },

  render: function() {
    $(this.el).html(this.template());
  }

});
