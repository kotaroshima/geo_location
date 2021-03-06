###
* A singleton class that provides various location services
###
define(
  ['Backpack'],
  (Backpack)->
    Backpack.Class.extend
      plugins: [Backpack.Singleton]

      ###
      * Get current location using HTML5 Geolocation API
      * @param {Object} callbackObj a callback object
      * @param {Function} callbackObj.success a callback function which gets called when API call succeeds
      * @param {Function} [callbackObj.failure] a callback function which gets called when API call fails
      ###
      getCurrentLocation:(callbackObj)->
        if navigator.geolocation
          navigator.geolocation.getCurrentPosition callbackObj.success, callbackObj.failure
        else
          callbackObj.failure { code: "GEOLOCATION_DENIED" }
        return

      ###
      * Search for a specified address using Google Geocoding API
      * @param {String} address an address to search for
      * @param {Object} callbackObj a callback object
      * @param {Function} callbackObj.success a callback function which gets called when API call succeeds
      * @param {Function} [callbackObj.failure] a callback function which gets called when API call fails
      ###
      search:(address, callbackObj)->
        $.get('http://maps.googleapis.com/maps/api/geocode/json', { address: address, sensor: true }, callbackObj.success).fail(callbackObj.failure)
        return

      ###
      * Calculate distance between 2 points in kilometers
      * @param {Object} latlng1 an object that contains latitude/longitude data
      * @param {String} latlng1.lat latitude for a location
      * @param {String} latlng1.lng longitude for a location
      * @param {Object} latlng2 an object that contains latitude/longitude data
      * @param {String} latlng2.lat latitude for a location
      * @param {String} latlng2.lng longitude for a location
      * @return {Number}
      ###
      calculateDistance:(latlng1, latlng2)->
        r = 6378.137 # earth radius in kilometers
        PI = Math.PI
        diff_lng = PI*(latlng1.lng-latlng2.lng)/180
        diff_lat = PI*(latlng1.lat-latlng2.lat)/180
        x = Math.pow(Math.sin(diff_lat/2), 2) + Math.cos(latlng1.lat*PI/180) * Math.cos(latlng2.lat*PI/180) * Math.pow(Math.sin(diff_lng/2), 2)
        r*2*Math.atan2(Math.sqrt(x), Math.sqrt(1 - x))
)