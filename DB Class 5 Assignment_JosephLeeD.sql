/*
February 2022 MT Development Boot Camp
DB Class 5 Assignment
Tavern Scenario
	Create Tables
	Insert Seed Data
	
	Create Additional Tables
	Drop rat Table
	Add Seed Data for Additional Tables
	Add Primary and Foreign Key Constraints
	Test Foreign Key Constraints
	
	Create Additional Tables to Track Rooms
	Insert Seed Data for Tracking Rooms
	Create Queries

Created by JosephLeeD aka twigpi 2022-02-28
for SQL Server 2016+
*/

--drop existing tables for re-creation
DROP TABLE IF EXISTS exchange_rate;
DROP TABLE IF EXISTS room_stay;
DROP TABLE IF EXISTS tavern_room;

DROP TABLE IF EXISTS user_class;		--renamed to user_class_registry
DROP TABLE IF EXISTS user_class_registry;
DROP TABLE IF EXISTS guest_note;
DROP TABLE IF EXISTS tavern_guest;
DROP TABLE IF EXISTS user_status;
DROP TABLE IF EXISTS class_type;
DROP TABLE IF EXISTS supply_used_per_service;

DROP TABLE IF EXISTS sale;
DROP TABLE IF EXISTS service_provided;	--renamed to service_directory
DROP TABLE IF EXISTS service_directory;
DROP TABLE IF EXISTS service_status;
DROP TABLE IF EXISTS service;			--renamed to service_type
DROP TABLE IF EXISTS service_type;
DROP TABLE IF EXISTS current_inventory;
DROP TABLE IF EXISTS inventory_received;
DROP TABLE IF EXISTS supply_item;
DROP TABLE IF EXISTS unit_measure;
DROP TABLE IF EXISTS rat;				--deleted
DROP TABLE IF EXISTS tavern;
DROP TABLE IF EXISTS location;			--renamed to game_location
DROP TABLE IF EXISTS game_location;
DROP TABLE IF EXISTS tavern_user;
DROP TABLE IF EXISTS user_role;
DROP TABLE IF EXISTS description;		--renamed to description_list
DROP TABLE IF EXISTS description_list;
GO

--create tables for tavern scenario
CREATE TABLE description_list
(
	id INTEGER IDENTITY PRIMARY KEY,
	description_text VARCHAR(2047)
);

CREATE TABLE user_role
(
	id INTEGER IDENTITY PRIMARY KEY,
	role_name VARCHAR(31),
	description_list_id INTEGER,
	FOREIGN KEY (description_list_id) REFERENCES description_list(id)
);

CREATE TABLE tavern_user
(
	id INTEGER IDENTITY PRIMARY KEY,
	player_name VARCHAR(63),
	user_role_id INTEGER,
	FOREIGN KEY (user_role_id) REFERENCES user_role(id)
);

CREATE TABLE game_location
(
	id INTEGER IDENTITY PRIMARY KEY,
	location_name VARCHAR(63)
);

CREATE TABLE tavern
(
	id INTEGER IDENTITY PRIMARY KEY,
	tavern_name VARCHAR(63),
	game_location_id INTEGER,
	owner_id INTEGER,
	floor_count INTEGER
	FOREIGN KEY (game_location_id) REFERENCES game_location(id),
	FOREIGN KEY (owner_id) REFERENCES tavern_user(id)
);

CREATE TABLE rat
(
	id INTEGER IDENTITY PRIMARY KEY,
	rat_name VARCHAR(31),
	tavern_id INTEGER,
	FOREIGN KEY (tavern_id) REFERENCES tavern(id)
);

CREATE TABLE unit_measure
(
	id INTEGER IDENTITY PRIMARY KEY,
	unit_measure_name VARCHAR(31)
);

CREATE TABLE supply_item
(
	id INTEGER IDENTITY PRIMARY KEY,
	item_name VARCHAR(31),
	unit_measure_id INTEGER,
	FOREIGN KEY (unit_measure_id) REFERENCES unit_measure(id)
);

CREATE TABLE inventory_received
(
	id INTEGER IDENTITY PRIMARY KEY,
	supply_item_id INTEGER,
	tavern_id INTEGER,
	date_received DATE,
	amount INTEGER,
	FOREIGN KEY (supply_item_id) REFERENCES supply_item(id),
	FOREIGN KEY (tavern_id) REFERENCES tavern(id)
);

CREATE TABLE current_inventory
(
	id INTEGER IDENTITY PRIMARY KEY,
	supply_item_id INTEGER,
	tavern_id INTEGER,
	date_updated DATE,
	amount INTEGER,
	FOREIGN KEY (supply_item_id) REFERENCES supply_item(id),
	FOREIGN KEY (tavern_id) REFERENCES tavern(id)
);

CREATE TABLE service_type
(
	id INTEGER IDENTITY PRIMARY KEY,
	service_label VARCHAR(63)
);

CREATE TABLE service_status
(
	id INTEGER IDENTITY PRIMARY KEY,
	status_name VARCHAR(31)
);

CREATE TABLE service_directory
(
	id INTEGER IDENTITY PRIMARY KEY,
	tavern_id INTEGER,
	service_type_id INTEGER,
	service_status_id INTEGER,
	FOREIGN KEY (tavern_id) REFERENCES tavern(id),
	FOREIGN KEY (service_type_id) REFERENCES service_type(id),
	FOREIGN KEY (service_status_id) REFERENCES service_status(id)
);

CREATE TABLE sale
(
	id INTEGER IDENTITY PRIMARY KEY,
	service_directory_id INTEGER,
	guest_id INTEGER,
	price DECIMAL(10,2),
	date_purchased DATE,
	amount_purchased INTEGER,
	FOREIGN KEY (service_directory_id) REFERENCES service_directory(id),
	FOREIGN KEY (guest_id) REFERENCES tavern_user(id)
);


--insert seed data for tavern scenario
INSERT INTO description_list (description_text)
VALUES
	('The majority of a tavern''s patrons are working class people gathering at the end of the day. They''ve typically come from a long day of labor and are there for food and drink. Single workers who don''t have family at home likely come to the tavern for a good hot meal, since cooking for themselves would often be more expensive and time consuming. In addition to coming in for the amenities, they are also coming to meet their friends, socialize, and learn the news from around town. When you spend your whole day on labor you often don''t get a lot of opportunities for idle chit-chat, so this is the only chance a lot of people have for that.'),
	('Not only workers frequent taverns. Other townsfolk enter the scene and are there to take part in the social aspects of the evening. Young men and women from a town might come to the tavern looking to find romance. Villagers who spend their time taking care of houses or families also want a place to relax after they put their kids to bed. Older townsfolk might want to trade a story or two from when they were young. There''s a whole group of different people who meet up there at night.'),
	('When the whole town comes to the tavern at night, many businesses close their doors too. If you''re a shop owner you likely make up some of the wealthier patrons in a tavern. These people are often better dressed, buy more expensive food, and typically are very chummy with the tavern owner since their businesses usually work together. These kinds of patrons can easily stand out for your party to interact with and can be probed about their businesses while they drink. Be sure to consider these people when putting your tavern together.'),
	('While most of a tavern''s patrons will be workers from the town itself, there''s also a good chance that at least a handful of travelers will be there. These can be other adventurers, merchants, bards, and entertainers. Most likely tourism isn''t a huge part of your fantasy world, but there are a lot of people who might travel for work, opportunities in new areas, or just to see what''s out there. Without mass communication like we have in a modern society, travel can easily become a way of life for people in a fantasy setting.

Travelers are a great source of interesting information in a tavern. They bring news from afar and might be very different from the people of the town they''re in. People from the village might gather around them to hear stories of the places they''ve come from. Travelers might be in the middle of their own quests and offer potential jobs for players.'),
	('Wizards and warlocks might make for odd guests in a tavern. A hulking half-orc barbarian stands out in even the toughest crowds. Cloaked figures or strangers that no one has seen before could also easily walk in from off the streets.

What''s important is that these characters have a purpose. They stick out like a sore thumb, so players will interact with them. And if your players don''t, the other patrons certainly would. Just because a mysterious figure walks into a bar it doesn''t mean they''ll be waiting in a corner for the players to come talk to them. Give them some life and some purpose. Why are they there? Why that tavern specifically? Answer these questions and be ready to make these characters feel more real as a part of the scene.

An easy trope to fall into is having every standout mysterious figure offer a quest. Realistically, your players are more likely to be hired to guard a merchant caravan from a normal person than to be offered a treasure hunt from a random wizard in a bar.'),
	('A tavern isn''t complete without its staff. When you build and design a tavern you need to think about who needs to run it and what activities go into that. We''ll break down all of the operations for a fantasy tavern in the next section, but right now let''s just focus on who works there.

Every tavern has a barkeep and servers. These people handle the alcohol and take care of the money. Servers are often busing tables, bringing out food and beer, and bringing back money to the bar. A surprising amount of money can be spent in a tavern in a single evening and most of it goes through these individuals.

Beyond the running of food and drink, there are people in the back cooking, stocking, and cleaning. Usually these jobs are all combined and any back of house staff will bring up new kegs, cook, and clean throughout the night. Cooks might become more specialized over time, but the standard tavern fair is usually batch prepped during the day and then served en masse at night, so there''s not as much room for most tavern cooks to get really fancy with their meals.

Besides having people who keep up with the back and run the place in the front, taverns usually have daytime staff as well. People who clean the tavern, take care of the inn, shovel out the stables, and even take care of maintenance. A small town tavern may employ more than 10 people just to keep the place running. This doesn''t even include people who handle any special service_types.

While there are more people we could touch on, this paints the picture that a tavern isn''t usually a two person operation. Keeping up with customer demands requires a ton of help. Just be sure to keep your tavern staffed when you build a tavern you''re going to use multiple times. Players quickly come to know and remember people who work there, so it''s good to have notes on who they are.') ;

INSERT INTO user_role (role_name, description_list_id)
VALUES
	('Working Class Patron', 1),
	('Villager', 2),
	('Shop Owner', 3),
	('Traveler', 4),
	('Outlier or Mysterious Figure', 5),
	('Tavern Staff', 6) ;

INSERT INTO tavern_user (player_name, user_role_id)
VALUES
	('Twigpi', 4),
	('Bob Cobblestone', 1),
	('Quint Roundjaw', 3),
	('Captain Canada', 5),
	('Trisha Mack', 6),
	('Lee Marigold', 2),
	('Xian Zhao', 3),
	('Joedi Nations', 3),
	('Maimy Gardens', 1),
	('Casmr Bakery', 3),
	('Nose Parkins', 6),
	('Gordon Pheasantly', 1) ;

INSERT INTO game_location (location_name)
VALUES
	('Omashu'),
	('Renthbrook'),
	('Apple Meadow'),
	('Smoultriver'),
	('Shabrook'),
	('Frobury'),
	('Teock'),
	('Pallette Town'),
	('Bree'),
	('Plouckdon Pass') ;

INSERT INTO tavern (tavern_name, game_location_id, owner_id, floor_count)
VALUES
	('The Prancy Pony', 9, 5, 2),
	('Greenflower Inn', 3, 6, 3),
	('The Itchy Lobster Tavern', 4, 5, 2),
	('Flagon and Flagon', 6, 5, 4),
	('The Pangolin Cove', 3, 1, 1) ;

INSERT INTO rat (rat_name, tavern_id)
VALUES
	('Templeton', 2),
	('Soda', 4),
	('Pistachio', 3),
	('Cheddar', 3),
	('Socks', 4),
	('Chatters', 3),
	('Cruella', 3),
	('Scabbers', 4),
	('Rizzo', 3),
	('Splinter', 4) ;

INSERT INTO unit_measure (unit_measure_name)
VALUES
	('cuts'),
	('servings'),
	('pieces'),
	('pounds'),
	('gallons'),
	('dozen'),
	('ounces'),
	('packages'),
	('items'),
	('sets'),
	('mugs') ;

INSERT INTO supply_item (item_name, unit_measure_id)
VALUES
	('Meat', 1),
	('Vegetables', 2),
	('Fruits', 3),
	('Cheese', 4),
	('Milk', 5),
	('Eggs', 6),
	('Honey', 7),
	('Flour', 4),
	('Herbs and Spices', 7),
	('Salt', 4),
	('Brewing Ingredients', 8),
	('Barrels', 9),
	('Fuel', 4),
	('Soap/Lye', 4),
	('Dishes', 10),
	('Strong Drink', 11) ;

INSERT INTO inventory_received (supply_item_id, tavern_id, date_received, amount)
VALUES
	(12, 1, '1418-10-24', 20),
	( 1, 4, '1319-03-04', 16),
	( 2, 4, '1319-03-04', 20),
	( 4, 4, '1319-03-04', 4),
	( 5, 4, '1319-03-04', 20),
	( 8, 4, '1319-03-04', 10),
	(12, 4, '1319-03-05', 5),
	(13, 4, '1319-03-05', 15),
	(14, 4, '1319-03-05', 10),
	(15, 4, '1319-03-05', 6) ;

INSERT INTO current_inventory (supply_item_id, tavern_id, date_updated, amount)
VALUES
	( 1, 1, '1418-03-03', 30),
	( 1, 2, '1319-01-13', 34),
	( 1, 3, '1319-03-03', 37),
	( 1, 4, '1319-03-06', 42),
	( 1, 5, '1319-03-17', 31),
	(11, 1, '1418-03-03', 24),
	(11, 2, '1319-01-13', 18),
	(11, 3, '1319-03-03', 28),
	(11, 4, '1319-03-06', 35),
	(11, 5, '1319-03-17', 19) ;

INSERT INTO service_type (service_label)
VALUES
	('Hearty Meal'),
	('Drinks'),
	('Music and Dance'),
	('Baths'),
	('Mail Service'),
	('Weapons Sharpening'),
	('Rooms for Rent'),
	('Cleaning and Mending') ;

INSERT INTO service_status (status_name)
VALUES
	('Active'),
	('Inactive'),
	('Out of Stock'),
	('Discontinued'),
	('Half-Price') ;

INSERT INTO service_directory (tavern_id, service_type_id, service_status_id)
VALUES
	(1, 1, 1),
	(1, 2, 5),
	(1, 3, 1),
	(1, 7, 1),
	(2, 1, 1),
	(2, 2, 1),
	(2, 7, 2),
	(3, 1, 1),
	(3, 2, 1),
	(3, 3, 2),
	(3, 3, 4),
	(4, 1, 1),
	(4, 2, 1),
	(4, 3, 1),
	(4, 4, 1),
	(4, 5, 2),
	(4, 6, 1),
	(4, 8, 1),
	(5, 1, 1),
	(5, 2, 1),
	(5, 3, 1),
	(5, 5, 5) ;

INSERT INTO sale (service_directory_id, guest_id, price, date_purchased, amount_purchased)
VALUES
	(13, 2,   24.88, '1319-01-13',  2),
	(12, 2,  130.62, '1319-01-13',  1),
	(16, 2,   62.20, '1319-01-13', 10),
	( 4, 1,  497.60, '1418-10-24',  2),
	(22, 4, 1561.22, '1319-03-14', 10) ;


-- Section 2 ----------------------------------------
--           ----------------------------------------


--create additional tables
CREATE TABLE class_type
(
	id INTEGER IDENTITY PRIMARY KEY,
	class_name VARCHAR(31)
);

CREATE TABLE user_status
(
	id INTEGER IDENTITY PRIMARY KEY,
	status_name VARCHAR(31)
);

CREATE TABLE tavern_guest
(
	tavern_user_id INTEGER, --no auto increment
	birthday DATE,
	cakeday DATE,
	user_status_id INTEGER,
	PRIMARY KEY (tavern_user_id),
	FOREIGN KEY (tavern_user_id) REFERENCES tavern_user(id),
	FOREIGN KEY (user_status_id) REFERENCES user_status(id)
);

CREATE TABLE guest_note --keys added in ALTER statement
(
	id INTEGER IDENTITY,
	tavern_id INTEGER,
	tavern_user_id INTEGER,
	note_text varchar(2047)
);

CREATE TABLE user_class_registry
(
	id INTEGER IDENTITY PRIMARY KEY,
	tavern_user_id INTEGER,
	class_type_id INTEGER,
	class_level INTEGER
	FOREIGN KEY (tavern_user_id) REFERENCES tavern_guest(tavern_user_id),
	FOREIGN KEY (class_type_id) REFERENCES class_type(id),
);

CREATE TABLE supply_used_per_service
(
	id INTEGER IDENTITY PRIMARY KEY,
	service_type_id INTEGER,
	supply_item_id INTEGER,
	supply_amount INTEGER,
	FOREIGN KEY (service_type_id) REFERENCES service_type(id),
	FOREIGN KEY (supply_item_id) REFERENCES supply_item(id)
);


--remove rat table
DROP TABLE IF EXISTS rat;

--add foreign keys to guest_note table
ALTER TABLE guest_note
ADD PRIMARY KEY (id);

ALTER TABLE guest_note
ADD FOREIGN KEY (tavern_id) REFERENCES tavern(id);

ALTER TABLE guest_note
ADD FOREIGN KEY (tavern_user_id) REFERENCES tavern_guest(tavern_user_id);

--insert seed data for additional tables
INSERT INTO class_type (class_name)
VALUES
	('Shielder'),
	('Swashbuckler'),
	('Samurai'),
	('Crafter'),
	('Mage'),
	('Cleric'),
	('Brawler') ;

INSERT INTO user_status (status_name)
VALUES
	('Content'),
	('Hungry'),
	('Angry'),
	('Lonely'),
	('Tired'),
	('Sick'),
	('Ded'),
	('Depressed'),
	('Manic'),
	('Euphoric') ;

INSERT INTO tavern_guest (tavern_user_id, birthday, cakeday, user_status_id)
VALUES
	(1, '1988-10-16', '2017-11-14', 9),
	(2, '1980-03-04', '2005-06-23', 1),
	(3, '1972-02-14',     NULL    , 2),
	(4, '1867-07-01', '2018-07-02', 3),
	(8, '1989-06-24', '2015-12-10', 2) ;

INSERT INTO guest_note (tavern_id, tavern_user_id, note_text)
VALUES
	(2, 1, 'The man really loves his pangolins. Love his shield.'),
	(5, 2, 'What a well-built fellow. I love his curly fro.'),
	(4, 4, 'That sailor looks rough.'),
	(2, 8, 'Ms. Nations is wonderfully knowledgeable about a variety of subjects.'),
	(2, 8, 'Joedi is so kind and so strong.'),
	(4, 3, 'This man told an amazing story about a pair of socks.'),
	(4, 3, 'Steer clear of Roundjaw and he''ll steer clear of you. Usually.') ;

INSERT INTO user_class_registry (tavern_user_id, class_type_id, class_level)
VALUES
	(1, 1, 7),
	(1, 6, 4),
	(2, 2, 8),
	(2, 4, 8),
	(3, 2, 1337) ;

INSERT INTO supply_used_per_service (service_type_id, supply_item_id, supply_amount)
VALUES
	(1,  1, 1),
	(1,  2, 1),
	(1,  3, 1),
	(1,  4, 1),
	(1,  9, 1),
	(2, 16, 2),
	(3,  5, 1),
	(3,  6, 1),
	(4, 14, 1),
	(7, 13, 1),
	(7, 14, 1),
	(8, 14, 1) ;

/*
--display results of table creation and data insertion
SELECT * FROM user_class_registry;
SELECT * FROM guest_note;
SELECT * FROM tavern_guest;
SELECT * FROM user_status;
SELECT * FROM class_type;
SELECT * FROM supply_used_per_service;

SELECT * FROM sale;
SELECT * FROM service_directory;
SELECT * FROM service_status;
SELECT * FROM service_type;
SELECT * FROM current_inventory;
SELECT * FROM inventory_received;
SELECT * FROM supply_item;
SELECT * FROM unit_measure;
--SELECT * FROM rat;
SELECT * FROM tavern;
SELECT * FROM game_location;
SELECT * FROM tavern_user;
SELECT * FROM user_role;
SELECT * FROM description_list;
*/

--insertion and queries that will fail due to foreign key constraints
/*
INSERT INTO tavern_guest
VALUES (16, '2022-02-28', '2022-02-22', 10);
*/
--cannot think of a query that would fail due to foreign key constraints


-- Section 3 ----------------------------------------
--           ----------------------------------------


--create tables to track rooms 
CREATE TABLE tavern_room
(
	id INTEGER IDENTITY PRIMARY KEY,
	tavern_id INTEGER,
	room_status_id INTEGER,
	room_number INTEGER,
	FOREIGN KEY (tavern_id) REFERENCES tavern(id),
	FOREIGN KEY (room_status_id) REFERENCES service_status(id)
);

CREATE TABLE room_stay
(
	id INTEGER IDENTITY PRIMARY KEY,
	sale_id INTEGER,
	guest_id INTEGER,
	tavern_room_id INTEGER,
	date_stayed DATE,
	rate_per_night DECIMAL(10,2),
	FOREIGN KEY (sale_id) REFERENCES sale(id),
	FOREIGN KEY (guest_id) REFERENCES tavern_guest(tavern_user_id),
	FOREIGN KEY (tavern_room_id) REFERENCES tavern_room(id)
);

CREATE TABLE exchange_rate
(
	exchange_from_currency CHAR(3),
	exchange_to_currency CHAR(3),
	rate_of_exchange DECIMAL(14,5),
	PRIMARY KEY (exchange_from_currency, exchange_to_currency)
);

--insert seed data for tracking rooms tables
INSERT INTO service_status (status_name)
VALUES ('Occupied') ;

INSERT INTO service_directory (tavern_id, service_type_id, service_status_id)
VALUES
/*	(1, 7, 1), -- 4
	(2, 7, 2), -- 7 */
	(3, 7, 5), --23
	(4, 7, 1), --24
	(5, 7, 1) ;--25

INSERT INTO sale (service_directory_id, guest_id, price, date_purchased, amount_purchased)
VALUES
--	( 4,  1,  497.60, '1418-10-24',  2), --4
	( 7,  1,  909.08, '2022-03-17',  2), --6
	(23,  4,   59.66, '2020-04-02',  3), --7
	(24,  3, 3408.99, '2018-07-01',  3), --8
	(25,  8,  284.08, '2022-03-02',  1) ;--9

INSERT INTO user_class_registry (tavern_user_id, class_type_id, class_level)
VALUES
	(8, 3, 89),
	(8, 4, 47),
	(8, 5, 29) ;

/*	('Twigpi', 4),
	('Bob Cobblestone', 1),
	('Quint Roundjaw', 3),
	('Captain Canada', 5),
	('Trisha Mack', 6),
	('Lee Marigold', 2),
	('Xian Zhao', 3),
	('Joedi Nations', 3),
	('Maimy Gardens', 1),
	('Casmr Bakery', 3),
	('Nose Parkins', 6),
	('Gordon Pheasantly', 1) ;
*/

/*
	('Active'),
	('Inactive'),
	('Out of Stock'),
	('Discontinued'),
	('Half-Price'),
	('Occupied') ;
*/

/*
	('The Prancy Pony', 9, 5, 2),
	('Greenflower Inn', 3, 6, 3),
	('The Itchy Lobster Tavern', 4, 5, 2),
	('Flagon and Flagon', 6, 5, 4),
	('The Pangolin Cove', 3, 1, 1) ;
*/

INSERT INTO tavern_room (tavern_id, room_status_id, room_number)
VALUES
	(1, 1, 1),
	(1, 1, 2),
	(1, 6, 3),
	(2, 6, 1),
	(2, 1, 2),
	(2, 1, 3),
	(2, 6, 4),
	(2, 6, 5),
	(2, 1, 6),
	(3, 4, 1),
	(3, 4, 2),
	(4, 1, 1),
	(4, 1, 2),
	(4, 6, 3),
	(4, 6, 4),
	(4, 6, 5),
	(4, 6, 6),
	(4, 6, 7),
	(5, 1, 1) ;

INSERT INTO room_stay (sale_id, guest_id, tavern_room_id, date_stayed, rate_per_night)
VALUES
	(4, 1, 2, '1418-10-24',  248.80),
	(4, 1, 2, '1418-10-25',  248.80),
	(6, 1, 1, '2022-03-17',  454.54),
	(6, 1, 1, '2022-03-18',  454.54),
	(7, 4, 1, '2020-04-02',   29.83),
	(7, 4, 1, '2020-04-03',   29.83),
	(7, 4, 1, '2020-04-04',   29.83),
	(8, 3, 1, '2018-07-01', 1136.33),
	(8, 3, 1, '2018-07-02', 1136.33),
	(8, 3, 1, '2018-07-03', 1136.33),
	(9, 8, 1, '2022-03-02',  284.08) ;

INSERT INTO exchange_rate (exchange_from_currency, exchange_to_currency, rate_of_exchange)
VALUES
	('USD', 'DGP',   0.00176),
	('DGP', 'USD', 568.16665),
	('USD', 'DSP',   0.01760),
	('DSP', 'USD',  56.81667),
	('USD', 'DCP',   0.17600),
	('DCP', 'USD',   5.68167) ;

--queries
SELECT * FROM tavern_guest
WHERE YEAR(birthday) < 2000;

SELECT * FROM room_stay
WHERE rate_per_night > --should come to about 56816.67 in USD
	(SELECT 100 * rate_of_exchange FROM exchange_rate
	 WHERE exchange_from_currency = 'DGP'
	 AND exchange_to_currency = 'USD');

SELECT DISTINCT player_name FROM tavern_user
INNER JOIN tavern_guest ON tavern_user.id = tavern_guest.tavern_user_id
ORDER BY player_name ASC;

SELECT player_name FROM tavern_user
INNER JOIN tavern_guest ON tavern_user.id = tavern_guest.tavern_user_id
ORDER BY player_name DESC;

SELECT * FROM sale
WHERE price in
	(SELECT TOP 10 price FROM sale)
ORDER BY price DESC;

SELECT * FROM game_location
UNION ALL
SELECT * FROM user_status
UNION ALL
SELECT * FROM class_type
UNION ALL
SELECT * FROM description_list
UNION ALL
SELECT * FROM service_status
UNION ALL
SELECT * FROM service_type
UNION ALL
SELECT id, item_name FROM supply_item
UNION ALL
SELECT * FROM unit_measure;

SELECT
	tavern_user.player_name,
	class_type.class_name,
	CONCAT('Level ',
		   ROUND(class_level / 10, 0) * 10 + 1,
		   '-',
		   ROUND(class_level / 10, 0) * 10 + 10)
		AS class_level_group
FROM user_class_registry
INNER JOIN tavern_guest ON user_class_registry.tavern_user_id = tavern_guest.tavern_user_id
INNER JOIN class_type ON user_class_registry.class_type_id = class_type.id
INNER JOIN tavern_user ON tavern_guest.tavern_user_id = tavern_user.id;

DECLARE @NameOfTable VARCHAR(255);
SET @NameOfTable = 'tavern';
SELECT sql_text
FROM
(
	SELECT -1 AS I, CONCAT('CREATE TABLE ', @NameOfTable) AS sql_text
	UNION
	SELECT 0 AS I, '(' AS sql_text
	UNION
	SELECT
		ORDINAL_POSITION AS I,
		CASE
			WHEN DATA_TYPE = 'decimal'
				THEN CONCAT(CHAR(9), COLUMN_NAME, ' ', UPPER(DATA_TYPE), '(', NUMERIC_PRECISION, ', ', NUMERIC_SCALE, '),')
			WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL
				THEN CONCAT(CHAR(9), COLUMN_NAME, ' ', UPPER(DATA_TYPE), '(', CHARACTER_MAXIMUM_LENGTH, '),')
			ELSE
				CONCAT(CHAR(9), COLUMN_NAME, ' ', UPPER(DATA_TYPE), ',')
		END
		AS sql_text
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @NameOfTable
	AND ORDINAL_POSITION <
		(SELECT MAX(ORDINAL_POSITION) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @NameOfTable)
	UNION
	SELECT
		ORDINAL_POSITION AS I,
		CASE
			WHEN DATA_TYPE = 'decimal'
				THEN CONCAT(CHAR(9), COLUMN_NAME, ' ', UPPER(DATA_TYPE), '(', NUMERIC_PRECISION, ', ', NUMERIC_SCALE, ')')
			WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL
				THEN CONCAT(CHAR(9), COLUMN_NAME, ' ', UPPER(DATA_TYPE), '(', CHARACTER_MAXIMUM_LENGTH, ')')
			ELSE
				CONCAT(CHAR(9), COLUMN_NAME, ' ', UPPER(DATA_TYPE))
		END
		AS sql_text
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @NameOfTable
	AND ORDINAL_POSITION =
		(SELECT MAX(ORDINAL_POSITION) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @NameOfTable)
	UNION
	SELECT 254 AS I, ')' AS sql_text
	UNION
	SELECT 255 AS I, '--table created by table creater created by twigpi' AS sql_text
	ORDER BY I ASC OFFSET 0 ROWS
) AS A;


-- Section 4 ----------------------------------------
--           ----------------------------------------

--renames, script has been back updated since sql server doesn't allow rename in script
/*
service_provided -> service_directory
sale(service_provided_id) -> sale(service_directory_id)
tavern_user(user_name) -> tavern_user.player_name
location -> game_location
tavern(location_id) -> tavern(game_location_id)
service -> service_type
service_type(service_name) -> service_type(service_label)
service_directory(service_type_id) -> service_directory(service_type_id)
supply_used_per_service(service_type_id) -> supply_used_per_service(service_type_id)
description -> description_list
user_role(description_id) -> user_role(description_list_id)
user_class -> user_class_registry
*/

--fix faulty data
--nvm it was a faulty query

--add some more inventory by brewing
INSERT INTO current_inventory (supply_item_id, tavern_id, date_updated, amount)
(
	SELECT 16,
		   ingredients.tavern_id,
		   CASE
				WHEN ingredients.date_updated IS NOT NULL
					THEN DATEADD(day, 3, ingredients.date_updated)
				ELSE
					CAST( GETDATE() AS Date )
		   END,
		   CASE
				WHEN previous_supply.amount IS NOT NULL
					THEN ingredients.amount * 25 + previous_supply.amount
				ELSE
					ingredients.amount * 25
		   END
	FROM current_inventory AS ingredients
	LEFT JOIN 
	(
		SELECT tavern_id, amount
		FROM current_inventory
		WHERE supply_item_id = 16
	) AS previous_supply
	ON ingredients.tavern_id = previous_supply.tavern_id
	WHERE ingredients.supply_item_id = 11
	  AND ingredients.amount > 0
);

--consume ingredients used for brewing
UPDATE current_inventory
SET amount = 0
WHERE supply_item_id = 11;

--add sales for strong drink in each tavern
INSERT INTO sale (service_directory_id, guest_id, price, date_purchased, amount_purchased)
	SELECT service_directory.id,
		   4,
		   (
				SELECT ROUND(4 * 2 * rate_of_exchange, 2)
				FROM exchange_rate
				WHERE exchange_from_currency = 'DCP'
					AND exchange_to_currency = 'USD'
		   ),
		   recent_purchases.recent_date_purchased,
		   2
	FROM service_directory
	INNER JOIN
	(
		SELECT DATEADD( day, 1, MAX(sale.date_purchased) ) AS recent_date_purchased, service_directory.tavern_id
		FROM sale
		INNER JOIN service_directory ON sale.service_directory_id = service_directory.id
		GROUP BY service_directory.tavern_id
	) AS recent_purchases
	ON service_directory.tavern_id = recent_purchases.tavern_id
	WHERE service_type_id = 2
;

--inventory update to test welcome_text query
UPDATE current_inventory
SET amount = 10
WHERE id = 13;

--welcome_text query
SELECT CONCAT (
               '“Welcome, ',
               tavern_user.player_name,
               '. Your tavern, ',
               tavern.tavern_name,
               ' at ',
               game_location.location_name,
               ' is doing well. The last thing we sold was ',
               service_type.service_label,
               ' for ',
               sale.price,
               '.',
               CASE
                    WHEN MIN(current_inventory.amount - supply_used_per_service.supply_amount) IS NOT NULL
                        THEN
                            CASE
                                        --written this way to check for inventory that actually gets used in case of MIN tie at 0
                                WHEN MIN(current_inventory.amount - supply_used_per_service.supply_amount) < ( supply_used_per_service.supply_amount * 10 )
                                THEN ' Better order more supplies!'
                            END
                    ELSE ' Please update inventory!'
               END,
               '”'
               ) AS welcome_text
FROM tavern
INNER JOIN --table with most recent sale
(
    SELECT MAX(sale.id) AS most_recent_sale_id,
            service_directory.tavern_id AS tavern_id
    FROM sale
    INNER JOIN service_directory ON sale.service_directory_id = service_directory.id
    INNER JOIN
    (
        SELECT MAX(sale.date_purchased) AS most_recent_date_purchased,
                service_directory.tavern_id AS tavern_id
        FROM sale
        INNER JOIN service_directory ON sale.service_directory_id = service_directory.id
        GROUP BY service_directory.tavern_id
    ) AS most_recent_sale_by_tavern
    ON service_directory.tavern_id = most_recent_sale_by_tavern.tavern_id
    GROUP BY service_directory.tavern_id
) AS most_recent_sale_id_on_most_recent_date_purchased
ON tavern.id = most_recent_sale_id_on_most_recent_date_purchased.tavern_id
INNER JOIN sale ON most_recent_sale_id_on_most_recent_date_purchased.most_recent_sale_id = sale.id
INNER JOIN service_directory ON sale.service_directory_id = service_directory.id
INNER JOIN supply_used_per_service ON service_directory.service_type_id = supply_used_per_service.service_type_id
LEFT JOIN current_inventory
    ON supply_used_per_service.supply_item_id = current_inventory.supply_item_id
    AND service_directory.tavern_id = current_inventory.tavern_id
--lookup tables
INNER JOIN tavern_user ON tavern.owner_id = tavern_user.id
INNER JOIN game_location ON tavern.game_location_id = game_location.id
INNER JOIN service_type ON service_directory.service_type_id = service_type.id
INNER JOIN supply_item ON supply_used_per_service.supply_item_id = supply_item.id
GROUP BY tavern.id, --rest of tables listed as workaround as each should one be 1 per tavern
         tavern_user.player_name,
         tavern.tavern_name,
         game_location.location_name,
         service_type.service_label,
         sale.price,
         current_inventory.amount,
         current_inventory.amount,
         supply_used_per_service.supply_amount;

--created by twigpi 2022-03-05

--additional role
INSERT INTO description_list (description_text)
VALUES ('The all-powerful one. Short for administrator.');

INSERT INTO user_role (role_name, description_list_id)
VALUES ('Admin', 7);

INSERT INTO tavern_user (player_name, user_role_id)
VALUES ('Cats', 7);

--query to return users who have admin roles
SELECT player_name, role_name
FROM tavern_user
INNER JOIN user_role ON tavern_user.user_role_id = user_role.id
WHERE user_role_id = 7;

--sell The Itchy Lobster Tavern to the new admin
UPDATE tavern
SET owner_id = 13
WHERE tavern.id = 3;

--query to return users who have admin roles and information about their taverns
SELECT tavern_user.player_name, user_role.role_name,
	   tavern.tavern_name, game_location.location_name, tavern.floor_count
FROM tavern_user
INNER JOIN user_role ON tavern_user.user_role_id = user_role.id
INNER JOIN tavern ON tavern_user.id = tavern.owner_id
INNER JOIN game_location ON tavern.game_location_id = game_location.id
WHERE user_role_id = 7;

--query that returns all guests ordered by name (ascending) and their classes and corresponding levels
SELECT tavern_user.player_name, class_type.class_name, user_class_registry.class_level
FROM tavern_guest
INNER JOIN tavern_user ON tavern_guest.tavern_user_id = tavern_user.id
INNER JOIN user_class_registry ON tavern_guest.tavern_user_id = user_class_registry.tavern_user_id
INNER JOIN class_type ON user_class_registry.class_type_id = class_type.id
ORDER BY tavern_user.player_name;

--query that returns the top 10 sales in terms of sales price and what the services were
SELECT TOP 10 tavern_name,
			  tavern_user.player_name,
			  sale.price,
			  service_type.service_label,
			  sale.amount_purchased,
			  sale.date_purchased
FROM sale
INNER JOIN service_directory ON sale.service_directory_id = service_directory.id
INNER JOIN tavern ON service_directory.tavern_id = tavern.id
INNER JOIN tavern_user ON sale.guest_id = tavern_user.id
INNER JOIN service_type ON service_directory.service_type_id = service_type.id
ORDER BY sale.price DESC;

--query that returns guests with 2 or more classes
SELECT *
FROM
(
	SELECT tavern_user.player_name, COUNT(user_class_registry.tavern_user_id) AS number_of_classes
	FROM tavern_guest
	INNER JOIN user_class_registry ON tavern_guest.tavern_user_id = user_class_registry.tavern_user_id
	INNER JOIN tavern_user ON user_class_registry.tavern_user_id = tavern_user.id
	GROUP BY tavern_user.player_name
) AS users_list_by_number_of_classes
WHERE number_of_classes > 1;

--query that returns guests with 2 or more classes with levels higher than 5
SELECT *
FROM
(
	SELECT tavern_user.player_name, COUNT(user_class_registry.tavern_user_id) AS number_of_classes
	FROM tavern_guest
	INNER JOIN user_class_registry ON tavern_guest.tavern_user_id = user_class_registry.tavern_user_id
	INNER JOIN tavern_user ON user_class_registry.tavern_user_id = tavern_user.id
	WHERE user_class_registry.class_level > 5
	GROUP BY tavern_user.player_name
) AS users_list_by_number_of_classes
WHERE number_of_classes > 1;

--query that returns guests with ONLY their highest level class
SELECT tavern_user.player_name, class_type.class_name, user_class_registry.class_level
FROM tavern_guest
INNER JOIN tavern_user ON tavern_guest.tavern_user_id = tavern_user.id
INNER JOIN user_class_registry ON tavern_guest.tavern_user_id = user_class_registry.tavern_user_id
INNER JOIN class_type ON user_class_registry.class_type_id = class_type.id
INNER JOIN
(
	SELECT tavern_user_id, MAX(class_level) AS highest_class_level
	FROM user_class_registry
	GROUP BY tavern_user_id
) AS highest_class_level_by_tavern_user
ON tavern_guest.tavern_user_id = highest_class_level_by_tavern_user.tavern_user_id
WHERE user_class_registry.class_level = highest_class_level_by_tavern_user.highest_class_level
ORDER BY user_class_registry.class_level DESC, tavern_user.player_name ASC;

--query that returns guests that stay within a date range
SELECT tavern_user.player_name,
	   room_stay.date_stayed,
	   room_stay.rate_per_night,
	   tavern.tavern_name,
	   tavern_room.room_number
FROM room_stay
INNER JOIN tavern_user ON room_stay.guest_id = tavern_user.id
INNER JOIN tavern_room ON room_stay.tavern_room_id = tavern_room.id
INNER JOIN tavern ON tavern_room.tavern_id = tavern.id
WHERE room_stay.date_stayed BETWEEN '2022-03-01' AND '2022-03-31'
ORDER BY room_stay.date_stayed, tavern.tavern_name, tavern_user.player_name;

--extra credit will not be completed in time


-- Section 4.5 ----------------------------------------
--           ------------------------------------------

--fix faulty duplicate data
UPDATE service_directory
SET service_type_id = 4
WHERE tavern_id = 3
  AND service_type_id = 3
  AND service_status_id = 4;

--add UNIQUE constraints to prevent non-unique value combinations
--	(such as in case of a repeated INSERT statement)
ALTER TABLE service_directory
DROP CONSTRAINT IF EXISTS unique_service_per_tavern;

ALTER TABLE supply_used_per_service
DROP CONSTRAINT IF EXISTS unique_supply_per_service;

ALTER TABLE user_class_registry
DROP CONSTRAINT IF EXISTS unique_class_per_user;

ALTER TABLE current_inventory
DROP CONSTRAINT IF EXISTS unique_supply_per_tavern;


ALTER TABLE service_directory
ADD CONSTRAINT unique_service_per_tavern UNIQUE (tavern_id, service_type_id);

ALTER TABLE supply_used_per_service
ADD CONSTRAINT unique_supply_per_service UNIQUE (service_type_id, supply_item_id);

ALTER TABLE user_class_registry
ADD CONSTRAINT unique_class_per_user UNIQUE (tavern_user_id, class_type_id);

ALTER TABLE current_inventory
ADD CONSTRAINT unique_supply_per_tavern UNIQUE (supply_item_id, tavern_id);


--add service for tavern directly selling supplies
INSERT INTO service_type (service_label)
VALUES ('Direct Sell Supply Item'); --9

INSERT INTO service_directory (tavern_id, service_type_id, service_status_id)
(
	SELECT tavern.id, 9 as service_type_id, 1 as service_status_id
	FROM tavern
	
	EXCEPT
	
	SELECT tavern_id, service_type_id, service_status_id
	FROM service_directory
	WHERE service_type_id = 9 AND service_status_id = 1
);

--add column for tracking inventory received added to current inventory
ALTER TABLE inventory_received
ADD added_to_current_inventory BIT

--add inventory received to current_inventory
INSERT INTO current_inventory (supply_item_id, tavern_id, date_updated, amount)
(
	SELECT supply_item_id,
		   tavern_id,
		   CAST( GETDATE() AS Date ),
		   SUM(amount)
	FROM inventory_received
	GROUP BY tavern_id, supply_item_id

	EXCEPT

	SELECT inventory_received.supply_item_id,
		inventory_received.tavern_id,
		CAST( GETDATE() AS Date ),
		SUM(inventory_received.amount)
	FROM inventory_received
	INNER JOIN current_inventory
		ON inventory_received.tavern_id = current_inventory.tavern_id
		AND inventory_received.supply_item_id = current_inventory.supply_item_id
	GROUP BY inventory_received.tavern_id, inventory_received.supply_item_id
)

--add pricing to the service directory
GO
ALTER TABLE service_directory
ADD service_price DECIMAL(10, 2);
GO

--exchange rate function
--function description
IF OBJECT_ID (N'convertMoneyFromTo', N'FN') IS NOT NULL
	DROP FUNCTION convertMoneyFromTo;
GO
CREATE FUNCTION convertMoneyFromTo ( @moneyValue DECIMAL(10, 2), @convertFrom CHAR(3), @convertTo CHAR(3) )
RETURNS DECIMAL(10, 2)
AS
	BEGIN
		DECLARE @returnValue DECIMAL(10, 2);
		SELECT @returnValue = @moneyValue * rate_of_exchange
		FROM exchange_rate
		WHERE exchange_from_currency = @convertFrom
		  AND exchange_to_currency = @convertTo;
		IF (@returnValue IS NULL)
			SET @returnValue = @moneyValue;
		RETURN @returnValue;
	END
;

GO


--update previously added services with prices
UPDATE service_directory
SET service_price = dbo.convertMoneyFromTo(4, 'DSP', 'USD') +
					dbo.convertMoneyFromTo(4, 'DCP', 'USD')
WHERE tavern_id = 1 AND service_type_id = 7;

UPDATE service_directory
SET service_price = dbo.convertMoneyFromTo(8, 'DSP', 'USD')
WHERE tavern_id = 2 AND service_type_id = 7;

UPDATE service_directory
SET service_price = dbo.convertMoneyFromTo(7, 'DCP', 'USD')
WHERE tavern_id = 3 AND service_type_id= 7;

UPDATE service_directory
SET service_price = dbo.convertMoneyFromTo(2, 'DGP', 'USD')
WHERE tavern_id = 4 AND service_type_id = 7;

UPDATE service_directory
SET service_price = dbo.convertMoneyFromTo(5, 'DSP', 'USD')
WHERE tavern_id = 5 AND service_type_id = 7;

-- Section 5 ----------------------------------------
--           ----------------------------------------

--function to return a report of all users and their roles
GO
IF OBJECT_ID (N'reportAllUsersAndTheirRoles', N'IF') IS NOT NULL
	DROP FUNCTION reportAllUsersAndTheirRoles;
GO
CREATE FUNCTION reportAllUsersAndTheirRoles ()
RETURNS TABLE
AS
	RETURN
	(
		SELECT tavern_user.player_name AS "Tavern User",
			   COALESCE(status_name, 'No Status') AS "Status",
			   COALESCE(tavern_guest.birthday, '') AS "Birthday",
			   COALESCE(tavern_guest.cakeday, '') AS "Cakeday",
			   COALESCE(role_name, 'Bum') AS "Role",
			   COALESCE(description_text, 'Exciting possibilities.') AS "Role Description",
			   CASE
					WHEN taverns_owned_count.taverns_owned > 0
						THEN STR(taverns_owned_count.taverns_owned)
					ELSE
						''
			   END
			   AS "Taverns Owned"
		FROM tavern_user
		LEFT JOIN user_role ON tavern_user.user_role_id = user_role.id
		LEFT JOIN tavern_guest ON tavern_user.id = tavern_guest.tavern_user_id
		LEFT JOIN description_list ON user_role.description_list_id = description_list.id
		LEFT JOIN user_status ON tavern_guest.user_status_id = user_status.id
		LEFT JOIN
		(
			SELECT tavern_user.id AS tavern_user_id,
				   COUNT(tavern.id) AS taverns_owned
			FROM tavern_user
			LEFT JOIN tavern ON tavern_user.id = tavern.owner_id
			GROUP BY tavern_user.id
		) AS taverns_owned_count
		ON tavern_user.id = taverns_owned_count.tavern_user_id
		ORDER BY tavern_user.player_name OFFSET 0 ROWS --silly workaround to allow ORDER BY to work here
	)
;

GO

SELECT * FROM reportAllUsersAndTheirRoles();


--function to return all classes and the count of guests that hold those classes
GO
IF OBJECT_ID (N'reportAllClassesAndClassGuestCount', N'IF') IS NOT NULL
	DROP FUNCTION reportAllClassesAndClassGuestCount;
GO
CREATE FUNCTION reportAllClassesAndClassGuestCount ()
RETURNS TABLE
AS
	RETURN
	(
		SELECT class_type.class_name AS "Class Type",
			   COUNT(user_class_registry.tavern_user_id) AS "Class Users"
		FROM class_type
		LEFT JOIN user_class_registry ON class_type.id = user_class_registry.class_type_id
		LEFT JOIN tavern_guest ON user_class_registry.tavern_user_id = tavern_guest.tavern_user_id
		GROUP BY class_type.id, class_type.class_name
		ORDER BY [Class Users] DESC, class_type.class_name OFFSET 0 ROWS
	)
;

GO

SELECT * FROM reportAllClassesAndClassGuestCount()


--function that returns all guests ordered by name (ascending)
--and their classes and corresponding levels,
--with column labels for for their classes as
--	beginner (lvl 1-5), intermediate (5-10) and expert (10+)
--starting with helper function
GO
IF OBJECT_ID (N'returnClassLevelRanking', N'FN') IS NOT NULL
	DROP FUNCTION returnClassLevelRanking;
GO
CREATE FUNCTION returnClassLevelRanking (@classLevel INTEGER)
RETURNS VARCHAR(12)
AS
	BEGIN
		DECLARE @returnValue VARCHAR(12);
		SELECT @returnValue =
			CASE
				WHEN @classLevel < 0
					THEN CHAR(69) + CHAR(103) + CHAR(103)
				WHEN @classLevel <= 5
					THEN 'Beginner'
				WHEN @classLevel <= 10
					THEN 'Intermediate'
				WHEN @classLevel <= 100
					THEN 'Expert'
				WHEN @classLevel < 1000
					THEN 'Legendary'
				WHEN @classLevel >= 1000
					THEN 'Mythical'
				ELSE
					'Nonexistent'
			END
		IF (@returnValue IS NULL)
			SET @returnValue = 0;
		RETURN @returnValue;
	END
;

GO

IF OBJECT_ID (N'reportAllGuestsAndClassesRanked', N'IF') IS NOT NULL
	DROP FUNCTION reportAllGuestsAndClassesRanked;
GO
CREATE FUNCTION reportAllGuestsAndClassesRanked ()
RETURNS TABLE
AS
	RETURN
	(
		SELECT tavern_user.player_name AS "Guest Name",
			   class_type.class_name AS "Class Type",
			   user_class_registry.class_level AS "Class Level",
			   dbo.returnClassLevelRanking(user_class_registry.class_level) AS "Class Rank"
		FROM tavern_guest
		LEFT JOIN user_class_registry ON tavern_guest.tavern_user_id = user_class_registry.tavern_user_id
		LEFT JOIN tavern_user ON tavern_guest.tavern_user_id = tavern_user.id
		LEFT JOIN class_type ON user_class_registry.class_type_id = class_type.id
		ORDER BY [Guest Name] ASC, [Class Level] DESC, [Class Type] ASC OFFSET 0 ROWS
	)
;

GO

SELECT * FROM reportAllGuestsAndClassesRanked()


--function that takes a level and returns a “grouping”
GO
IF OBJECT_ID (N'returnClassLevelGrouping', N'FN') IS NOT NULL
	DROP FUNCTION returnClassLevelGrouping;
GO
CREATE FUNCTION returnClassLevelGrouping (@classLevel INTEGER)
RETURNS VARCHAR(12)
AS
	BEGIN
		DECLARE @returnValue VARCHAR(12);
		SELECT @returnValue =
			CASE
				WHEN @classLevel < 0
					THEN '< 0'
				WHEN @classLevel <= 5
					THEN '0-5'
				WHEN @classLevel <= 10
					THEN '6-10'
				WHEN @classLevel <= 100
					THEN '11-100'
				WHEN @classLevel < 1000
					THEN '101-999'
				WHEN @classLevel >= 1000
					THEN '1000+'
				ELSE
					'Imaginary'
			END
		IF (@returnValue IS NULL)
			SET @returnValue = 0;
		RETURN @returnValue;
	END
;

GO

SELECT dbo.returnClassLevelGrouping(7);


--function that returns a report of all open rooms
--on a particular day (input) and which tavern they belong to
--return a report of prices in a range (min and max prices)
--return rooms and their taverns based on price inputs
GO
IF OBJECT_ID (N'reportAllOpenRoomsAndPricesByDate', N'IF') IS NOT NULL
	DROP FUNCTION reportAllOpenRoomsAndPricesByDate;
GO
CREATE FUNCTION reportAllOpenRoomsAndPricesByDate (@onDate DATE)
RETURNS TABLE
AS
	RETURN
	(
		SELECT tavern.tavern_name AS "Tavern",
			   tavern_room.room_number AS "Room Number",
			   CASE
				   WHEN service_directory.service_type_id = 5 --half-price for all rooms
					   THEN ROUND(service_directory.service_price / 2, 2)
				   WHEN tavern_room.room_status_id = 1
					   THEN ROUND(service_directory.service_price, 2)
				   WHEN tavern_room.room_status_id = 5 --half-price for certain room
					   THEN ROUND(service_directory.service_price / 2, 2)
			   END
			   AS "Room Price per Night"
		FROM tavern_room
		INNER JOIN tavern ON tavern_room.tavern_id = tavern.id
		INNER JOIN service_directory ON tavern.id = service_directory.tavern_id
		WHERE service_directory.service_type_id = 7 --Rooms for Rent
		  AND service_directory.service_status_id IN (1, 5)
		  AND tavern_room.room_status_id IN (1, 5)

		EXCEPT --this is so sad - there must be a better way to accomplish this

		SELECT tavern.tavern_name AS "Tavern",
			   tavern_room.room_number AS "Room Number",
			   CASE
				   WHEN service_directory.service_type_id = 5 --half-price for all rooms
					   THEN ROUND(service_directory.service_price / 2, 2)
				   WHEN tavern_room.room_status_id = 1
					   THEN ROUND(service_directory.service_price, 2)
				   WHEN tavern_room.room_status_id = 5 --half-price for certain room
					   THEN ROUND(service_directory.service_price / 2, 2)
			   END
			   AS "Room Price per Night"
		FROM tavern_room
		INNER JOIN tavern ON tavern_room.tavern_id = tavern.id
		INNER JOIN service_directory ON tavern.id = service_directory.tavern_id
		INNER JOIN room_stay ON tavern_room.id = room_stay.tavern_room_id
		WHERE service_directory.service_type_id = 7 --Rooms for Rent
		  AND service_directory.service_status_id IN (1, 5)
		  AND tavern_room.room_status_id IN (1, 5)
		  AND room_stay.date_stayed = @onDate
	)
;

GO

SELECT * FROM reportAllOpenRoomsAndPricesByDate('2022-03-17');


--modified function that returns a report of prices in a range
--(min and max prices)
--return rooms and their taverns based on price inputs
GO
IF OBJECT_ID (N'reportAllOpenRoomsAndPricesByRange', N'IF') IS NOT NULL
	DROP FUNCTION reportAllOpenRoomsAndPricesByRange;
GO
CREATE FUNCTION reportAllOpenRoomsAndPricesByRange ( @minimumPrice DECIMAL(10, 2), @maximumPrice DECIMAL(10, 2) )
RETURNS TABLE
AS
	RETURN
	(
		SELECT tavern.tavern_name AS "Tavern",
			   tavern_room.room_number AS "Room Number",
			   CASE
				   WHEN service_directory.service_type_id = 5 --half-price for all rooms
					   THEN ROUND(service_directory.service_price / 2, 2)
				   WHEN tavern_room.room_status_id = 1
					   THEN ROUND(service_directory.service_price, 2)
				   WHEN tavern_room.room_status_id = 5 --half-price for certain rooms
					   THEN ROUND(service_directory.service_price / 2, 2)
			   END
			   AS "Room Price per Night"
		FROM tavern_room
		INNER JOIN tavern ON tavern_room.tavern_id = tavern.id
		INNER JOIN service_directory ON tavern.id = service_directory.tavern_id
		WHERE service_directory.service_type_id = 7 --Rooms for Rent
		  AND service_directory.service_status_id IN (1, 5)
		  AND tavern_room.room_status_id IN (1, 5)
		  AND @minimumPrice <=
			CASE
				WHEN service_directory.service_type_id = 5 --half-price for all rooms
					THEN ROUND(service_directory.service_price / 2, 2)
				WHEN tavern_room.room_status_id = 1
					THEN ROUND(service_directory.service_price, 2)
				WHEN tavern_room.room_status_id = 5 --half-price for certain rooms
					THEN ROUND(service_directory.service_price / 2, 2)
			END
		  AND @maximumPrice >=
			CASE
				WHEN service_directory.service_type_id = 5 --half-price for all rooms
					THEN ROUND(service_directory.service_price / 2, 2)
				WHEN tavern_room.room_status_id = 1
					THEN ROUND(service_directory.service_price, 2)
				WHEN tavern_room.room_status_id = 5 --half-price for certain rooms
					THEN ROUND(service_directory.service_price / 2, 2)
			END
		ORDER BY [Room Price per Night] ASC OFFSET 0 ROWS
	)
;

GO

SELECT * FROM reportAllOpenRoomsAndPricesByRange(0, 3000);


--stored procedure that uses reportAllOpenRoomsAndPricesByRange(0, 3000) to create a room in another tavern that undercuts (is less than) the cheapest room by a penny
GO
IF OBJECT_ID (N'undercutCheapestTavernRoom', N'P') IS NOT NULL
	DROP PROCEDURE undercutCheapestTavernRoom;
GO
CREATE PROCEDURE undercutCheapestTavernRoom
AS
	BEGIN
		SET NOCOUNT ON;
		
		UPDATE service_directory
		SET service_status_id = 5 --Half-Price
		WHERE tavern_id = 3 AND service_type_id = 7;
		
		UPDATE tavern_room
		SET room_status_id = 5 --Half-Price
		WHERE tavern_id = 3 AND room_number = 1;
		
		DECLARE @lowestPrice DECIMAL(10, 2);
		SET @lowestPrice =
		(
			SELECT TOP 1 [Room Price per Night]
			FROM reportAllOpenRoomsAndPricesByRange(0, 3000)
			WHERE NOT [Tavern] = 'The Itchy Lobster Tavern'
		);
		
		SET @lowestPrice = (@lowestPrice - 0.01) * 2;
		UPDATE service_directory
		SET service_price = @lowestPrice
		WHERE tavern_id = 3 and service_type_id = 7;
		
		SELECT * FROM reportAllOpenRoomsAndPricesByRange(0, 3000)
		CROSS JOIN (SELECT CONCAT( CHAR(65), 'g ', REPLICATE(CHAR(97) + CHAR(103), 5) ) AS "Mr. Krabs")
		AS crustacean_dialogue;
	END
GO

EXEC undercutCheapestTavernRoom;
