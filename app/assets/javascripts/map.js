/*globals $, google */
//= require jquery.tmpl

$(function () {
  "use strict";

  var map, infoWindow, tmpl, stores;

  map = new google.maps.Map(document.getElementById('map-canvas'), {
    center: new google.maps.LatLng(34.0522222, -118.2427778),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    zoom: 10
  });

  infoWindow = new google.maps.InfoWindow();

  tmpl = $('#tmpl').template();

  window.DRQ = {
    bootstrap: function (data) {
      stores = data;

      stores.forEach(function (store) {
        store.marker = new google.maps.Marker({
          position: new google.maps.LatLng(store.latitude, store.longitude),
          title: store.name,
          map: map
        });

        google.maps.event.addListener(store.marker, 'click', function () {
          infoWindow.setContent($.tmpl(tmpl, store)[0]);
          infoWindow.open(map, store.marker);
        });
      });
    }
  };
})();
