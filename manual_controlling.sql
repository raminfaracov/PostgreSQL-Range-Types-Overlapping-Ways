/*
In this example, we create a PostgreSQL function for inserting data to a table.
And we write some SQL codes for manual controlling integer fields "d_number_from" and "d_number_to"
*/

-- create sample table
CREATE TABLE test.document_number (
	id serial,
	d_serial varchar(10) NOT NULL,
	d_number_from integer NOT NULL,
	d_number_to integer NOT NULL,
	insert_date timestamp NOT NULL,
	CONSTRAINT document_number_pkey PRIMARY KEY (id)
);


-- create function for inserting to table and write SQL code for control overlapping fields d_number_from & d_number_to
create or replace function examples.insert_document_number(p_serial varchar, p_number_from integer, p_number_to integer)
RETURNS void 
LANGUAGE plpgsql
AS $function$
DECLARE
  v_ret int8; 
begin

	/****************** for manual controlling *********************/ 
	if (p_number_to < p_number_from) then 
		RAISE EXCEPTION 'ERROR: value of the field "p_number_to" must be greater than "p_number_from"';
		return;
	end if; 
	
	if (exists(
				select id from examples.document_number
				where 
					d_serial = p_serial and 
						((p_number_from >= d_number_from and p_number_from <= d_number_to) or 
						(p_number_to >= d_number_from and p_number_to <= d_number_to))
	)) then 
		RAISE EXCEPTION 'ERROR: Conflict "d_number_from" and "d_number_to" field values with existing data.';
		return;
	end if; 
	/****************** end *********************/ 
	
	-- insert function params to table 
	insert into examples.document_number 
	(
		d_serial, 
		d_number_from, 
		d_number_to, 
		insert_date 
	) values 
	(
		p_serial, 
		p_number_from, 
		p_number_to, 
		now()
	);

END;
$function$
;


-- call function for inserting some data to table for testing our control mechanism
select * from examples.insert_document_number('AC', 1, 100);
-- Result: OK

select * from examples.insert_document_number('AC', 101, 300);
-- Result: OK

select * from examples.insert_document_number('AC', 1000, 500);
-- ERROR: value of the field "p_number_to" must be greater than "p_number_from"

select * from examples.insert_document_number('AC', 201, 400);
-- ERROR: Conflict "d_number_from" and "d_number_to" field values with existing data.