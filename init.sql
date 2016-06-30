-- //////////////////////////////
-- CHAT_MESSAGES
-- //////////////////////////////
CREATE TABLE IF NOT EXISTS chat_messages (
  message text NOT NULL,
  ip inet NOT NULL,
  timestamp timestamp NOT NULL default current_timestamp,
  identifier varchar(40) NOT NULL,
  longitude integer DEFAULT NULL,
  latitude integer DEFAULT NULL
);

INSERT INTO chat_messages (message, ip, timestamp, identifier, longitude, latitude) VALUES
('cine+mai+e+sproape%3F', '92.115.254.84', '2015-08-20 20:18:29', '77feea55a4eb59743a50cca92ea1838d146202f2', NULL, NULL),
('Hallo+%3F', '188.102.55.231', '2015-08-20 21:46:40', '317fcf71aaca4a899231ad838eae3eff95134d9f', '52514572', '13423950');

-- //////////////////////////////
-- LOCATIONS
-- //////////////////////////////
CREATE TABLE IF NOT EXISTS locations (
  id SERIAL,
  device varchar(40) NOT NULL,
  timestamp timestamp NOT NULL default current_timestamp,
  longitude integer DEFAULT NULL,
  latitude integer DEFAULT NULL
);

INSERT INTO locations (id, device, timestamp, longitude, latitude) VALUES
(5505424, 'eecbdd5e777eba579711b781e6f7ca35d29ef126', '2016-06-29 19:09:42', '13226078', '52541124'),
(5505425, '5ed598cddac16f2928e35ce8df20f269a10a3d0e', '2016-06-29 19:09:45', '8266885', '49999981');


-- CREATE TYPE review_state AS ENUM ('unaudited', 'approved', 'rejected');
-- CREATE TABLE IF NOT EXISTS images (
--   id SERIAL,
--   timestamp timestamp NOT NULL default current_timestamp,
--   longitude integer DEFAULT NULL,
--   latitude integer DEFAULT NULL,
--   image_id text NOT NULL,
--   review_state review_state NOT NULL DEFAULT 'unaudited'
-- );
--
-- INSERT INTO images (id, timestamp, longitude, latitude, image_id, review_state) VALUES
-- (43, '2015-08-21 18:02:10', '11545890', '48130834', '55d767a25817d', 'unaudited'),
-- (44, '2015-08-21 18:09:04', '11546298', '48130287', '55d7694067362', 'unaudited');
