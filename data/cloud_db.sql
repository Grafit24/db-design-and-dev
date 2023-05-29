--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

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
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    price_rub double precision DEFAULT 0 NOT NULL,
    workspaces_users_id integer NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: orders_servers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_servers (
    order_id integer NOT NULL,
    server_id integer NOT NULL
);


ALTER TABLE public.orders_servers OWNER TO postgres;

--
-- Name: orders_servers_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_servers_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_servers_order_id_seq OWNER TO postgres;

--
-- Name: orders_servers_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_servers_order_id_seq OWNED BY public.orders_servers.order_id;


--
-- Name: orders_servers_server_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_servers_server_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_servers_server_id_seq OWNER TO postgres;

--
-- Name: orders_servers_server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_servers_server_id_seq OWNED BY public.orders_servers.server_id;


--
-- Name: orders_workspaces_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_workspaces_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_workspaces_users_id_seq OWNER TO postgres;

--
-- Name: orders_workspaces_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_workspaces_users_id_seq OWNED BY public.orders.workspaces_users_id;


--
-- Name: servers_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servers_configuration (
    server_conf_id integer NOT NULL,
    cpu character varying(50) NOT NULL,
    gpu character varying(50) NOT NULL,
    ram_mb integer NOT NULL,
    ssd_storage_mb integer NOT NULL,
    os character varying(50) NOT NULL,
    price double precision NOT NULL,
    server_on boolean DEFAULT true NOT NULL
);


ALTER TABLE public.servers_configuration OWNER TO postgres;

--
-- Name: server_configuration_server_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_configuration_server_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_configuration_server_id_seq OWNER TO postgres;

--
-- Name: server_configuration_server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_configuration_server_id_seq OWNED BY public.servers_configuration.server_conf_id;


--
-- Name: servers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servers (
    server_id integer NOT NULL,
    server_conf_id integer NOT NULL,
    opened_on timestamp without time zone NOT NULL,
    closed_on timestamp without time zone NOT NULL
);


ALTER TABLE public.servers OWNER TO postgres;

--
-- Name: servers_server_conf_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servers_server_conf_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.servers_server_conf_id_seq OWNER TO postgres;

--
-- Name: servers_server_conf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servers_server_conf_id_seq OWNED BY public.servers.server_conf_id;


--
-- Name: servers_server_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servers_server_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.servers_server_id_seq OWNER TO postgres;

--
-- Name: servers_server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servers_server_id_seq OWNED BY public.servers.server_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(100) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.id;


--
-- Name: workspaces; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspaces (
    id integer NOT NULL,
    workspace_name character varying(50) NOT NULL
);


ALTER TABLE public.workspaces OWNER TO postgres;

--
-- Name: workspaces_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workspaces_users (
    id integer NOT NULL,
    workspace_id integer NOT NULL,
    user_id integer NOT NULL,
    is_owner boolean NOT NULL
);


ALTER TABLE public.workspaces_users OWNER TO postgres;

--
-- Name: workspaces_users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspaces_users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaces_users_user_id_seq OWNER TO postgres;

--
-- Name: workspaces_users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspaces_users_user_id_seq OWNED BY public.workspaces_users.user_id;


--
-- Name: workspaces_users_workspace_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspaces_users_workspace_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaces_users_workspace_id_seq OWNER TO postgres;

--
-- Name: workspaces_users_workspace_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspaces_users_workspace_id_seq OWNED BY public.workspaces_users.workspace_id;


--
-- Name: workspaces_users_workspaces_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspaces_users_workspaces_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaces_users_workspaces_user_id_seq OWNER TO postgres;

--
-- Name: workspaces_users_workspaces_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspaces_users_workspaces_user_id_seq OWNED BY public.workspaces_users.id;


--
-- Name: workspaces_workspace_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workspaces_workspace_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workspaces_workspace_id_seq OWNER TO postgres;

--
-- Name: workspaces_workspace_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workspaces_workspace_id_seq OWNED BY public.workspaces.id;


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: orders workspaces_users_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN workspaces_users_id SET DEFAULT nextval('public.orders_workspaces_users_id_seq'::regclass);


--
-- Name: orders_servers order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_servers ALTER COLUMN order_id SET DEFAULT nextval('public.orders_servers_order_id_seq'::regclass);


--
-- Name: orders_servers server_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_servers ALTER COLUMN server_id SET DEFAULT nextval('public.orders_servers_server_id_seq'::regclass);


--
-- Name: servers server_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servers ALTER COLUMN server_id SET DEFAULT nextval('public.servers_server_id_seq'::regclass);


--
-- Name: servers server_conf_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servers ALTER COLUMN server_conf_id SET DEFAULT nextval('public.servers_server_conf_id_seq'::regclass);


--
-- Name: servers_configuration server_conf_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servers_configuration ALTER COLUMN server_conf_id SET DEFAULT nextval('public.server_configuration_server_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: workspaces id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces ALTER COLUMN id SET DEFAULT nextval('public.workspaces_workspace_id_seq'::regclass);


--
-- Name: workspaces_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces_users ALTER COLUMN id SET DEFAULT nextval('public.workspaces_users_workspaces_user_id_seq'::regclass);


--
-- Name: workspaces_users workspace_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces_users ALTER COLUMN workspace_id SET DEFAULT nextval('public.workspaces_users_workspace_id_seq'::regclass);


--
-- Name: workspaces_users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces_users ALTER COLUMN user_id SET DEFAULT nextval('public.workspaces_users_user_id_seq'::regclass);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, price_rub, workspaces_users_id) FROM stdin;
1	10000	1
\.


--
-- Data for Name: orders_servers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_servers (order_id, server_id) FROM stdin;
1	1
\.


--
-- Data for Name: servers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servers (server_id, server_conf_id, opened_on, closed_on) FROM stdin;
1	1	2023-05-17 20:21:39.514009	2023-05-18 20:21:39.514009
2	2	2023-05-26 10:03:22.885959	2023-05-26 10:03:22.885959
\.


--
-- Data for Name: servers_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servers_configuration (server_conf_id, cpu, gpu, ram_mb, ssd_storage_mb, os, price, server_on) FROM stdin;
1	Ryzen 9: 5700x	VEGA 56	16384	1048576	Windows	5000	t
2	Intel Xeon	RTX 4090	32768	1024000	Debian	10000	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, login, password) FROM stdin;
1	Sergey	sha256$ROsbJonmUtOhGL7A$5dca25663e1d41438955fde52ed47293505d9ba75e0b969ff381700463b8c122
2	TestAcc	sha256$PSoMQLgVZKFFn9Ke$0c3e11a708ff5daea839661df6c2e2da71c05f75d83b8b4bcc9e5bcbe8f2aac4
\.


--
-- Data for Name: workspaces; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workspaces (id, workspace_name) FROM stdin;
2	test
8	dadsa
5	Нормальное название
1	ananananna
\.


--
-- Data for Name: workspaces_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workspaces_users (id, workspace_id, user_id, is_owner) FROM stdin;
1	1	1	t
2	5	1	t
5	1	2	f
6	8	2	t
\.


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 1, false);


--
-- Name: orders_servers_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_servers_order_id_seq', 1, false);


--
-- Name: orders_servers_server_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_servers_server_id_seq', 1, false);


--
-- Name: orders_workspaces_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_workspaces_users_id_seq', 1, false);


--
-- Name: server_configuration_server_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.server_configuration_server_id_seq', 1, false);


--
-- Name: servers_server_conf_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servers_server_conf_id_seq', 1, false);


--
-- Name: servers_server_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servers_server_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 2, true);


--
-- Name: workspaces_users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workspaces_users_user_id_seq', 1, false);


--
-- Name: workspaces_users_workspace_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workspaces_users_workspace_id_seq', 1, false);


--
-- Name: workspaces_users_workspaces_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workspaces_users_workspaces_user_id_seq', 7, true);


--
-- Name: workspaces_workspace_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workspaces_workspace_id_seq', 9, true);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: orders_servers orders_servers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_servers
    ADD CONSTRAINT orders_servers_pkey PRIMARY KEY (order_id, server_id);


--
-- Name: servers_configuration server_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servers_configuration
    ADD CONSTRAINT server_configuration_pkey PRIMARY KEY (server_conf_id);


--
-- Name: servers servers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servers
    ADD CONSTRAINT servers_pkey PRIMARY KEY (server_id);


--
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workspaces workspaces_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);


--
-- Name: workspaces_users workspaces_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces_users
    ADD CONSTRAINT workspaces_users_pkey PRIMARY KEY (id);


--
-- Name: orders_servers orders_servers_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_servers
    ADD CONSTRAINT orders_servers_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders_servers orders_servers_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_servers
    ADD CONSTRAINT orders_servers_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.servers(server_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders orders_workspaces_users_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_workspaces_users_id_fkey FOREIGN KEY (workspaces_users_id) REFERENCES public.workspaces_users(id);


--
-- Name: servers servers_server_conf_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servers
    ADD CONSTRAINT servers_server_conf_id_fkey FOREIGN KEY (server_conf_id) REFERENCES public.servers_configuration(server_conf_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: workspaces_users workspaces_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces_users
    ADD CONSTRAINT workspaces_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: workspaces_users workspaces_users_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workspaces_users
    ADD CONSTRAINT workspaces_users_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

