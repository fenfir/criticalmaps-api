var express = require('express');
var router = express.Router();
var pg = require('pg');
var debug = require('debug')('http');

router.get('/', function(req, res, next) {
  db.task(t => {
      return t.none('INSERT INTO "foo" (bar) values (\'blah\');')
        .then(dontCare => {
          return t.one('SELECT count(id) as counter FROM "foo";');
        });
    })
    .then(data => {
      console.log(data);
      res.send('This   p sage has been vwwwwwwwwwwwwiewed: ' + data.counter + ' times! from container ' + require("os").hostname());
    })
    .catch(error => {
      return console.log("ERROR:", error.message || error);
    });
});

router.get('/asdf', function(req, res, next) {
  debug("foo");
  res.send('index1234');
});

module.exports = router;
