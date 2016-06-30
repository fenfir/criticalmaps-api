var express = require('express');
var router = express.Router();
var debug = require('debug')('http');
var QueryFile = require('pg-promise').QueryFile;

router.post('/', function(req, res, next) {
  console.log(req.body); // your JSON

  db.tx(function(t1) {
      return this.batch([
        save_own_location_task(req, t1),
        retrieve_other_locations(req, t1),
        t1.tx(function(t2) {
          return this.batch(save_messages_batch(req, t2));
        })
      ]);
    })
    .then(function(data) {
      var response_obj = {};
      response_obj.locations = data[1];
      res.send(response_obj);
    })
    .catch(function(error) {
      console.log("ERROR:", error.message || error);
      res.status(500).send({
        error: 'error!'
      });
    });
});

save_own_location_task = function(req, t) {
  if (req.body.hasOwnProperty("device") && req.body.hasOwnProperty("location")) {
    return t.none("insert into locations(device, longitude, latitude) values($1, $2, $3)", [req.body.device, req.body.location.longitude, req.body.location.latitude]);
  } else {
    return null;
  }
}

retrieve_other_locations = function(req, t) {
  return t.any(QueryFile('../sql/locations.sql'), [req.body.device]);
}

save_messages_batch = function(req, t) {
  if (!req.body.hasOwnProperty("messages")) {
    return null;
  }

  req.body.messages.sort(function(a, b) {
    return a.timestamp - b.timestamp;
  });

  var save_messages_batch = [];
  var delay_counter = 1;
  req.body.messages.forEach(function(message) {
    var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    var latitude;
    var longitude;

    if (req.body.hasOwnProperty("location")) {
      latitude = req.body.location.latitude
      longitude = req.body.location.longitude
    }

    save_messages_batch.push(
      t.none(QueryFile('../sql/save_messages.sql'), [
        message.text,
        delay_counter,
        ip,
        message.identifier,
        longitude,
        latitude
      ])
    );
    delay_counter++;
  })
  return save_messages_batch;
}

module.exports = router;
