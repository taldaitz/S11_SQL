CREATE DATABASE formation;

/*comment 
sur plusieurs lignes
*/
SHOW DATABASES;

USE formation;

SHOW TABLES ;


DROP TABLE contact;

CREATE TABLE contact (
	id int PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    email VARCHAR(255) NULL UNIQUE
);

DESCRIBE contact;



INSERT INTO contact (firstname, lastname, email)
VALUES ('Thomas', 'Aldaitz', 'taldaitz@dawan.fr')
;

INSERT INTO contact (firstname, lastname)
VALUES ('Titi', 'Toto')
;

SELECT * FROM contact;


INSERT INTO contact (firstname, lastname, email)
VALUES ('Robert', 'Test', 'rtest@dawan.fr'),
		('Jean', 'Retest', null)
;


UPDATE contact
SET email = 'jrtruc@gmail.com', lastname = 'Truc'
WHERE  id = 3
;



SELECT * FROM contact
WHERE lastname LIKE '%a%'
;




DROP TABLE booking;

CREATE TABLE booking (
id int PRIMARY KEY AUTO_INCREMENT,
customer_firstname VARCHAR(100) NOT NULL,
customer_lastname VARCHAR(100) NOT NULL,
customer_phone_number VARCHAR(20) NULL,
customer_email VARCHAR(255) NOT NULL,
start DATE NOT NULL,
end DATE NOT NULL,
room_number INT NOT NULL,
room_type VARCHAR(100) NULL,
room_floor INT NULL
);

DESCRIBE booking;

DESCRIBE booking;

ALTER TABLE booking
	MODIFY customer_lastname VARCHAR(150) NOT NULL;
    
ALTER TABLE booking
	ADD COLUMN discount FLOAT NULL,
    DROP COLUMN room_floor;
    
/*Updates*/
/*- Sur la résa 2 (id = 2) changer le numéro
de la chambre 38*/

UPDATE booking
SET room_number = 38
WHERE id = 2
;

SELECT * FROM booking;

/*- Sur la résa 10 : changerle nom du 
client par Robert Test*/

UPDATE booking
SET customer_lastname = 'Test', customer_firstname = "Robert"
WHERE id = 10
;

/*- toutes les résas des chambres
30 à 39 ont le droit à une remise
de 12.50*/

UPDATE booking
SET discount = 12.5
WHERE room_number >= 30 AND room_number <= 39
/*WHERE room_number BETWEEN 30 AND 39*/
;


/*- Toutes les résas doivent 
passer en type "Double"*/
UPDATE booking
SET room_type = 'Double'
;


/*Deletes*/
/*- Supprimer la résa id 35*/
DELETE FROM booking
WHERE id = 35;

SELECT * FROM booking;


/*- Supprimer Toutes les résa 
de la chambre 38*/

DELETE FROM booking
WHERE room_number = 38;


TRUNCATE TABLE booking;


/*-> Le nom, prénom et email des clients dont le prénom est "Julien"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_firstname = 'Julien'
;

/*-> Le nom, prénom et email des clients dont 
l'email termine par "@gmail.com"*/
SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_email LIKE '%@gmail.com'
;

/*-> toutes les commandes  non payées*/
SELECT * 
FROM full_order
WHERE is_paid = false;

/*-> toutes les commandes  payées mais non livré*/
SELECT * 
FROM full_order
WHERE is_paid = true
AND shipment_date IS null
;

/*-> toutes les commandes  livré hors de France*/
SELECT * 
FROM full_order
WHERE shipment_country <> 'France'
;


/*-> toutes les commandes au montant de plus 8000€ ordonnées 
du plus grand au plus petit*/
SELECT * 
FROM full_order
WHERE amount > 8000
ORDER BY amount DESC;


SELECT COUNT(id) AS nbOrder, MAX(date), MIN(date), SUM(amount)
FROM full_order
WHERE amount > 8000;


/*-> La commande au montant le plus élevé (une seule)*/
SELECT * 
FROM full_order
ORDER BY amount DESC
LIMIT 1
;

/*-> toutes les commandes réglé en Cash en 2022 livré en France dont 
le montant est inférieur à 5000 €**/
SELECT *
FROM full_order
WHERE payment_type = 'Cash'
AND YEAR(date) = 2022
AND shipment_country = 'France'
AND amount < 5000
;



/*-> toutes les commandes payés par carte ou payé aprés le 15/10/2021*/
SELECT *
FROM full_order
WHERE payment_type = 'Credit Card'
OR payment_date > '2021-01-15'
;



/*-> les 3 dernières commandes envoyées en France*/

SELECT * 
FROM full_order
WHERE shipment_country = 'France'
ORDER BY date DESC
LIMIT 3
;

/*-> les 10 commandes les plus élevés passé sur l'année 2021*/
SELECT * 
FROM full_order
WHERE YEAR(date) = 2021
ORDER BY amount DESC
LIMIT 10;

/*-> la somme des commandes non payés*/
SELECT ROUND(SUM(amount), 2) AS totalUnpaidOrders
FROM full_order
WHERE is_paid = false
; 

/*-> la moyenne des montants des commandes payés en cash*/
SELECT ROUND(AVG(amount), 2) AS averageCash
FROM full_order
WHERE payment_type = 'Cash'
;

/*-> le nombre de client dont le nom est "Laporte"*/
SELECT COUNT(*)
FROM full_order
WHERE customer_lastname = "Laporte";

/*-> Le nombre de jour Maximum entre la date de payment et la date de livraison -> DATEDIFF()*/

SELECT MAX(DATEDIFF(payment_date, shipment_date)) AS MaxDelay
FROM full_order
WHERE payment_date is not null
AND shipment_date is not null
;

/*-> Le délai moyen (en jour) de réglement d'une commande*/
SELECT ROUND(AVG(DATEDIFF(payment_date, date))) AS AvgDelayPayment
FROM full_order
WHERE is_paid = true
;

/*-> le nombre de commande payés en chèque sur 2021*/
SELECT COUNT(*) AS NbCheckIn2021
FROM full_order
WHERE payment_type = 'Check'
AND YEAR (payment_date) = 2021
;

/*-> Le montant total des commandes par type de paiement*/
SELECT payment_type, ROUND(SUM(amount), 2) AS totalAmount
FROM full_order
WHERE  payment_type IS NOT null
GROUP BY payment_type
;

/*-> La moyenne des montants des commandes par Pays*/
SELECT shipment_country, ROUND(AVG(amount), 2) AS averageAmount
FROM full_order
WHERE shipment_country IS NOT null
GROUP BY shipment_country
ORDER BY shipment_country
;

/*-> Par année la somme des commandes*/

SELECT 
	YEAR(date) AS orderYear, 
    ROUND(SUM(amount), 2) AS totalAmount
FROM full_order
GROUP BY orderYear
ORDER BY orderYear
;

/*-> Liste des clients (nom, prénom) qui ont au moins deux commandes*/
SELECT customer_lastname, customer_firstname, COUNT(*) AS nbOrders
FROM full_order
GROUP BY customer_lastname, customer_firstname
	HAVING nbOrders >= 2
ORDER BY customer_lastname, customer_firstname
;



/*-> Liste des clients (nom, prénom) avec le montant de leurs commandes
les plus élevés en 2021 (TOP 3)*/

SELECT customer_lastname, customer_firstname, SUM(amount) AS totalOrdered
FROM full_order
WHERE YEAR(date) = 2021
GROUP BY customer_lastname, customer_firstname
ORDER BY totalOrdered DESC
LIMIT 3
;


/*-> tous les produits avec leur nom et le label de leur catégorie*/
SELECT pr.name, ca.label
FROM product pr
	JOIN category ca ON pr.category_id = ca.id
;

/*-> Pour chaque client (nom, prénom) remonter le nombre de facture 
associé*/
SELECT cu.firstname, cu.lastname, COUNT(bi.id) AS nbBills
FROM customer cu 
	JOIN bill bi ON bi.customer_id = cu.id
GROUP BY cu.id
ORDER BY cu.id
;

/*-> Pour chaque catégorie la moyenne des prix de produits associés*/
SELECT ca.label, ROUND(AVG(pr.unit_price), 2) AS AveragePrice
FROM category ca
	JOIN product pr ON pr.category_id = ca.id
GROUP BY ca.id
;


/*-> Pour Chaque produit la quantité commandée depuis le 01/01/2021*/

SELECT pr.id, pr.name, SUM(li.quantity) AS QtyOrdered
FROM product pr
	JOIN line_item li ON li.product_id = pr.id
	JOIN bill bi ON li.bill_id = bi.id
WHERE YEAR(bi.date) = 2021
GROUP BY pr.id
;


/*Révisions du mercredi*/

/*
Table Payment:
  - date de paiement
  - montant du paiement
  - mode de paiement
  
  On doit pouvoir payer sa chambre en plusieurs fois.
  Un paiement ne concerne qu'une seule réservation.
  
*/

CREATE TABLE payment (
	id INT AUTO_INCREMENT PRIMARY KEY,
    payment_date DATETIME NOT NULL,
    amount FLOAT NOT NULL,
    payment_mean VARCHAR(50) NOT NULL, 
    booking_id INT NOT NULL
);


SELECT * FROM booking;
SELECT * FROM payment;

SELECT customer_firstname, customer_lastname, start
FROM booking
WHERE YEAR(start) = 2023
ORDER BY customer_lastname, customer_firstname
;

SELECT  AVG(DATEDIFF(start, end)) AS AverageStayDuration
FROM booking
;

SELECT room_number, COUNT(*) AS nbBookings
FROM booking
GROUP BY room_number
ORDER BY nbBookings DESC
LIMIT 5
;

SELECT bo.id, bo.start,  COUNT(pa.id) AS nbPayments
FROM booking bo  
	LEFT JOIN payment pa ON bo.id = pa.booking_id
GROUP BY bo.id
	HAVING nbPayments = 0
ORDER BY bo.id
;

DELETE FROM booking WHERE id = 66;
SELECT * FROM payment;
SELECT * FROM booking;


ALTER TABLE payment
	ADD CONSTRAINT  FK_payment_booking
    FOREIGN KEY payment(booking_id)
    REFERENCES booking(id)
;





/*-> La liste des Facture (ref) qui ont plus de 2 produits différends 
commandé*/
SELECT bi.ref, COUNT(li.product_id) AS nbProduct
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
GROUP BY bi.id
	HAVING nbProduct > 2
;

/*-> Pour chaque Facture afficher le montant total*/

SELECT bi.id, bi.ref, bi.date, SUM(li.quantity * pr.unit_price) AS totalAmount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
ORDER BY bi.id
;


/*-> Pour chaque client compter le nombre de produit différents 
qu'il a commandé*/
SELECT cu.id, cu.lastname, cu.firstname, COUNT(li.product_id) AS nbProductOrdered
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
GROUP BY cu.id
ORDER BY cu.id
;

/*-> Pour chaque produit compter le nombre de client différents 
qu'ils l'ont commandé*/
SELECT pr.id, pr.name, COUNT(bi.customer_id) AS nbCustomer
FROM product pr
	JOIN line_item li ON li.product_id = pr.id
    JOIN bill bi ON li.bill_id = bi.id
GROUP BY pr.id
ORDER BY pr.id
;


/*-> pour chaque catégorie de produit la somme des facture payées*/

SELECT ca.label, SUM(pr.unit_price * li.quantity) AS totalAmount
FROM category ca 
	JOIN product pr ON pr.category_id = ca.id
    JOIN line_item li ON li.product_id = pr.id
    JOIN bill bi ON li.bill_id = bi.id
WHERE bi.is_paid = true
GROUP BY ca.id
ORDER BY ca.label
;

/*-> par Année de Facture la moyenne d'age des clients*/

SELECT 
		YEAR(bi.date) AS billYear, 
		AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, NOW())) AS AverageAge
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
GROUP BY billYear
ORDER BY billYear
;
	

/*-> les nom, prénom et num de tel des clients qui ont commandes 
des produit de 
camping ces deux dernières années*/

EXPLAIN SELECT cu.firstname, cu.lastname, cu.phone_number
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
WHERE YEAR(bi.date) > 2022
AND ca.id IN (
	SELECT id FROM category
    WHERE label LIKE 'C%'
)
GROUP BY cu.id
ORDER BY cu.id
;

/*-> La moyenne d'age des consomateurs pour chaque catégorie de 
produit*/

SELECT ca.label, AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, NOW())) AS AverageAge
FROM customer cu
	JOIN bill bi ON bi.customer_id = cu.id
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
GROUP BY ca.id
;



/*-> la liste des produits, avec le nom de leur catégorie, 
commandés plus de 10 fois (en nombre d'unité) en 2022*/

SELECT pr.id, pr.name, ca.label, SUM(li.quantity) AS nbUnitOrdered
FROM bill bi
    JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
    JOIN category ca ON pr.category_id = ca.id
WHERE YEAR(bi.date) = 2022
GROUP BY pr.id
	HAVING nbUnitOrdered > 10
ORDER BY pr.id
;


CREATE TABLE customer (
	id INT PRIMARY KEY AUTO_INCREMENT,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    phoneNumber VARCHAR(20) NULL,
    email VARCHAR(255) NOT NULL
);

ALTER TABLE booking
	ADD COLUMN customer_id INT NOT NULL;
    
CREATE TABLE room (
	id INT PRIMARY KEY AUTO_INCREMENT,
    number INT NOT NULL,
    type VARCHAR(50) NOT NULL
);

ALTER TABLE booking
	ADD COLUMN room_id INT NOT NULL;
    

ALTER TABLE booking
	ADD CONSTRAINT FK_booking_customer
    FOREIGN KEY booking(customer_id)
    REFERENCES customer(id)
;

ALTER TABLE booking
	ADD CONSTRAINT FK_booking_room
    FOREIGN KEY booking(room_id)
    REFERENCES room(id)
;

TRUNCATE TABLE payment;
DELETE FROM booking;




SELECT * FROM product;
SELECT * FROM category;

SELECT pr.*, ca.label
FROM product pr
	JOIN category ca ON pr.category_id = ca.id
;

CREATE VIEW products_with_category_label AS
SELECT pr.*, ca.label
FROM product pr
	JOIN category ca ON pr.category_id = ca.id
;

SELECT * FROM products_with_category_label;


CREATE VIEW bills_with_amount AS
SELECT bi.*, SUM(li.quantity * pr.unit_price) AS totalAmount
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
    JOIN product pr ON li.product_id = pr.id
GROUP BY bi.id
ORDER BY bi.id
;

SELECT * FROM bills_with_amount;


/* -> le nom, prénom et somme des factures des 3 clients qui ont passé 
le plus grand nombre de facture*/

SELECT cu.lastname, cu.firstname, SUM(bwa.totalAmount) AS cumulAmount, COUNT(*) AS nbBills
FROM customer cu
	JOIN bills_with_amount bwa ON cu.id = bwa.customer_id
GROUP BY cu.id
ORDER BY nbBills DESC
LIMIT 3
;

/*-> le nom, prénom et (somme des factures) des 3 clients qui ont 
passé les factures les plus chers*/

SELECT cu.lastname, cu.firstname, SUM(bwa.totalAmount) AS cumulAmount, MAX(bwa.totalAmount) AS maxAmount
FROM customer cu
	JOIN bills_with_amount bwa ON cu.id = bwa.customer_id
GROUP BY cu.id
ORDER BY maxAmount DESC
LIMIT 3
;


/*-> le nom, prénom et somme des factures des 3 clients qui 
ont  le total des factures les plus élevés*/

SELECT cu.lastname, cu.firstname, SUM(bwa.totalAmount) AS cumulAmount
FROM customer cu
	JOIN bills_with_amount bwa ON cu.id = bwa.customer_id
GROUP BY cu.id
ORDER BY cumulAmount DESC
LIMIT 3
;

SELECT * FROM product;

DROP PROCEDURE updateStockProduct;

DELIMITER //
CREATE PROCEDURE updateStockProduct(newStock int)
BEGIN

	UPDATE product
	SET quantity_available = newStock;
    
END//

CALL updateStockProduct(300);

/*Requêtes de Structures*/

/*Base de données*/

CREATE DATABASE nomBDD;

DROP DATABASE nomBDD;

/* TABLE */

CREATE TABLE nom_table (
	id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE
);

ALTER TABLE nom_table
	MODIFY 
    ADD COLUMN
    DROP COLUMN
    ADD CONSTRAINT FK_table1_table2
		FOREIGN KEY table1(col)
        REFERENCES table2(col);
        
DROP TABLE nom_table

/* Vues */

	CREATE VIEW view_name AS
    SELECT ...
    
    ALTER VIEW view_name AS
    SELEC ...
    
    DROP VIEW view_name;

/* Procédure Stockée*/

DELIMITER //
CREATE PROCEDURE nomProcedure(param VARCHAR)
BEGIN

	...

END//

CALL nomProcedure();

DROP PROCEDURE nomProcedure;



/*Requêtes de Manipulation de données*/

/*Create*/

	INSERT INTO nom_table (col1, col2, ...)
    VALUES (val1, val2, ...), (val1, val2, ...);
    
    INSERT INTO nom_table (col1, col2, ...)
    SELECT col1, col2, ... ;

/*Update*/

	UPDATE nom_table
    SET col = val, col2 = val2
    WHERE id = 8;

/*Delete*/

	DELETE FROM nom_table
    WHERE id = 25;
    
    TRUNCATE TABLE nom_table;
	
/*Read*/

SELECT col1, col2, ... / *
FROM nom_table
	JOIN table2 ON nom_table.table2_id = table2.id
WHERE conditions (=, >, <, ...)
	AND / OR
GROUP BY col, col2
	HAVING COUNT(*) > 28
ORDER BY col, col2 ASC/DESC
LIMIT 10
;












ALTER TABLE customer
	ADD COLUMN is_vip BOOL NOT NULL DEFAULT false;
    
SELECT * FROM customer;

DROP PROCEDURE updateVip;
DELIMITER //
CREATE PROCEDURE updateVIP(vipLimit float)
BEGIN

	UPDATE customer
    SET is_vip = false;

	UPDATE customer
	SET is_vip = true
	WHERE id IN (
		SELECT customer_id
		FROM bills_with_amount
		GROUP BY customer_id
			HAVING SUM(totalAmount) > vipLimit
	);

END//
    
CALL updateVIP(20000);


SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE 'C:\\formations\\SQL\\netflix.csv'
INTO TABLE import_netflix
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;


SELECT * FROM import_netflix;

INSERT INTO director (lastname, firstname)
VALUES ('Temporaire', 'Réalisateur');

SELECT * FROM director;


DROP PROCEDURE import_data_netflix;
DELIMITER //
CREATE PROCEDURE import_data_netflix(movieLimit int)
BEGIN

	/*Gestion des erreurs en transaction*/
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
                ROLLBACK;
			SELECT ('Une erreur est survenu durant l\'execution de la procédure.') AS Erreur;
    END;


	START TRANSACTION;
	
	DELETE FROM movie;
    DELETE FROM director;
    
    INSERT INTO director (lastname, firstname)
    SELECT 
		SUBSTRING_INDEX(director, ' ', -1) AS lastname,
		SUBSTRING_INDEX(director, ' ', 1) AS firstname
    FROM import_netflix
	WHERE type = 'Movie'
    AND director <> ''
	AND release_year REGEXP '^[0-9]+$' = 1
	AND replace(duration, ' min', '') REGEXP '^[0-9]+$' = 1
    GROUP BY director
    ;
    

	INSERT INTO movie (title, country, description, release_year, duration, rating, director_id)
	SELECT title, 
			country, 
			description, 
			release_year, 
			replace(duration, ' min', ''), 
			rating,
			di.id
	FROM import_netflix ix
		JOIN director di ON ix.director = CONCAT(di.firstname, ' ', di.lastname)
	WHERE type = 'Movie'
    AND director <> ''
	AND release_year REGEXP '^[0-9]+$' = 1
	AND replace(duration, ' min', '') REGEXP '^[0-9]+$' = 1
	;
    
    SET @count = (SELECT COUNT(*) FROM movie);
    IF @count >= movieLimit
		THEN 
			COMMIT;
		ELSE 
			ROLLBACK;
    END IF;
    
END//


DELETE FROM movie;
DELETE FROM director;

SELECT * FROM movie;
SELECT * FROM director;

SELECT * 
FROM movie mv 
	JOIN director di ON mv.director_id = di.id
    ;


CALL import_data_netflix(4000);


SELECT *, 
	CASE WHEN is_paid = 1 THEN 'Payé' ELSE 'Non payé' END AS status
FROM bill;

SELECT * FROM user;
SELECT * FROM movie;
SELECT * FROM viewing;

DROP PROCEDURE generate_viewings;
DELIMITER //
CREATE PROCEDURE generate_viewings(nbViewing INT)
BEGIN

	DELETE FROM viewing;
    
	SET @i = 0;
    
    REPEAT
		SET @random_user_id = (SELECT id FROM user ORDER BY RAND() LIMIT 1);
		SET @random_movie_id = (SELECT id FROM movie ORDER BY RAND() LIMIT 1);
		
		INSERT INTO viewing (date, user_id, movie_id)
		VALUES(NOW(), @random_user_id, @random_movie_id);
        
        SET @i = @i + 1;
    
    UNTIL @i >= nbViewing 
    END REPEAT;
	
END//

CALL generate_viewings(500);

SELECT * FROM import_netflix;
SELECT * FROM actor;

DELIMITER //
CREATE PROCEDURE insert_new_actor(actor text)
BEGIN

	SET @lastname = SUBSTRING_INDEX(actor, ' ', -1) ;
	SET @firstname = SUBSTRING_INDEX(actor, ' ', 1) ;

	IF (SELECT COUNT(*) 
		FROM actor 
        WHERE lastname = @lastname
        AND firstname = @firstname) = 0
    THEN
		INSERT INTO actor (lastname, firstname)
		VALUES (@lastname, @firstname);
    END IF;

END //

CALL insert_new_actor('Tom Hanks');

DROP PROCEDURE parse_actors;
DELIMITER //
CREATE PROCEDURE parse_actors(actors text)
BEGIN

    REPEAT
		SET @actor = TRIM(SUBSTRING_INDEX(actors, ',', 1));
		CALL insert_new_actor(@actor);
		
		SET actors = REPLACE(actors, CONCAT(@actor, ','), '');
		
		UNTIL TRIM(actors) = TRIM(@actor)
    END REPEAT;
	
END //

CALL parse_actors('Ama Qamata, Khosi Ngema, Gail Mabalane, Thabang Molaba, Dillon Windvogel, Natasha Thahane, Arno Greeff, Xolile Tshabalala, Getmore Sithole, Cindy Mahlangu, Ryle De Morny, Greteli Fincham, Sello Maake Ka-Ncube, Odwa Gwanya, Mekaila Mathys, Sandi Schultz, Duane Williams, Shamilla Miller, Patrick Mofokeng');


SELECT * FROM actor;
DELETE FROM actor;

DROP PROCEDURE import_actors;
DELIMITER //
CREATE PROCEDURE import_actors()
BEGIN

	DECLARE done BOOL DEFAULT false;
    DECLARE cast_actors TEXT;
	DECLARE cur CURSOR FOR SELECT cast FROM import_netflix WHERE type = 'Movie' AND cast <> '';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
		REPEAT 
			FETCH cur INTO cast_actors;
			CALL parse_actors(cast_actors);
        
        UNTIL done = TRUE
        END REPEAT;
    
    CLOSE cur;

END//

SELECT * FROM actor;
DELETE FROM actor;

SELECT * FROM actor_movie;

CALL import_actors();



SELECT * 
FROM actor ac
	JOIN actor_movie am ON ac.id = am.actor_id
    JOIN movie mo ON mo.id = am.movie_id
WHERE ac.id = 170211
;


DROP PROCEDURE associate_actors;
DELIMITER //
CREATE PROCEDURE associate_actors()
BEGIN

	DECLARE done BOOL DEFAULT false;
    DECLARE actor_id INT;
    DECLARE actor_name TEXT;
	DECLARE cur CURSOR FOR SELECT id, CONCAT(firstname, ' ', lastname) FROM actor;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    
    OPEN cur;
		REPEAT
        
			FETCH cur INTO actor_id, actor_name;
            
            INSERT INTO actor_movie (movie_id, actor_id)
			SELECT mo.id, actor_id
			FROM import_netflix ix
				JOIN movie mo ON mo.title = ix.title
			WHERE ix.cast LIKE CONCAT('%', actor_name, '%')
			;
        
        UNTIL done = TRUE
        END REPEAT;
    CLOSE cur;
END//


CALL associate_actors();