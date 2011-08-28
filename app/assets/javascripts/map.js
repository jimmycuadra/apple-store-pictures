$(function () {
  var map, stores;

  map = new google.maps.Map(document.getElementById('map-canvas'), {
    center: new google.maps.LatLng(34.0522222, -118.2427778),
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    zoom: 10
  });

  this.DRQ = {
    bootstrap: function (data) {
      stores = data;

      stores.forEach(function (store) {
        store.latlng = new google.maps.LatLng(store.latitude, store.longitude);

        new google.maps.Marker({
          position: store.latlng,
          title: store.name,
          map: map
        });
      });
    }
  };
})(this);
