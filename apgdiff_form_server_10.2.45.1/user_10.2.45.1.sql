SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;
CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';---- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: postgres--
CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.hibernate_sequence OWNER TO postgres;
SET default_tablespace = '';
SET default_with_oids = false;
CREATE TABLE public.seller (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    deleted boolean NOT NULL,
    blocked boolean NOT NULL,
    first_name character varying(100),
    middle_name character varying(100),
    last_name character varying(100),
    seller_number character varying(40),
    barcode character varying(255),
    shop integer
);
ALTER TABLE public.seller OWNER TO postgres;
COMMENT ON TABLE public.seller IS 'Продавцы в магазине (SellerEntity)';---- Name: COLUMN seller.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.us_right (
    id integer NOT NULL,
    right_user character varying(48) NOT NULL,
    name character varying(255) NOT NULL,
    privilege_section character varying(64) NOT NULL
);
ALTER TABLE public.us_right OWNER TO postgres;
COMMENT ON TABLE public.us_right IS 'Права кассиров';---- Name: us_role; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.us_role (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    guid bigint,
    name character varying(255) NOT NULL
);
ALTER TABLE public.us_role OWNER TO postgres;
COMMENT ON TABLE public.us_role IS 'Роли кассиров';---- Name: us_role_us_right; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.us_role_us_right (
    role_id bigint NOT NULL,
    right_id integer NOT NULL,
    key_position integer
);
ALTER TABLE public.us_role_us_right OWNER TO postgres;
COMMENT ON TABLE public.us_role_us_right IS 'Роли и привилегии кассиров';---- Name: us_user; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.us_user (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    deleted boolean NOT NULL,
    guid bigint NOT NULL,
    barcode character varying(64),
    blocked boolean,
    access_time character varying(100),
    first_name character varying(100),
    middle_name character varying(100),
    last_name character varying(100),
    magnetic_card character varying(255),
    set10_card character varying(255),
    magnetic_key character varying(255),
    password_unique character varying(100),
    tab_num character varying(40),
    shop integer,
    id_role bigint,
    inn character varying(255)
);
ALTER TABLE public.us_user OWNER TO postgres;
COMMENT ON TABLE public.us_user IS 'Список кассиров';---- Name: COLUMN us_user.inn; Type: COMMENT; Schema: public; Owner: postgres--
ALTER TABLE ONLY public.us_right
    ADD CONSTRAINT pk_us_right PRIMARY KEY (id);
ALTER TABLE ONLY public.us_role_us_right
    ADD CONSTRAINT pk_us_right_us_role PRIMARY KEY (role_id, right_id);
ALTER TABLE ONLY public.us_role
    ADD CONSTRAINT pk_us_role PRIMARY KEY (id);
ALTER TABLE ONLY public.us_user
    ADD CONSTRAINT pk_us_user PRIMARY KEY (id);
ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_number_key UNIQUE (seller_number, shop);
ALTER TABLE ONLY public.seller
    ADD CONSTRAINT seller_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.us_role
    ADD CONSTRAINT uniq_us_role__guid UNIQUE (guid);
ALTER TABLE ONLY public.us_user
    ADD CONSTRAINT uniq_us_user__password_unique UNIQUE (password_unique, shop);
ALTER TABLE ONLY public.us_user
    ADD CONSTRAINT uniq_us_user__tab_num UNIQUE (tab_num, shop);
ALTER TABLE ONLY public.us_user
    ADD CONSTRAINT uniq_us_user_barcode UNIQUE (barcode, shop);
ALTER TABLE ONLY public.us_user
    ADD CONSTRAINT uniq_us_user_magnetic_card UNIQUE (magnetic_card, shop);
ALTER TABLE ONLY public.us_user
    ADD CONSTRAINT uniq_us_user_magnetic_key UNIQUE (magnetic_key, shop);
ALTER TABLE ONLY public.us_user
    ADD CONSTRAINT uniq_us_user_set10_card UNIQUE (set10_card, shop);
CREATE INDEX idx_us_role__guid ON public.us_role USING btree (guid);
CREATE INDEX idx_us_user__barcode ON public.us_user USING btree (barcode);
CREATE INDEX idx_us_user__guid ON public.us_user USING btree (guid);
CREATE INDEX idx_us_user__magnetic_card ON public.us_user USING btree (magnetic_card);
CREATE INDEX idx_us_user__magnetic_key ON public.us_user USING btree (magnetic_key);
CREATE INDEX idx_us_user__password_unique ON public.us_user USING btree (password_unique);
ALTER TABLE ONLY public.us_role_us_right
    ADD CONSTRAINT fk_us_role_us_right__us_right FOREIGN KEY (right_id) REFERENCES public.us_right(id) MATCH FULL;
ALTER TABLE ONLY public.us_role_us_right
    ADD CONSTRAINT fk_us_role_us_right__us_role FOREIGN KEY (role_id) REFERENCES public.us_role(id) MATCH FULL;
ALTER TABLE ONLY public.us_user
    ADD CONSTRAINT fk_us_user__us_role FOREIGN KEY (id_role) REFERENCES public.us_role(id);
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
