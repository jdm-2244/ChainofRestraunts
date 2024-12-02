--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: pricing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pricing (
    id integer NOT NULL,
    menu_item_id bigint,
    price numeric(10,2),
    CONSTRAINT check_price_positive CHECK ((price >= (0)::numeric))
);


ALTER TABLE public.pricing OWNER TO postgres;

--
-- Name: Pricing_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Pricing_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Pricing_id_seq" OWNER TO postgres;

--
-- Name: Pricing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Pricing_id_seq" OWNED BY public.pricing.id;


--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    address character varying(46) NOT NULL,
    zip character varying(6) NOT NULL
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: customer_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_user_id_seq OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    username character varying(16) NOT NULL,
    email character varying(32) NOT NULL,
    phone_number character varying(20) NOT NULL,
    member boolean NOT NULL,
    user_id bigint DEFAULT nextval('public.customer_user_id_seq'::regclass) NOT NULL,
    "First_name" character varying(12) NOT NULL,
    "Last_name" character varying(16) NOT NULL,
    CONSTRAINT check_email_format CHECK (((email)::text ~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'::text)),
    CONSTRAINT check_phone_number CHECK (((phone_number)::text ~ '^\+?[1-9]\d{1,19}$'::text))
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: franchise; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.franchise (
    id bigint NOT NULL,
    "City" character varying(45) NOT NULL,
    "State" character varying(16) NOT NULL,
    address character varying(46),
    zip character varying(6)
);


ALTER TABLE public.franchise OWNER TO postgres;

--
-- Name: menu_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_item (
    menu_item_id bigint NOT NULL,
    item_name character varying(15) NOT NULL,
    type_of_menu_item character varying(10) NOT NULL,
    quantity bigint,
    CONSTRAINT check_quantity_positive CHECK ((quantity >= 0))
);


ALTER TABLE public.menu_item OWNER TO postgres;

--
-- Name: menu_item_menu_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menu_item_menu_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_item_menu_item_id_seq OWNER TO postgres;

--
-- Name: menu_item_menu_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menu_item_menu_item_id_seq OWNED BY public.menu_item.menu_item_id;


--
-- Name: menu_item_relationships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_item_relationships (
    parent_item_id bigint NOT NULL,
    child_item_id bigint NOT NULL,
    relationship_type character varying(20)
);


ALTER TABLE public.menu_item_relationships OWNER TO postgres;

--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_items (
    menu_id bigint NOT NULL,
    menu_item_id bigint NOT NULL
);


ALTER TABLE public.menu_items OWNER TO postgres;

--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    menu_item_id integer NOT NULL,
    quantity integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer DEFAULT nextval('public.orders_id_seq'::regclass) NOT NULL,
    "Menu_items_id" bigint,
    "Franchise_id" bigint NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'pending'::character varying,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('processing'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text])))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: payment_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_cards (
    id bigint NOT NULL,
    card_num character varying(19),
    user_id bigint,
    date_exp character varying(4),
    bank character varying(10),
    CONSTRAINT check_card_num CHECK (((card_num)::text ~ '^\d{13,19}$'::text))
);


ALTER TABLE public.payment_cards OWNER TO postgres;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id bigint NOT NULL,
    card_id "char" NOT NULL,
    amount bigint NOT NULL,
    cust_id bigint NOT NULL,
    CONSTRAINT check_positive_amount CHECK ((amount > 0))
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_transaction_id_seq OWNER TO postgres;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_id bigint DEFAULT nextval('public.transactions_transaction_id_seq'::regclass) NOT NULL,
    payment_id bigint,
    cash boolean NOT NULL,
    amount bigint NOT NULL,
    order_id bigint NOT NULL,
    cust_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_transaction_amount_positive CHECK ((amount > 0))
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: menu_item menu_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_item ALTER COLUMN menu_item_id SET DEFAULT nextval('public.menu_item_menu_item_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: pricing id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing ALTER COLUMN id SET DEFAULT nextval('public."Pricing_id_seq"'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address (address, zip) FROM stdin;
456 Oak Avenue	75001
123 Main Street	60601
789 Pine Boulevard	94102
654 Elm Street	98101
321 Maple Road	33101
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (username, email, phone_number, member, user_id, "First_name", "Last_name") FROM stdin;
jsmith	john.smith@email.com	+12345678901	t	1	John	Smith
mjohnson	mary.johnson@email.com	+12345678902	f	2	Mary	Johnson
rwilson	robert.wilson@email.com	+12345678903	t	3	Robert	Wilson
sbrown	sarah.brown@email.com	+12345678904	f	4	Sarah	Brown
dtaylor	david.taylor@email.com	+12345678905	t	5	David	Taylor
janderson	jane.anderson@email.com	+12345678906	t	6	Jane	Anderson
mlee	michael.lee@email.com	+12345678907	f	7	Michael	Lee
agarcia	anna.garcia@email.com	+12345678908	t	8	Anna	Garcia
wmiller	william.miller@email.com	+12345678909	f	9	William	Miller
ldavis	lisa.davis@email.com	+12345678910	t	10	Lisa	Davis
testuser	test@example.com	+1234567890	f	11	John	Doe
ass1234	asddda@gmail.com	112233445566	f	20	my	ass
Scarface	killa987@gmail.com	8324731345	t	24	Tony	Montana
Maverick	maverick321@gmail.com	1233321221	f	25	Logan	Paul
Mj	Jackson5@gmail.com	976532421	f	28	Micheal	Jackson
test12	test12@gmail.com	11111111111111111	f	30	test1	2test
\.


--
-- Data for Name: franchise; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.franchise (id, "City", "State", address, zip) FROM stdin;
2	Dallas	Texas	456 Oak Avenue	75001
5	Seattle	Washington	654 Elm Street	98101
4	Miami	Florida	321 Maple Road	33101
1	Chicago	Illinois	123 Main Street	60601
3	San Francisco	California	789 Pine Boulevard	94102
\.


--
-- Data for Name: menu_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_item (menu_item_id, item_name, type_of_menu_item, quantity) FROM stdin;
1	Spring Rolls	Appetizer	100
2	Egg Rolls	Appetizer	100
3	Crab Rangoon	Appetizer	100
4	Wonton Soup	Appetizer	100
5	Hot&Sour Soup	Appetizer	100
6	Kung Pao	Main	50
7	Sweet&Sour	Main	50
8	Beef&Broccoli	Main	50
9	Chow Mein	Main	50
10	Mapo Tofu	Main	50
11	Fried Rice	Rice	100
12	Lo Mein	Noodles	100
13	White Rice	Rice	200
14	Dan Dan Noodle	Noodles	50
15	Chow Fun	Noodles	50
16	Boba Tea	Drink	100
17	Chinese Tea	Drink	200
18	Soda	Drink	200
19	Herbal Tea	Drink	100
20	Plum Juice	Drink	100
21	Moon Cake	Dessert	50
22	Egg Custard	Dessert	50
23	Sweet Bun	Dessert	50
24	Mango Pudding	Dessert	50
25	Fortune Cookie	Dessert	500
\.


--
-- Data for Name: menu_item_relationships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_item_relationships (parent_item_id, child_item_id, relationship_type) FROM stdin;
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_items (menu_id, menu_item_id) FROM stdin;
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, menu_item_id, quantity, created_at) FROM stdin;
16	16	1	1	2024-12-01 21:51:46.237976
17	16	24	1	2024-12-01 21:51:46.237976
18	16	20	1	2024-12-01 21:51:46.237976
19	17	17	1	2024-12-01 21:52:30.759734
20	17	18	1	2024-12-01 21:52:30.759734
21	17	16	1	2024-12-01 21:52:30.759734
22	17	25	1	2024-12-01 21:52:30.759734
23	18	8	1	2024-12-01 21:52:45.897937
24	18	9	1	2024-12-01 21:52:45.897937
25	19	21	1	2024-12-01 21:53:45.410763
26	19	25	1	2024-12-01 21:53:45.410763
27	19	22	1	2024-12-01 21:53:45.410763
28	20	11	1	2024-12-01 21:55:08.74313
29	20	6	1	2024-12-01 21:55:08.74313
30	20	18	1	2024-12-01 21:55:08.74313
31	21	6	1	2024-12-01 22:02:44.947645
32	21	12	1	2024-12-01 22:02:44.947645
33	22	16	1	2024-12-01 22:10:23.308392
34	22	24	1	2024-12-01 22:10:23.308392
35	23	19	1	2024-12-01 22:36:41.04712
36	23	17	1	2024-12-01 22:36:41.04712
37	23	16	1	2024-12-01 22:36:41.04712
38	24	17	1	2024-12-01 22:44:56.281938
39	24	23	1	2024-12-01 22:44:56.281938
40	24	21	1	2024-12-01 22:44:56.281938
41	25	4	1	2024-12-01 22:47:10.255182
42	26	22	1	2024-12-01 23:02:17.267078
43	26	5	1	2024-12-01 23:02:17.267078
44	26	2	1	2024-12-01 23:02:17.267078
45	27	2	1	2024-12-01 23:06:20.031675
46	27	3	1	2024-12-01 23:06:20.031675
47	27	14	1	2024-12-01 23:06:20.031675
48	27	11	1	2024-12-01 23:06:20.031675
49	27	12	1	2024-12-01 23:06:20.031675
50	27	15	1	2024-12-01 23:06:20.031675
51	27	10	1	2024-12-01 23:06:20.031675
52	28	10	1	2024-12-01 23:14:41.852485
53	28	6	1	2024-12-01 23:14:41.852485
54	28	9	1	2024-12-01 23:14:41.852485
55	28	8	1	2024-12-01 23:14:41.852485
56	28	14	1	2024-12-01 23:14:41.852485
57	28	12	1	2024-12-01 23:14:41.852485
58	28	11	1	2024-12-01 23:14:41.852485
59	28	19	1	2024-12-01 23:14:41.852485
60	28	17	1	2024-12-01 23:14:41.852485
61	28	3	1	2024-12-01 23:14:41.852485
62	28	2	1	2024-12-01 23:14:41.852485
63	28	5	1	2024-12-01 23:14:41.852485
64	28	1	1	2024-12-01 23:14:41.852485
65	28	4	1	2024-12-01 23:14:41.852485
66	28	22	1	2024-12-01 23:14:41.852485
67	29	3	1	2024-12-01 23:22:25.362623
68	29	2	1	2024-12-01 23:22:25.362623
69	29	5	1	2024-12-01 23:22:25.362623
70	29	1	1	2024-12-01 23:22:25.362623
71	29	4	1	2024-12-01 23:22:25.362623
72	29	22	1	2024-12-01 23:22:25.362623
73	29	25	1	2024-12-01 23:22:25.362623
74	29	24	1	2024-12-01 23:22:25.362623
75	29	21	1	2024-12-01 23:22:25.362623
76	29	23	1	2024-12-01 23:22:25.362623
77	29	16	1	2024-12-01 23:22:25.362623
78	29	17	1	2024-12-01 23:22:25.362623
79	29	19	1	2024-12-01 23:22:25.362623
80	29	20	1	2024-12-01 23:22:25.362623
81	29	18	1	2024-12-01 23:22:25.362623
82	29	8	1	2024-12-01 23:22:25.362623
83	29	9	1	2024-12-01 23:22:25.362623
84	29	6	1	2024-12-01 23:22:25.362623
85	29	10	1	2024-12-01 23:22:25.362623
86	29	7	1	2024-12-01 23:22:25.362623
87	29	15	1	2024-12-01 23:22:25.362623
88	29	14	1	2024-12-01 23:22:25.362623
89	29	12	1	2024-12-01 23:22:25.362623
90	29	11	1	2024-12-01 23:22:25.362623
91	29	13	1	2024-12-01 23:22:25.362623
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, "Menu_items_id", "Franchise_id", order_date, total_amount, created_at, status) FROM stdin;
1	1	1	2024-12-01 20:57:56.680292	15.00	2024-12-01 20:57:56.680292	pending
16	\N	1	2024-12-01 21:51:46.237976	15.00	2024-12-01 21:51:46.237976	pending
17	\N	1	2024-12-01 21:52:30.759734	12.00	2024-12-01 21:52:30.759734	pending
18	\N	1	2024-12-01 21:52:45.897937	29.00	2024-12-01 21:52:45.897937	pending
19	\N	1	2024-12-01 21:53:45.410763	12.00	2024-12-01 21:53:45.410763	pending
20	\N	1	2024-12-01 21:55:08.74313	30.00	2024-12-01 21:55:08.74313	pending
21	\N	1	2024-12-01 22:02:44.947645	28.00	2024-12-01 22:02:44.947645	pending
22	\N	1	2024-12-01 22:10:23.308392	10.00	2024-12-01 22:10:23.308392	pending
23	\N	1	2024-12-01 22:36:41.04712	12.00	2024-12-01 22:36:41.04712	pending
24	\N	1	2024-12-01 22:44:56.281938	13.00	2024-12-01 22:44:56.281938	pending
25	\N	1	2024-12-01 22:47:10.255182	5.00	2024-12-01 22:47:10.255182	pending
26	\N	1	2024-12-01 23:02:17.267078	15.00	2024-12-01 23:02:17.267078	pending
27	\N	1	2024-12-01 23:06:20.031675	79.00	2024-12-01 23:06:20.031675	pending
28	\N	1	2024-12-01 23:14:41.852485	137.00	2024-12-01 23:14:41.852485	pending
29	\N	1	2024-12-01 23:22:25.362623	196.00	2024-12-01 23:22:25.362623	pending
\.


--
-- Data for Name: payment_cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_cards (id, card_num, user_id, date_exp, bank) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, card_id, amount, cust_id) FROM stdin;
\.


--
-- Data for Name: pricing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pricing (id, menu_item_id, price) FROM stdin;
1	1	6.00
2	2	5.00
3	3	7.00
4	4	5.00
5	5	5.00
6	6	15.00
7	7	14.00
8	8	16.00
9	9	13.00
10	10	14.00
11	11	12.00
12	12	13.00
13	13	3.00
14	14	14.00
15	15	14.00
16	16	5.00
17	17	3.00
18	18	3.00
19	19	4.00
20	20	4.00
21	21	6.00
22	22	5.00
23	23	4.00
24	24	5.00
25	25	1.00
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (transaction_id, payment_id, cash, amount, order_id, cust_id, created_at) FROM stdin;
1	1	t	15	1	1	2024-12-01 21:50:31.792462
2	\N	t	15	16	6	2024-12-01 21:51:46.237976
3	\N	t	12	17	9	2024-12-01 21:52:30.759734
4	\N	t	29	18	3	2024-12-01 21:52:45.897937
5	\N	t	12	19	6	2024-12-01 21:53:45.410763
6	\N	t	30	20	4	2024-12-01 21:55:08.74313
7	\N	t	28	21	10	2024-12-01 22:02:44.947645
8	\N	t	10	22	5	2024-12-01 22:10:23.308392
9	\N	t	12	23	7	2024-12-01 22:36:41.04712
10	\N	t	13	24	3	2024-12-01 22:44:56.281938
11	\N	t	5	25	6	2024-12-01 22:47:10.255182
12	\N	t	15	26	11	2024-12-01 23:02:17.267078
13	\N	t	79	27	11	2024-12-01 23:06:20.031675
14	\N	t	137	28	20	2024-12-01 23:14:41.852485
15	\N	t	196	29	28	2024-12-01 23:22:25.362623
\.


--
-- Name: Pricing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Pricing_id_seq"', 1, false);


--
-- Name: customer_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_user_id_seq', 55, true);


--
-- Name: menu_item_menu_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menu_item_menu_item_id_seq', 25, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 91, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 29, true);


--
-- Name: transactions_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_transaction_id_seq', 15, true);


--
-- Name: customer Customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT "Customer_pkey" PRIMARY KEY (user_id);


--
-- Name: franchise Franchise_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.franchise
    ADD CONSTRAINT "Franchise_pkey" PRIMARY KEY (id);


--
-- Name: menu_items Menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT "Menu_pkey" PRIMARY KEY (menu_id);


--
-- Name: orders Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- Name: payment_cards Payment_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_cards
    ADD CONSTRAINT "Payment_cards_pkey" PRIMARY KEY (id);


--
-- Name: payments Payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT "Payments_pkey" PRIMARY KEY (payment_id);


--
-- Name: pricing Pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing
    ADD CONSTRAINT "Pricing_pkey" PRIMARY KEY (id);


--
-- Name: transactions Transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "Transactions_pkey" PRIMARY KEY (transaction_id);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address, zip);


--
-- Name: menu_item menu_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_item
    ADD CONSTRAINT menu_item_pkey PRIMARY KEY (menu_item_id);


--
-- Name: menu_item_relationships menu_item_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_item_relationships
    ADD CONSTRAINT menu_item_relationships_pkey PRIMARY KEY (parent_item_id, child_item_id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: customer unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- Name: idx_customer_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customer_email ON public.customer USING btree (email);


--
-- Name: idx_menu_item_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_menu_item_type ON public.menu_item USING btree (type_of_menu_item);


--
-- Name: idx_menu_items_menu_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_menu_items_menu_item_id ON public.menu_item USING btree (menu_item_id);


--
-- Name: idx_orders_franchise_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_franchise_id ON public.orders USING btree ("Franchise_id");


--
-- Name: idx_payment_cards_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payment_cards_user_id ON public.payment_cards USING btree (user_id);


--
-- Name: idx_payments_cust_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_cust_id ON public.payments USING btree (cust_id);


--
-- Name: idx_transactions_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_order_id ON public.transactions USING btree (order_id);


--
-- Name: payments Cust_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT "Cust_id" FOREIGN KEY (cust_id) REFERENCES public.customer(user_id);


--
-- Name: CONSTRAINT "Cust_id" ON payments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Cust_id" ON public.payments IS 'This is to connect customer to payments';


--
-- Name: transactions Customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "Customer_id" FOREIGN KEY (cust_id) REFERENCES public.customer(user_id);


--
-- Name: orders Franchise; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "Franchise" FOREIGN KEY ("Franchise_id") REFERENCES public.franchise(id);


--
-- Name: menu_items Menu_item_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT "Menu_item_id" FOREIGN KEY (menu_item_id) REFERENCES public.menu_item(menu_item_id);


--
-- Name: orders Menu_items_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "Menu_items_id" FOREIGN KEY ("Menu_items_id") REFERENCES public.menu_item(menu_item_id) NOT VALID;


--
-- Name: transactions Order_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT "Order_id" FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: pricing Pricing_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pricing
    ADD CONSTRAINT "Pricing_menu_item_id_fkey" FOREIGN KEY (menu_item_id) REFERENCES public.menu_item(menu_item_id);


--
-- Name: franchise fk_address; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.franchise
    ADD CONSTRAINT fk_address FOREIGN KEY (address, zip) REFERENCES public.address(address, zip);


--
-- Name: orders fk_orders_franchise_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_franchise_id FOREIGN KEY ("Franchise_id") REFERENCES public.franchise(id) ON DELETE CASCADE;


--
-- Name: payment_cards fk_payment_cards_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_cards
    ADD CONSTRAINT fk_payment_cards_user_id FOREIGN KEY (user_id) REFERENCES public.customer(user_id) ON DELETE CASCADE;


--
-- Name: transactions fk_transactions_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_customer FOREIGN KEY (cust_id) REFERENCES public.customer(user_id) ON DELETE CASCADE;


--
-- Name: transactions fk_transactions_order_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_order_id FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: menu_item_relationships menu_item_relationships_child_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_item_relationships
    ADD CONSTRAINT menu_item_relationships_child_item_id_fkey FOREIGN KEY (child_item_id) REFERENCES public.menu_item(menu_item_id);


--
-- Name: menu_item_relationships menu_item_relationships_parent_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_item_relationships
    ADD CONSTRAINT menu_item_relationships_parent_item_id_fkey FOREIGN KEY (parent_item_id) REFERENCES public.menu_item(menu_item_id);


--
-- Name: order_items order_items_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_item(menu_item_id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

