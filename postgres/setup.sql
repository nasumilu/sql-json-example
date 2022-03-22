-- Table: public.customer

DROP TABLE IF EXISTS public.customer CASCADE;

CREATE TABLE public.customer
(
    id serial NOT NULL,
    name character varying(128) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT customer_pkey PRIMARY KEY (id)
);
	
-- Table: public.customer_order

DROP TABLE IF EXISTS public.customer_order CASCADE;

CREATE TABLE public.customer_order
(
    id serial NOT NULL,
    order_date date NOT NULL,
    customer integer NOT NULL,
    items json,
    CONSTRAINT customer_order_pkey PRIMARY KEY (id),
    CONSTRAINT customer_order_customer_fk FOREIGN KEY (customer)
        REFERENCES public.customer (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

-- Add some data

-- Customer One has two orders
INSERT INTO public.customer (name) VALUES ('Customer One');
INSERT INTO public.customer_order (order_date, customer, items) VALUES ('2022-03-12'::date, currval(pg_get_serial_sequence('customer','id')),	'[{"id": 1, "name": "Item One", "amount": 4999}, {"id": 5, "name": "Item Two", "amount": 6249}]'::json);
INSERT INTO public.customer_order (order_date, customer, items) VALUES ('2022-03-01'::date, currval(pg_get_serial_sequence('customer','id')), '[{"id": 1, "name": "Item One", "amount": 4999}]'::json);

-- Customer Two has one order
INSERT INTO public.customer (name) VALUES ('Customer Two');
INSERT INTO public.customer_order (order_date, customer, items) VALUES ('2022-03-01'::date,	currval(pg_get_serial_sequence('customer','id')), '[{"id": 1, "name": "Item One", "amount": 4999}]'::json);

-- Customer Three has no orders
INSERT INTO public.customer (name) VALUES ('Customer Three');

