###
* A view to search for address
###
define(
  ['jQuery', 'Underscore', 'Backpack', 'LocationService', 'LocationItemView', 'text!template/SearchView.html'],
  ($, _, Backpack, LocationService, LocationItemView, viewTemplate)->
    locationService = LocationService.getInstance()

    Backpack.View.extend
      template: _.template viewTemplate

      events:
        'click #search-button': 'onSearchButtonClick'
        'click #history-button': 'onHistoryButtonClick'

      subscribers:
        SEARCH_ADDRESS: 'doSearch'

      messages:
        ADDRESS_EMPTY: '<span style="color:red;">Please enter address to search</span>'
        ADDRESS_NOT_FOUND: '<span style="color:red;">Address not found</span>'

      ###
      * Sets up main view
      ###
      initialize:(options)->
        Backpack.View::initialize.apply @, arguments
        @render()

        ### execute search when ENTER key is pressed ###
        @searchBox = @$ '#address-input'
        @searchBox.keyup (e)=>
          if e.which == 13
            @doSearch @searchBox.val(), =>
              Backbone.trigger 'ADD_LOCATION_HISTORY', @collection.models, { at:0 }
              return
          return

        collection = @collection = new Backpack.Collection null,
          model: Backpack.Model

        searchListView = new Backpack.ListView
          collection: collection
          itemView: LocationItemView
          subscribers:
            UPDATE_SEARCH_RESULT: 'toggleContainerNode'
        @$('#search-result-list').append searchListView.$el

        @mapView = new Backpack.GoogleMapView
          apiKey: 'AIzaSyDAJRmpbhxdAaoSYj2_iwaMEGxuxBR3YoM'
          subscribers:
            INIT_GOOGLE_MAP: 'initMap'
            GOOGLE_MAP_SCRIPT_LOADED: '_onScriptLoaded'
        @$('#map-container').append @mapView.$el

        return

      ###
      * Renders template HTML
      ###
      render:->
        @$el.html @template()
        @

      ###
      * Click event handler for [Search] button
      ###
      onSearchButtonClick:->
        @doSearch @searchBox.val(), =>
          Backbone.trigger 'ADD_LOCATION_HISTORY', [@collection.at(0).clone()], { at:0 }
          return
        return

      ###
      * Makes API calls to get current location and search for a given address
      * @param {String} address an address to search for
      * @param {Function} callback a callback function that gets called if both API call completes
      ###
      doSearch:(address, callback)->
        return Backbone.trigger 'UPDATE_SEARCH_RESULT', false, @messages.ADDRESS_EMPTY if !address || address.length == 0

        @setLoading true

        # update address input field
        @$('#address-input').val address

        # get current location
        getCurrentLocation = =>
          dfd = $.Deferred()
          locationService.getCurrentLocation
            success:(pos)=>
              console.log "current position: "+JSON.stringify(pos)
              dfd.resolve lat: pos.coords.latitude, lng: pos.coords.longitude
              return
            failure:(error)=>
              @setLoading false
              console.log 'current location error: '+error
              # TODO : cancel search call
              dfd.reject()
              return
          dfd.promise()

        # search for address
        search = =>
          dfd = $.Deferred()
          locationService.search address,
            success:(data)=>
              console.log "search result: "+JSON.stringify(data)
              dfd.resolve data
              return
            failure:(error)=>
              @setLoading false
              console.log 'search error: '+error
              # TODO : cancel getCurrentLocation call
              dfd.reject()
              return
          dfd.promise()

        # update views when all api calls have finished
        $.when(getCurrentLocation(), search()).done (currentLocation, searchData)=>
          @setLoading false

          return Backbone.trigger 'UPDATE_SEARCH_RESULT', false, @messages.ADDRESS_NOT_FOUND if !searchData || searchData.results.length == 0

          searchData = searchData.results[0]
          searchData.distance = locationService.calculateDistance currentLocation, searchData.geometry.location

          # update search result list view
          @collection.reset [searchData]

          # update of Google map
          location = searchData.geometry.location
          @mapView.setLocation location
          @mapView.addMarker _.extend location, title: searchData.formatted_address

          # add item to history list view
          callback() if callback && _.isFunction callback
          return
        return

      ###
      * Toggles loading mode of this view
      * @param {Boolean} isLoading a flag to specify loading mode or not
      ###
      setLoading:(isLoading)->
        @$('#search-result-container').toggleClass 'loading', isLoading
        return

      ###
      * Click event handler for [History] button
      ###
      onHistoryButtonClick:->
)