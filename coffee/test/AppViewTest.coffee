define(
  ['jQueryUI', 'AppView', 'LocationService'],
  ($, AppView, LocationService)->
    {
      run:->

        QUnit.module 'AppView', {
          setup:->
            $('#testNode').html '<div id="app-view"></div>'
            @appView = new AppView()
            $('#app-view').append @appView.$el
          teardown:->
            @appView?.destroy()
        }

        QUnit.test 'search view should be visible on load', 2, ->
          QUnit.equal $('.search-view').is(':visible'), true
          QUnit.equal $('.history-view').is(':visible'), false
          return

        QUnit.test 'clicking on [Search] button should call doSearchCall', 1, ->
          searchStr = 'Tokyo'
          $('#address-input').val searchStr
          handle = @appView.stackView.getChild('searchView').attach 'doSearch', (address)->
            QUnit.equal address, searchStr
            handle.detach()
            return
          $('#search-button').trigger 'click'
          return

        QUnit.asyncTest 'doSearch call should make location service calls', 1, ->
          searchStr = 'Tokyo'
          $('#address-input').val searchStr
          locationService = LocationService.getInstance()
          handle = locationService.attach 'search', (address)->
            QUnit.equal address, searchStr
            handle.detach()
            QUnit.start()
            return
          @appView.stackView.getChild('searchView').doSearch searchStr
          return
    }
)