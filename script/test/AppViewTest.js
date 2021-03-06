(function() {
  define(['jQueryUI', 'AppView', 'LocationService'], function($, AppView, LocationService) {
    return {
      run: function() {
        QUnit.module('AppView', {
          setup: function() {
            $('#testNode').html('<div id="app-view"></div>');
            this.appView = new AppView();
            return $('#app-view').append(this.appView.$el);
          },
          teardown: function() {
            var _ref;
            return (_ref = this.appView) != null ? _ref.destroy() : void 0;
          }
        });
        QUnit.test('search view should be visible on load', 2, function() {
          QUnit.equal($('.search-view').is(':visible'), true);
          QUnit.equal($('.history-view').is(':visible'), false);
        });
        QUnit.test('clicking on [Search] button should call doSearchCall', 1, function() {
          var handle, searchStr;
          searchStr = 'Tokyo';
          $('#address-input').val(searchStr);
          handle = this.appView.stackView.getChild('searchView').attach('doSearch', function(address) {
            QUnit.equal(address, searchStr);
            handle.detach();
          });
          $('#search-button').trigger('click');
        });
        return QUnit.asyncTest('doSearch call should make location service calls', 1, function() {
          var handle, locationService, searchStr;
          searchStr = 'Tokyo';
          $('#address-input').val(searchStr);
          locationService = LocationService.getInstance();
          handle = locationService.attach('search', function(address) {
            QUnit.equal(address, searchStr);
            handle.detach();
            QUnit.start();
          });
          this.appView.stackView.getChild('searchView').doSearch(searchStr);
        });
      }
    };
  });

}).call(this);
