CREATE TABLE spec( 
	id integer,
	"имя таблицы" text,
	"имя столбца" text,
	"текущее максимальное значение" integer);
	
CREATE TABLE test
(
    id integer);

CREATE TABLE test2( 
	numValue1 integer,
	numValue2 integer);
	
INSERT INTO test VALUES (10);
	
INSERT INTO spec VALUES (1, 'spec', 'id', 1);

CREATE OR REPLACE  FUNCTION INC (Name_table text, Name_columnn text) 
RETURNS integer
AS $$
DECLARE
	i integer := 1;
BEGIN
	IF (EXISTS (select *
    	from spec
    	where "имя столбца" = Name_columnn AND "имя таблицы" = Name_table))
	THEN
		update spec
		set "текущее максимальное значение" = "текущее максимальное значение" + 1
		where "имя столбца" = Name_columnn AND "имя таблицы" = Name_table;
		i := "текущее максимальное значение" FROM spec where "имя столбца" = Name_columnn AND "имя таблицы" = Name_table;
		RETURN i;
	ELSE
	
		/*EXECUTE format('IF (EXISTS (SELECT max(%s) FROM %s ))', 
            Name_columnn, Name_table,'
		THEN
			i := SELECT max(%s) FROM %s ',Name_table, Name_columnn,';
		ELSE
			i := %s ',1,';
		END IF;');*/
		EXECUTE format('SELECT max(%s) FROM %s ', 
    	        Name_columnn, Name_table) INTO i;
		If i ISNULL THEN i :=1; ELSE i := i + 1; END IF;
		EXECUTE format('INSERT INTO spec
						VALUES (%s, ''%s'', ''%s'', %s)', 
					   (SELECT INC ('spec','id')), Name_table, Name_columnn, i);
	END IF;
  RETURN i;
END;
$$ LANGUAGE plpgsql;

SELECT INC ('spec','id');
SELECT INC ('spec','id');
SELECT INC ('test','id');
SELECT INC ('test','id');
SELECT INC ('test2', 'numValue1');
SELECT INC ('test2', 'numValue1');
INSERT INTO test2 VALUES (2, 13);
SELECT INC ('test2', 'numValue2');

