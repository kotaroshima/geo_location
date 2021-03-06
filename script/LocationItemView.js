/*
* A view for each items in the search result list
*/


(function() {
  define(['Underscore', 'Backpack', 'text!template/LocationItemView.html'], function(_, Backpack, viewTemplate) {
    return Backpack.View.extend({
      template: _.template(viewTemplate),
      attributes: {
        "class": 'location-item'
      },
      events: {
        'click .location-item': 'onClick'
      },
      initialize: function(options) {
        Backpack.View.prototype.initialize.apply(this, arguments);
        this.render();
      },
      render: function() {
        var data;
        data = _.extend(this.model.attributes, {
          formatNumber: function(num, precision) {
            var pow;
            if (precision == null) {
              precision = 2;
            }
            pow = Math.pow(10, precision);
            return Math.round(num * pow) / pow;
          }
        });
        this.$el.html(this.template(data));
        return this;
      },
      onClick: function() {}
    });
  });

}).call(this);
