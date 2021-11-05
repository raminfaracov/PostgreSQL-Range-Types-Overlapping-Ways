/*
In this example, we use PostgreSQL range type and use PostgreSQL constraint which this constraint automatically controlled overlapping for any range type. We use integer range type. 
For automatically controlling by Database we must use PostgreSQL gist index type
*/


-- for using gist index type in PostgreSQL firstly must install this extension
create extension btree_gist;

-- create sample table which uses integer range type 
CREATE TABLE test.document_number (
	id serial,
	d_serial varchar(10) NOT NULL,
	d_number int4range NOT NULL,
	insert_date timestamp NOT NULL,
	CONSTRAINT document_number_pkey PRIMARY KEY (id),
	-- this constraint for control overlapping "serial" and "d_number" integer range type 
	CONSTRAINT document_number_range_unique EXCLUDE USING gist (d_serial WITH =, d_number WITH &&)
);
CREATE INDEX document_number_range_unique_idx ON test.document_number USING gist (d_serial, d_number);


-- insert into table sample data for testing 
insert into test.document_number (id, d_serial, d_number, insert_date)
values (1, 'AC', '[1, 100]', now());
-- Result = OK

insert into test.document_number (id, d_serial, d_number, insert_date)
values (2, 'AC', '[101, 300]', now());
-- Result = OK

insert into test.document_number (id, d_serial, d_number, insert_date)
values (3, 'AC', '[201, 400]', now());
/* 
Result = error ERROR: conflicting key value violates exclusion constraint "document_number_range_unique"
   Detail: Key (d_serial, d_number)=(AC, [201,401)) conflicts with existing key (d_serial, d_number)=(AC, [101,301)).  
*/

