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
        'click #search-button': 'onSearchButtonClicked'
        'click #history-button': 'onHistoryButtonClicked'

      subscribers:
        SEARCH_ADDRESS: 'doSearch'

      ###
      * Sets up main view
      ###
      initialize:(options)->
        Backpack.View::initialize.apply @, arguments
        @render()

        collection = @collection = new Backpack.Collection null,
          model: Backpack.Model

        searchListView = new Backpack.ListView
          collection: collection
          itemView: LocationItemView
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
      onSearchButtonClicked:->
        @doSearch $('#address-input').val()
        return

      ###
      * Makes API calls to get current location and search for a given address
      * @param {String} address an address to search for
      ###
      doSearch:(address)->
        @setLoading true
        currentPos = null
        searchCallbackObj =
          success:(data)=>
            console.log "search result: "+JSON.stringify(data)
            modelData = _.map data.results, (result)=>
              result.distance = locationService.calculateDistance currentPos, result.geometry.location
              result

            # update search result list view
            @collection.reset [modelData[0]]

            # update center of Google map
            @mapView.setLocation modelData[0].geometry.location

            # add item to history list view
            Backbone.trigger 'ADD_LOCATION_HISTORY', @collection.models, { at:0 }
            @setLoading false
            return
          failure:(error)=>
            @setLoading false
            console.log 'search error: '+error
            return
        currentLocationCallbackObj =
          success:(pos)=>
            currentPos =
              lat: pos.coords.latitude
              lng: pos.coords.longitude
            console.log "current position: "+JSON.stringify(pos)
            locationService.search address, searchCallbackObj
            return
          failure:(error)=>
            @setLoading false
            console.log 'current location error: '+error
            return
        locationService.getCurrentLocation currentLocationCallbackObj
        return

      ###
      * Toggles loading mode of this view
      * @param {Boolean} isLoading a flag to specify loading mode or not
      ###
      setLoading:(isLoading)->
        $('#search-result-container').toggleClass 'loading', isLoading
        return

      ###
      * Click event handler for [History] button
      ###
      onHistoryButtonClicked:->
)