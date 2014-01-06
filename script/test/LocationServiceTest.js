(function() {
  define(['LocationService'], function(LocationService) {
    return {
      run: function() {
        var assertApproximate, service;
        service = LocationService.getInstance();
        assertApproximate = function(result, expected, deviation) {
          if (deviation == null) {
            deviation = 0.2;
          }
          QUnit.ok(Math.abs(result / expected - 1.0) < deviation);
        };
        QUnit.module('LocationService');
        QUnit.asyncTest('search for an existing address should return a correct location', 2, function() {
          var callbackObj;
          callbackObj = {
            success: function(data) {
              var location;
              location = data.results[0].geometry.location;
              assertApproximate(location.lat, 35.66);
              assertApproximate(location.lng, 139.70);
              QUnit.start();
            }
          };
          service.search('Shibuya', callbackObj);
        });
        QUnit.asyncTest('search for a non-existing address should return no locations', 2, function() {
          var callbackObj;
          callbackObj = {
            success: function(data) {
              QUnit.equal(data.status, 'ZERO_RESULTS');
              QUnit.equal(data.results.length, 0);
              QUnit.start();
            }
          };
          service.search('123456789', callbackObj);
        });
        QUnit.test('calculate distance between 2 locations', 1, function() {
          var d, d_actual, latlng1, latlng2;
          latlng1 = {
            lat: 35.65,
            lng: 139.74
          };
          latlng2 = {
            lat: 36.10,
            lng: 140.09
          };
          d = service.calculateDistance(latlng1, latlng2);
          d_actual = 58.50;
          console.log(d + ", " + d_actual);
          assertApproximate(d, d_actual);
        });
      }
    };
  });

}).call(this);
