/*globals $, google, _ */
//= require underscore
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

        store.marker.store = store;

        google.maps.event.addListener(store.marker, 'click', DRQ.renderInfoWindow);
      });
    },

    renderInfoWindow: function () {
      infoWindow.setContent($.tmpl(tmpl, this.store)[0]);
      infoWindow.open(map, this);
    },

    savePicture: function (evt) {
      var $form = $(evt.target),
          id = $form.data('id');

      evt.preventDefault();

      $.post("/stores/" + id, $form.serialize(), function (updatedStore) {
        infoWindow.close();

        stores = _(stores).map(function(store) {
          if (store.id === updatedStore.id) {
            return $.extend(store, updatedStore);
          } else {
            return store;
          }
        });
      }, "json");
    },

    removePicture: function (evt) {
      var id = parseInt($(evt.target).data('id'));

      $.post("/stores/" + id + "/remove_picture", {
        _method: "put",
      }, function () {
        infoWindow.close();

        stores = _(stores).map(function(store) {
          if (store.id === id) {
            store.picture = null;
          }

          return store;
        });
      });
    }
  };

  $('#map-canvas').delegate('form', 'submit', DRQ.savePicture).delegate('.remove-picture', 'click', DRQ.removePicture);
});
