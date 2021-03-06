/*
* A view to search for address
*/


(function() {
  define(['jQuery', 'Underscore', 'Backpack', 'LocationService', 'LocationItemView', 'text!template/SearchView.html'], function($, _, Backpack, LocationService, LocationItemView, viewTemplate) {
    var locationService;
    locationService = LocationService.getInstance();
    return Backpack.View.extend({
      template: _.template(viewTemplate),
      events: {
        'click #search-button': 'onSearchButtonClick',
        'click #history-button': 'onHistoryButtonClick'
      },
      subscribers: {
        SEARCH_ADDRESS: 'doSearch'
      },
      messages: {
        ADDRESS_EMPTY: '<span style="color:red;">Please enter address to search</span>',
        ADDRESS_NOT_FOUND: '<span style="color:red;">Address not found</span>'
      },
      /*
      * Sets up main view
      */

      initialize: function(options) {
        var collection, searchListView,
          _this = this;
        Backpack.View.prototype.initialize.apply(this, arguments);
        this.render();
        /* execute search when ENTER key is pressed*/

        this.searchBox = this.$('#address-input');
        this.searchBox.keyup(function(e) {
          if (e.which === 13) {
            _this.doSearch(_this.searchBox.val(), function() {
              Backbone.trigger('ADD_LOCATION_HISTORY', _this.collection.models, {
                at: 0
              });
            });
          }
        });
        collection = this.collection = new Backpack.Collection(null, {
          model: Backpack.Model
        });
        searchListView = new Backpack.ListView({
          collection: collection,
          itemView: LocationItemView,
          subscribers: {
            UPDATE_SEARCH_RESULT: 'toggleContainerNode'
          }
        });
        this.$('#search-result-list').append(searchListView.$el);
        this.mapView = new Backpack.GoogleMapView({
          apiKey: 'AIzaSyDAJRmpbhxdAaoSYj2_iwaMEGxuxBR3YoM',
          subscribers: {
            INIT_GOOGLE_MAP: 'initMap',
            GOOGLE_MAP_SCRIPT_LOADED: '_onScriptLoaded'
          }
        });
        this.$('#map-container').append(this.mapView.$el);
      },
      /*
      * Renders template HTML
      */

      render: function() {
        this.$el.html(this.template());
        return this;
      },
      /*
      * Click event handler for [Search] button
      */

      onSearchButtonClick: function() {
        var _this = this;
        this.doSearch(this.searchBox.val(), function() {
          Backbone.trigger('ADD_LOCATION_HISTORY', [_this.collection.at(0).clone()], {
            at: 0
          });
        });
      },
      /*
      * Makes API calls to get current location and search for a given address
      * @param {String} address an address to search for
      * @param {Function} callback a callback function that gets called if both API call completes
      */

      doSearch: function(address, callback) {
        var getCurrentLocation, search,
          _this = this;
        if (!address || address.length === 0) {
          return Backbone.trigger('UPDATE_SEARCH_RESULT', false, this.messages.ADDRESS_EMPTY);
        }
        this.setLoading(true);
        this.$('#address-input').val(address);
        getCurrentLocation = function() {
          var dfd;
          dfd = $.Deferred();
          locationService.getCurrentLocation({
            success: function(pos) {
              console.log("current position: " + JSON.stringify(pos));
              dfd.resolve({
                lat: pos.coords.latitude,
                lng: pos.coords.longitude
              });
            },
            failure: function(error) {
              _this.setLoading(false);
              console.log('current location error: ' + error);
              dfd.reject();
            }
          });
          return dfd.promise();
        };
        search = function() {
          var dfd;
          dfd = $.Deferred();
          locationService.search(address, {
            success: function(data) {
              console.log("search result: " + JSON.stringify(data));
              dfd.resolve(data);
            },
            failure: function(error) {
              _this.setLoading(false);
              console.log('search error: ' + error);
              dfd.reject();
            }
          });
          return dfd.promise();
        };
        $.when(getCurrentLocation(), search()).done(function(currentLocation, searchData) {
          var location;
          _this.setLoading(false);
          if (!searchData || searchData.results.length === 0) {
            return Backbone.trigger('UPDATE_SEARCH_RESULT', false, _this.messages.ADDRESS_NOT_FOUND);
          }
          searchData = searchData.results[0];
          searchData.distance = locationService.calculateDistance(currentLocation, searchData.geometry.location);
          _this.collection.reset([searchData]);
          location = searchData.geometry.location;
          _this.mapView.setLocation(location);
          _this.mapView.addMarker(_.extend(location, {
            title: searchData.formatted_address
          }));
          if (callback && _.isFunction(callback)) {
            callback();
          }
        });
      },
      /*
      * Toggles loading mode of this view
      * @param {Boolean} isLoading a flag to specify loading mode or not
      */

      setLoading: function(isLoading) {
        this.$('#search-result-container').toggleClass('loading', isLoading);
      },
      /*
      * Click event handler for [History] button
      */

      onHistoryButtonClick: function() {}
    });
  });

}).call(this);
