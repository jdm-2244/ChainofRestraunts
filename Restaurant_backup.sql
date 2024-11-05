--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4 (Homebrew)

-- Started on 2024-11-04 21:38:01 CST

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
-- TOC entry 218 (class 1259 OID 16534)
-- Name: Address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Address" (
    id bigint NOT NULL,
    address character varying NOT NULL,
    zip character varying NOT NULL
);


ALTER TABLE public."Address" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16526)
-- Name: Customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Customer" (
    username character varying NOT NULL,
    email character varying NOT NULL,
    phone_number character varying NOT NULL,
    member boolean NOT NULL,
    user_id bigint NOT NULL,
    "First_name" character varying NOT NULL,
    "Last_name" character varying NOT NULL,
    CONSTRAINT check_phone_number CHECK (((phone_number)::text ~ '^[0-9]{10}$'::text))
);


ALTER TABLE public."Customer" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16521)
-- Name: Franchise; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Franchise" (
    id bigint NOT NULL,
    "City" character varying NOT NULL,
    "State" character varying NOT NULL,
    "Address_id" bigint NOT NULL
);


ALTER TABLE public."Franchise" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16544)
-- Name: Menu_Items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Menu_Items" (
    menu_id bigint NOT NULL,
    menu_item_id bigint NOT NULL
);


ALTER TABLE public."Menu_Items" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16567)
-- Name: Order_Summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Order_Summary" (
    overall_order_id bigint NOT NULL,
    order_id bigint NOT NULL
);


ALTER TABLE public."Order_Summary" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16559)
-- Name: Orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Orders" (
    id bigint NOT NULL,
    "Menu_items_id" bigint NOT NULL,
    "Franchise_id" bigint NOT NULL
);


ALTER TABLE public."Orders" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16531)
-- Name: Payment_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Payment_cards" (
    id bigint,
    card_num "char",
    user_id bigint,
    date_exp "char"
);


ALTER TABLE public."Payment_cards" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16549)
-- Name: Payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Payments" (
    payment_id bigint NOT NULL,
    card_id "char" NOT NULL,
    amount bigint NOT NULL,
    cust_id bigint NOT NULL,
    CONSTRAINT check_positive_amount CHECK ((amount > 0))
);


ALTER TABLE public."Payments" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16674)
-- Name: Pricing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Pricing" (
    id integer NOT NULL,
    menu_item_id bigint,
    price bigint
);


ALTER TABLE public."Pricing" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16673)
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
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 226
-- Name: Pricing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Pricing_id_seq" OWNED BY public."Pricing".id;


--
-- TOC entry 219 (class 1259 OID 16539)
-- Name: Special_Menu_Items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Special_Menu_Items" (
    id bigint NOT NULL,
    entree character varying,
    side_1 character varying,
    side_2 character varying
);


ALTER TABLE public."Special_Menu_Items" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16554)
-- Name: Transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Transactions" (
    transaction_id bigint NOT NULL,
    "Payment_id" bigint,
    "Cash" boolean NOT NULL,
    "Amount" bigint NOT NULL,
    "Order_id" bigint NOT NULL,
    cust_id bigint NOT NULL
);


ALTER TABLE public."Transactions" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16562)
-- Name: menu_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_item (
    menu_item_id bigint NOT NULL,
    item_name character varying NOT NULL,
    type_of_menu_item character varying NOT NULL,
    price bigint[]
);


ALTER TABLE public.menu_item OWNER TO postgres;

--
-- TOC entry 3487 (class 2604 OID 16677)
-- Name: Pricing id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pricing" ALTER COLUMN id SET DEFAULT nextval('public."Pricing_id_seq"'::regclass);


--
-- TOC entry 3679 (class 0 OID 16534)
-- Dependencies: 218
-- Data for Name: Address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Address" (id, address, zip) FROM stdin;
\.


--
-- TOC entry 3677 (class 0 OID 16526)
-- Dependencies: 216
-- Data for Name: Customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Customer" (username, email, phone_number, member, user_id, "First_name", "Last_name") FROM stdin;
\.


--
-- TOC entry 3676 (class 0 OID 16521)
-- Dependencies: 215
-- Data for Name: Franchise; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Franchise" (id, "City", "State", "Address_id") FROM stdin;
\.


--
-- TOC entry 3681 (class 0 OID 16544)
-- Dependencies: 220
-- Data for Name: Menu_Items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Menu_Items" (menu_id, menu_item_id) FROM stdin;
\.


--
-- TOC entry 3686 (class 0 OID 16567)
-- Dependencies: 225
-- Data for Name: Order_Summary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Order_Summary" (overall_order_id, order_id) FROM stdin;
\.


--
-- TOC entry 3684 (class 0 OID 16559)
-- Dependencies: 223
-- Data for Name: Orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Orders" (id, "Menu_items_id", "Franchise_id") FROM stdin;
\.


--
-- TOC entry 3678 (class 0 OID 16531)
-- Dependencies: 217
-- Data for Name: Payment_cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Payment_cards" (id, card_num, user_id, date_exp) FROM stdin;
\.


--
-- TOC entry 3682 (class 0 OID 16549)
-- Dependencies: 221
-- Data for Name: Payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Payments" (payment_id, card_id, amount, cust_id) FROM stdin;
\.


--
-- TOC entry 3688 (class 0 OID 16674)
-- Dependencies: 227
-- Data for Name: Pricing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Pricing" (id, menu_item_id, price) FROM stdin;
\.


--
-- TOC entry 3680 (class 0 OID 16539)
-- Dependencies: 219
-- Data for Name: Special_Menu_Items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Special_Menu_Items" (id, entree, side_1, side_2) FROM stdin;
\.


--
-- TOC entry 3683 (class 0 OID 16554)
-- Dependencies: 222
-- Data for Name: Transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Transactions" (transaction_id, "Payment_id", "Cash", "Amount", "Order_id", cust_id) FROM stdin;
\.


--
-- TOC entry 3685 (class 0 OID 16562)
-- Dependencies: 224
-- Data for Name: menu_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_item (menu_item_id, item_name, type_of_menu_item, price) FROM stdin;
\.


--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 226
-- Name: Pricing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Pricing_id_seq"', 1, false);


--
-- TOC entry 3493 (class 2606 OID 16530)
-- Name: Customer Customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT "Customer_pkey" PRIMARY KEY (user_id);


--
-- TOC entry 3491 (class 2606 OID 16525)
-- Name: Franchise Franchise_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Franchise"
    ADD CONSTRAINT "Franchise_pkey" PRIMARY KEY (id);


--
-- TOC entry 3500 (class 2606 OID 16543)
-- Name: Special_Menu_Items Menu_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Special_Menu_Items"
    ADD CONSTRAINT "Menu_item_pkey" PRIMARY KEY (id);


--
-- TOC entry 3502 (class 2606 OID 16548)
-- Name: Menu_Items Menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Menu_Items"
    ADD CONSTRAINT "Menu_pkey" PRIMARY KEY (menu_id);


--
-- TOC entry 3510 (class 2606 OID 16590)
-- Name: Orders Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- TOC entry 3516 (class 2606 OID 16571)
-- Name: Order_Summary Overall_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order_Summary"
    ADD CONSTRAINT "Overall_order_pkey" PRIMARY KEY (overall_order_id);


--
-- TOC entry 3504 (class 2606 OID 16553)
-- Name: Payments Payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payments"
    ADD CONSTRAINT "Payments_pkey" PRIMARY KEY (payment_id);


--
-- TOC entry 3519 (class 2606 OID 16679)
-- Name: Pricing Pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pricing"
    ADD CONSTRAINT "Pricing_pkey" PRIMARY KEY (id);


--
-- TOC entry 3498 (class 2606 OID 16538)
-- Name: Address Street_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Address"
    ADD CONSTRAINT "Street_pkey" PRIMARY KEY (id);


--
-- TOC entry 3507 (class 2606 OID 16558)
-- Name: Transactions Transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transactions"
    ADD CONSTRAINT "Transactions_pkey" PRIMARY KEY (transaction_id);


--
-- TOC entry 3514 (class 2606 OID 16566)
-- Name: menu_item menu_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_item
    ADD CONSTRAINT menu_item_pkey PRIMARY KEY (menu_item_id);


--
-- TOC entry 3495 (class 2606 OID 16769)
-- Name: Customer unique_email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Customer"
    ADD CONSTRAINT unique_email UNIQUE (email);


--
-- TOC entry 3512 (class 1259 OID 16670)
-- Name: idx_menu_items_menu_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_menu_items_menu_item_id ON public.menu_item USING btree (menu_item_id);


--
-- TOC entry 3517 (class 1259 OID 16672)
-- Name: idx_order_summary_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_summary_order_id ON public."Order_Summary" USING btree (order_id);


--
-- TOC entry 3511 (class 1259 OID 16668)
-- Name: idx_orders_franchise_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_franchise_id ON public."Orders" USING btree ("Franchise_id");


--
-- TOC entry 3496 (class 1259 OID 16667)
-- Name: idx_payment_cards_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payment_cards_user_id ON public."Payment_cards" USING btree (user_id);


--
-- TOC entry 3505 (class 1259 OID 16669)
-- Name: idx_payments_cust_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_cust_id ON public."Payments" USING btree (cust_id);


--
-- TOC entry 3508 (class 1259 OID 16671)
-- Name: idx_transactions_order_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_transactions_order_id ON public."Transactions" USING btree ("Order_id");


--
-- TOC entry 3520 (class 2606 OID 16572)
-- Name: Franchise Address_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Franchise"
    ADD CONSTRAINT "Address_id" FOREIGN KEY ("Address_id") REFERENCES public."Address"(id);


--
-- TOC entry 3523 (class 2606 OID 16584)
-- Name: Payments Cust_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payments"
    ADD CONSTRAINT "Cust_id" FOREIGN KEY (cust_id) REFERENCES public."Customer"(user_id);


--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 3523
-- Name: CONSTRAINT "Cust_id" ON "Payments"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON CONSTRAINT "Cust_id" ON public."Payments" IS 'This is to connect customer to payments';


--
-- TOC entry 3524 (class 2606 OID 16596)
-- Name: Transactions Customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transactions"
    ADD CONSTRAINT "Customer_id" FOREIGN KEY (cust_id) REFERENCES public."Customer"(user_id);


--
-- TOC entry 3527 (class 2606 OID 16606)
-- Name: Orders Franchise; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Franchise" FOREIGN KEY ("Franchise_id") REFERENCES public."Franchise"(id);


--
-- TOC entry 3522 (class 2606 OID 16577)
-- Name: Menu_Items Menu_item_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Menu_Items"
    ADD CONSTRAINT "Menu_item_id" FOREIGN KEY (menu_item_id) REFERENCES public.menu_item(menu_item_id);


--
-- TOC entry 3528 (class 2606 OID 16601)
-- Name: Orders Menu_items_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT "Menu_items_id" FOREIGN KEY ("Menu_items_id") REFERENCES public.menu_item(menu_item_id) NOT VALID;


--
-- TOC entry 3525 (class 2606 OID 16591)
-- Name: Transactions Order_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transactions"
    ADD CONSTRAINT "Order_id" FOREIGN KEY ("Order_id") REFERENCES public."Orders"(id);


--
-- TOC entry 3532 (class 2606 OID 16680)
-- Name: Pricing Pricing_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Pricing"
    ADD CONSTRAINT "Pricing_menu_item_id_fkey" FOREIGN KEY (menu_item_id) REFERENCES public.menu_item(menu_item_id);


--
-- TOC entry 3530 (class 2606 OID 16758)
-- Name: menu_item fk_menu_items_menu_item_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_item
    ADD CONSTRAINT fk_menu_items_menu_item_id FOREIGN KEY (menu_item_id) REFERENCES public.menu_item(menu_item_id) ON DELETE CASCADE;


--
-- TOC entry 3529 (class 2606 OID 16753)
-- Name: Orders fk_orders_franchise_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Orders"
    ADD CONSTRAINT fk_orders_franchise_id FOREIGN KEY ("Franchise_id") REFERENCES public."Franchise"(id) ON DELETE CASCADE;


--
-- TOC entry 3521 (class 2606 OID 16748)
-- Name: Payment_cards fk_payment_cards_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Payment_cards"
    ADD CONSTRAINT fk_payment_cards_user_id FOREIGN KEY (user_id) REFERENCES public."Customer"(user_id) ON DELETE CASCADE;


--
-- TOC entry 3526 (class 2606 OID 16763)
-- Name: Transactions fk_transactions_order_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Transactions"
    ADD CONSTRAINT fk_transactions_order_id FOREIGN KEY ("Order_id") REFERENCES public."Orders"(id) ON DELETE CASCADE;


--
-- TOC entry 3531 (class 2606 OID 16611)
-- Name: Order_Summary order_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Order_Summary"
    ADD CONSTRAINT order_id FOREIGN KEY (order_id) REFERENCES public."Orders"(id);


-- Completed on 2024-11-04 21:38:04 CST

--
-- PostgreSQL database dump complete
--

