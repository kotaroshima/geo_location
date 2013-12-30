/*
* A application view
*/


(function() {
  define(['jQueryUI', 'Backpack', 'SearchView', 'HistoryView'], function($, Backpack, SearchView, HistoryView) {
    return Backpack.View.extend({
      /*
      * Sets up main view
      */

      initialize: function(options) {
        var historyView, searchView;
        Backpack.View.prototype.initialize.apply(this, arguments);
        searchView = new SearchView({
          name: 'searchView'
        });
        historyView = new HistoryView({
          name: 'historyView'
        });
        this.stackView = new Backpack.StackView({
          children: [searchView, historyView],
          navigationEvents: {
            searchView: {
              event: 'onHistoryButtonClick',
              target: 'historyView'
            },
            historyView: {
              event: 'onBackButtonClick',
              back: true
            }
          },
          subscribers: {
            SHOW_VIEW: 'showChild'
          }
        });
        this.$el.append(this.stackView.$el);
      }
    });
  });

}).call(this);
