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
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';---- Name: create_language_plpgsql(); Type: FUNCTION; Schema: public; Owner: postgres--
CREATE FUNCTION public.create_language_plpgsql() RETURNS boolean
    LANGUAGE sql
    AS $$
	CREATE LANGUAGE plpgsql;
	SELECT TRUE;
$$;
ALTER FUNCTION public.create_language_plpgsql() OWNER TO postgres;
CREATE FUNCTION public.f_add_col(tbl regclass, col text, _type text, OUT success boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
IF EXISTS (
		SELECT 1 FROM pg_attribute
		WHERE  attrelid = tbl
		AND    attname = col
		AND    NOT attisdropped)
	THEN
		success := FALSE;
	ELSE
		EXECUTE 'ALTER TABLE ' || tbl || ' ADD COLUMN ' || quote_ident(col) || ' ' || _type;
		success := TRUE;
END IF;
END $$;
ALTER FUNCTION public.f_add_col(tbl regclass, col text, _type text, OUT success boolean) OWNER TO postgres;
CREATE FUNCTION public.f_drop_col(tbl regclass, col text, OUT success boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
IF EXISTS (
		SELECT 1 FROM pg_attribute
		WHERE  attrelid = tbl
		AND    attname = col
		AND    NOT attisdropped) 
	THEN
		EXECUTE 'ALTER TABLE ' || tbl || ' DROP COLUMN ' || quote_ident(col);
		success := TRUE;
	ELSE
		success := FALSE;
END IF;
END $$;
ALTER FUNCTION public.f_drop_col(tbl regclass, col text, OUT success boolean) OWNER TO postgres;
SET default_tablespace = '';
SET default_with_oids = false;
CREATE TABLE public.card_cardactions (
    actionid bigint NOT NULL,
    actiondate timestamp without time zone,
    cardaction integer,
    cash character varying(255),
    shop character varying(255),
    username character varying(255),
    cardentity_id bigint,
    userid bigint,
    source integer DEFAULT 0 NOT NULL,
    reason text
);
ALTER TABLE public.card_cardactions OWNER TO postgres;
COMMENT ON TABLE public.card_cardactions IS 'Действия с картами (блокировка, выдача и т.д.)';---- Name: card_cardrange; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.card_cardrange (
    id bigint NOT NULL,
    countfield numeric(20,0),
    deleted boolean,
    virtual boolean,
    guid bigint,
    startfield character varying(255),
    cardtype_id bigint
);
ALTER TABLE public.card_cardrange OWNER TO postgres;
COMMENT ON TABLE public.card_cardrange IS 'Диапазоны карт';---- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: postgres--
CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.hibernate_sequence OWNER TO postgres;
CREATE TABLE public.card_cards (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    activationdate timestamp without time zone,
    amount bigint,
    barcode character varying(255),
    createdate timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    expirationdate timestamp without time zone,
    guid bigint,
    numberfield character varying(255) NOT NULL,
    status integer,
    statusdescription character varying(255),
    cardtype_id bigint,
    client_id bigint,
    newcardtype_id bigint,
    id_cardref bigint,
    counterparty character varying(128),
    debitor_type text,
    display_number character varying(256),
    msr_number character varying(255)
);
ALTER TABLE public.card_cards OWNER TO postgres;
COMMENT ON TABLE public.card_cards IS 'Номера экземпляров карт';---- Name: COLUMN card_cards.counterparty; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.card_cardtype (
    id bigint NOT NULL,
    color_red smallint,
    color_green smallint,
    color_blue smallint,
    deleted boolean,
    guid bigint,
    name character varying(255),
    personalized boolean NOT NULL
);
ALTER TABLE public.card_cardtype OWNER TO postgres;
COMMENT ON TABLE public.card_cardtype IS 'Типы карт';---- Name: COLUMN card_cardtype.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.card_clients (
    id bigint NOT NULL,
    auto boolean,
    birthdate date,
    childrenage character varying(255),
    appartment character varying(255),
    building character varying(255),
    city character varying(255),
    district character varying(255),
    districtarea character varying(255),
    house character varying(255),
    other character varying(255),
    region character varying(255),
    street character varying(255),
    zip character varying(255),
    deleted boolean,
    email character varying(255),
    firstname character varying(255),
    guid bigint,
    iscompleted boolean,
    lastchangedate timestamp without time zone,
    lastname character varying(255),
    marital boolean,
    middlename character varying(255),
    mobileoperator character varying(255),
    mobilephone character varying(255),
    delivery character varying(255),
    deliverydate date,
    passnumber character varying(255),
    passserie character varying(255),
    phone character varying(255),
    bymail boolean,
    bysms boolean,
    byphone boolean,
    byemail boolean,
    sendcatalog boolean NOT NULL,
    sex integer,
    shopnumber character varying(255),
    creationdate timestamp without time zone,
    bonusbalance bigint,
    clienttype smallint,
    receipt_feedback_means smallint DEFAULT 0 NOT NULL,
    smartphone_type character varying(20),
    wants_e_card boolean DEFAULT false NOT NULL
);
ALTER TABLE public.card_clients OWNER TO postgres;
COMMENT ON TABLE public.card_clients IS 'Владельцы карт (ClientEntity)';---- Name: COLUMN card_clients.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.card_conditionchange (
    id bigint NOT NULL,
    amount bigint NOT NULL,
    changecard boolean NOT NULL,
    deleted boolean,
    intervaltype integer,
    month integer,
    onecheck boolean NOT NULL,
    operatormessage character varying(255),
    timerange integer,
    typeofcomparison integer,
    work_period_begin timestamp without time zone,
    work_period_end timestamp without time zone,
    worksperiod integer,
    worksperiodtype integer,
    year integer,
    cardcategory_id bigint,
    newcardcategory_id bigint
);
ALTER TABLE public.card_conditionchange OWNER TO postgres;
COMMENT ON TABLE public.card_conditionchange IS 'Информация о смене категорий';---- Name: card_coupons; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.card_coupons (
    activationdate timestamp without time zone,
    expirationdate timestamp without time zone,
    hasexpirationdate boolean NOT NULL,
    need_show_message boolean DEFAULT false NOT NULL,
    name_for_client character varying(255),
    description character varying(255),
    id bigint NOT NULL,
    aoe character varying(10)
);
ALTER TABLE public.card_coupons OWNER TO postgres;
COMMENT ON TABLE public.card_coupons IS 'Тип карты: Купон';---- Name: COLUMN card_coupons.activationdate; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.card_externalcards (
    percentagediscount bigint,
    processing character varying(255),
    useprocessing boolean NOT NULL,
    withoutdiscount boolean NOT NULL,
    id bigint NOT NULL
);
ALTER TABLE public.card_externalcards OWNER TO postgres;
COMMENT ON TABLE public.card_externalcards IS 'Внешние карты';---- Name: card_internalcards; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.card_internalcards (
    accumulative boolean NOT NULL,
    bonus boolean NOT NULL,
    creditlimit bigint,
    domesticcredit boolean NOT NULL,
    percentagediscount bigint,
    withoutfinishdate boolean NOT NULL,
    work_period_begin timestamp without time zone,
    work_period_end timestamp without time zone,
    show_card_from_range_notification boolean DEFAULT false NOT NULL,
    id bigint NOT NULL
);
ALTER TABLE public.card_internalcards OWNER TO postgres;
COMMENT ON TABLE public.card_internalcards IS 'Внутренние карты';---- Name: card_presentcards; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.card_presentcards (
    amount bigint,
    barcode character varying(255),
    fixedamount boolean NOT NULL,
    maxamount bigint,
    multiplicity bigint,
    withoutfinishdate boolean NOT NULL,
    work_period_begin timestamp without time zone,
    work_period_end timestamp without time zone,
    id bigint NOT NULL
);
ALTER TABLE public.card_presentcards OWNER TO postgres;
COMMENT ON TABLE public.card_presentcards IS 'Подарочные карты';---- Name: card_presentcards_pending_op; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.card_presentcards_pending_op (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    card_number character varying(64) NOT NULL,
    amount bigint,
    created timestamp(6) without time zone NOT NULL,
    reason character varying(4096) NOT NULL,
    operation_type character varying(32) NOT NULL,
    cashier_tab_num character varying(32) NOT NULL,
    cashier_name character varying(64) NOT NULL,
    status character varying(32) NOT NULL,
    shop_index bigint NOT NULL,
    cash_index bigint NOT NULL,
    shift_num bigint NOT NULL,
    check_num bigint
);
ALTER TABLE public.card_presentcards_pending_op OWNER TO postgres;
COMMENT ON TABLE public.card_presentcards_pending_op IS 'Отложенные операции по подарочным картам';---- Name: COLUMN card_presentcards_pending_op.card_number; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cards_lastcardid (
    id bigint NOT NULL,
    file_id bigint NOT NULL,
    processed_at timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.cards_lastcardid OWNER TO postgres;
COMMENT ON TABLE public.cards_lastcardid IS 'Последний идентификатор файла с картами, что был скачан с сервера (CardsLastFileIdEntity)';---- Name: COLUMN cards_lastcardid.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cards_pending_operation (
    id bigint NOT NULL,
    created timestamp(6) without time zone NOT NULL,
    store_id character varying(32) NOT NULL,
    cash_id character varying(32),
    card_number character varying(64),
    operation_type character varying(64) NOT NULL,
    transaction_id character varying(4096) NOT NULL,
    reason character varying(4096),
    last_attempt_date timestamp(6) without time zone,
    last_attempt_error character varying(4096),
    number_of_attempts integer DEFAULT 0 NOT NULL,
    id_purchase bigint,
    guid_client bigint,
    shift_num bigint,
    bonus_sum bigint,
    account_id bigint,
    additional_params text
);
ALTER TABLE public.cards_pending_operation OWNER TO postgres;
COMMENT ON TABLE public.cards_pending_operation IS 'Отложенные операции в модуле карт';---- Name: COLUMN cards_pending_operation.created; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cards_processing_reports (
    id bigint NOT NULL,
    file_id bigint NOT NULL,
    card_object_type character varying(30),
    card_object_id bigint,
    processing_status boolean DEFAULT false NOT NULL,
    report_date timestamp without time zone DEFAULT now()
);
ALTER TABLE public.cards_processing_reports OWNER TO postgres;
COMMENT ON TABLE public.cards_processing_reports IS 'Отчет по результатам обработки файла-каталога карт (карточных сущностей), что еще не был доложен серверу (CardsProcessingReportEntity)';---- Name: COLUMN cards_processing_reports.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cards_properties (
    property_key character varying(100) NOT NULL,
    property_value character varying(1024)
);
ALTER TABLE public.cards_properties OWNER TO postgres;
COMMENT ON TABLE public.cards_properties IS 'Настройки модуля';---- Name: COLUMN cards_properties.property_key; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cards_wholesale_restrictions (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    card_number character varying(255),
    product_id character varying(255),
    action_guid bigint,
    quantity bigint DEFAULT 0,
    date timestamp without time zone,
    loy_tx_id bigint
);
ALTER TABLE public.cards_wholesale_restrictions OWNER TO postgres;
COMMENT ON TABLE public.cards_wholesale_restrictions IS 'Информация о покупках в рамках оптовых ограничений';---- Name: COLUMN cards_wholesale_restrictions.id; Type: COMMENT; Schema: public; Owner: postgres--
ALTER TABLE ONLY public.card_cardactions
    ADD CONSTRAINT card_cardactions_pkey PRIMARY KEY (actionid);
ALTER TABLE ONLY public.card_cardrange
    ADD CONSTRAINT card_cardrange_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT card_cards_numberfield_key UNIQUE (numberfield);
ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT card_cards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.card_cardtype
    ADD CONSTRAINT card_cardtype_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.card_clients
    ADD CONSTRAINT card_clients_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.card_conditionchange
    ADD CONSTRAINT card_conditionchange_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.card_coupons
    ADD CONSTRAINT card_coupons_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.card_externalcards
    ADD CONSTRAINT card_externalcards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.card_internalcards
    ADD CONSTRAINT card_internalcards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.card_presentcards_pending_op
    ADD CONSTRAINT card_presentcards_pending_op_pk PRIMARY KEY (id);
ALTER TABLE ONLY public.card_presentcards
    ADD CONSTRAINT card_presentcards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cards_lastcardid
    ADD CONSTRAINT cards_importing_history_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cards_pending_operation
    ADD CONSTRAINT cards_pending_operation_pk PRIMARY KEY (id);
ALTER TABLE ONLY public.cards_processing_reports
    ADD CONSTRAINT cards_processing_reports_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cards_properties
    ADD CONSTRAINT cards_properties_pkey PRIMARY KEY (property_key);
ALTER TABLE ONLY public.cards_wholesale_restrictions
    ADD CONSTRAINT cards_wholesale_restrictions_pkey PRIMARY KEY (id);
CREATE INDEX card_cards_cardtype_id_ndx ON public.card_cards USING btree (cardtype_id);
CREATE INDEX card_cards_client_id_ndx ON public.card_cards USING btree (client_id);
CREATE INDEX card_cards_guid_ndx ON public.card_cards USING btree (guid);
CREATE INDEX card_cards_id_cardref_ndx ON public.card_cards USING btree (id_cardref);
CREATE INDEX card_cards_newcardtype_id_ndx ON public.card_cards USING btree (newcardtype_id);
CREATE INDEX card_cards_numberfield_idx ON public.card_cards USING btree (numberfield);
CREATE UNIQUE INDEX card_clients_guid_idx ON public.card_clients USING btree (guid);
CREATE INDEX card_clients_ndx ON public.card_clients USING btree (guid);
CREATE INDEX cards_pending_operation_created_ndx ON public.cards_pending_operation USING btree (created);
CREATE INDEX cards_pending_operation_type_ndx ON public.cards_pending_operation USING btree (operation_type);
CREATE INDEX cards_wholesale_restrictions_card_number_indx ON public.cards_wholesale_restrictions USING btree (card_number);
ALTER TABLE ONLY public.card_cardrange
    ADD CONSTRAINT fk227b059e85fd630e FOREIGN KEY (cardtype_id) REFERENCES public.card_cardtype(id);
ALTER TABLE ONLY public.card_coupons
    ADD CONSTRAINT fk4a762adefa229cf9 FOREIGN KEY (id) REFERENCES public.card_cardtype(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.card_presentcards
    ADD CONSTRAINT fk8758b837fa229cf9 FOREIGN KEY (id) REFERENCES public.card_cardtype(id);
ALTER TABLE ONLY public.card_externalcards
    ADD CONSTRAINT fk8e54d769fa229cf9 FOREIGN KEY (id) REFERENCES public.card_cardtype(id);
ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT fkaf56257431d52ce3 FOREIGN KEY (id_cardref) REFERENCES public.card_cards(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT fkaf562574408f756e FOREIGN KEY (newcardtype_id) REFERENCES public.card_cardtype(id);
ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT fkaf56257485fd630e FOREIGN KEY (cardtype_id) REFERENCES public.card_cardtype(id);
ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT fkaf562574a8ed2ece FOREIGN KEY (client_id) REFERENCES public.card_clients(id);
ALTER TABLE ONLY public.card_cardactions
    ADD CONSTRAINT fkf045811e1cc4f66b FOREIGN KEY (cardentity_id) REFERENCES public.card_cards(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.card_conditionchange
    ADD CONSTRAINT fkf97897cab0b4d5c FOREIGN KEY (cardcategory_id) REFERENCES public.card_internalcards(id);
ALTER TABLE ONLY public.card_conditionchange
    ADD CONSTRAINT fkf97897ccf8d2fbc FOREIGN KEY (newcardcategory_id) REFERENCES public.card_internalcards(id);
ALTER TABLE ONLY public.card_internalcards
    ADD CONSTRAINT fkfb707bb7fa229cf9 FOREIGN KEY (id) REFERENCES public.card_cardtype(id);
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
