var express = require('express');
var router = express.Router();
var debug = require('debug')('http');
var QueryFile = require('pg-promise').QueryFile;

router.post('/', function(req, res, next) {
  console.log(req.body); // your JSON

  db.tx(function(t1) {
      return t1.batch([
        save_messages_batch(req, t1),
        save_own_location_task(req, t1)
      ]);
    }).then(function(data_dont_care) {
      db.tx(function(t1) {
        return t1.batch([
          retrieve_other_locations(req, t1),
          retrieve_chat_messages(req, t1)
        ])
      }).then(function(data) {
        var response_obj = {
          locations: {},
          chatMessages: {}
        };
        data[0].forEach(function(location_obj) {
          response_obj.locations[location_obj.device] = {
            "longitude": location_obj.longitude,
            "latitude": location_obj.latitude,
            "timestamp": location_obj.timestamp
          }
        });

        data[1].forEach(function(message_obj) {
          response_obj.chatMessages[message_obj.identifier] = {
            "message": message_obj.message,
            "timestamp": message_obj.timestamp
          }
        });

        res.send(response_obj);
      }).catch(function(error) {
        handle_error(error)
      });
    })
    .catch(function(error) {
      handle_error(error)
    });
});

var save_own_location_task = function(req, t) {
  if (req.body.hasOwnProperty("device") && req.body.hasOwnProperty("location")) {
    return t.none("insert into locations(device, longitude, latitude) values($1, $2, $3)", [req.body.device, req.body.location.longitude, req.body.location.latitude]);
  } else {
    return null;
  }
}

var retrieve_other_locations = function(req, t) {
  return t.any(QueryFile('../sql/locations.sql'), [req.body.device]);
}

var save_messages_batch = function(req, t) {
  if (!req.body.hasOwnProperty("messages")) {
    return null;
  }

  req.body.messages.sort(function(a, b) {
    return a.timestamp - b.timestamp;
  });

  var save_messages_batch = [];
  var delay_counter = 0;
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

var retrieve_chat_messages = function(req, t) {
  return t.any("SELECT * FROM chat_messages WHERE timestamp > (NOW() - '$1 minutes'::INTERVAL)", [30]);
}

var handle_error = function(error) {
  console.log("ERROR:", error.message || error);
  res.status(500).send({
    error: 'error!'
  });
}

module.exports = router;
