--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.10
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: create_language_plpgsql(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_language_plpgsql() RETURNS boolean
    LANGUAGE sql
    AS $$
	CREATE LANGUAGE plpgsql;
	SELECT TRUE;
$$;


ALTER FUNCTION public.create_language_plpgsql() OWNER TO postgres;

--
-- Name: f_add_col(regclass, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_add_col(tbl regclass, col text, _type text, OUT success boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
-- ----------------------------------------------------
--  Функция: добавить колонку, если ее еще нет
--  tbl   - таблица, в которую добавляем колонку
--  col   - название колонки, что хотим добавить
--  _type - тип и constraint'ы добавляемой колонки. Пример: "SMALLINT NOT NULL DEFAULT 0"
--  результат: FALSE - если колонка уже была, TRUE - если ее еще не было
-- ----------------------------------------------------
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

--
-- Name: f_drop_col(regclass, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_drop_col(tbl regclass, col text, OUT success boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
-- ----------------------------------------------------
--  Функция: удалить колонку, если она существует
--  tbl   - таблица, из которой хотим удалить колонку
--  col   - название колонки, что хотим удалить
--  результат: FALSE - если колонки и так уже не было, TRUE - если она была
-- ----------------------------------------------------
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

--
-- Name: card_cardactions; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_cardactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_cardactions IS 'Действия с картами (блокировка, выдача и т.д.)';


--
-- Name: card_cardrange; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_cardrange; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_cardrange IS 'Диапазоны карт';


--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO postgres;

--
-- Name: card_cards; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_cards; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_cards IS 'Номера экземпляров карт';


--
-- Name: COLUMN card_cards.counterparty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_cards.counterparty IS 'Ссылка на справочник контрагента - сочетание ИНН;КПП';


--
-- Name: COLUMN card_cards.debitor_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_cards.debitor_type IS 'Тип дебитора, например Mercury';


--
-- Name: card_cardtype; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_cardtype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_cardtype IS 'Типы карт';


--
-- Name: COLUMN card_cardtype.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_cardtype.id IS 'Первичный ключ';


--
-- Name: COLUMN card_cardtype.deleted; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_cardtype.deleted IS 'Если TRUE - значит, это тип карт не используется (не активен)';


--
-- Name: COLUMN card_cardtype.guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_cardtype.guid IS '(добавить описание)';


--
-- Name: COLUMN card_cardtype.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_cardtype.name IS 'Наименование';


--
-- Name: COLUMN card_cardtype.personalized; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_cardtype.personalized IS 'Персонализированная?';


--
-- Name: card_clients; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_clients; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_clients IS 'Владельцы карт (ClientEntity)';


--
-- Name: COLUMN card_clients.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.id IS 'Первичный ключ';


--
-- Name: COLUMN card_clients.auto; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.auto IS 'Есть машина?';


--
-- Name: COLUMN card_clients.birthdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.birthdate IS 'Дата рождения';


--
-- Name: COLUMN card_clients.childrenage; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.childrenage IS 'Стринговое поле Дети, возраст';


--
-- Name: COLUMN card_clients.appartment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.appartment IS 'Адрес: Квартира';


--
-- Name: COLUMN card_clients.building; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.building IS 'Адрес: Строение';


--
-- Name: COLUMN card_clients.city; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.city IS 'Адрес: Город';


--
-- Name: COLUMN card_clients.district; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.district IS 'Адрес: Район';


--
-- Name: COLUMN card_clients.districtarea; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.districtarea IS 'Адрес: Район области';


--
-- Name: COLUMN card_clients.house; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.house IS 'Адрес: Дом';


--
-- Name: COLUMN card_clients.other; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.other IS 'Адрес: Прочее';


--
-- Name: COLUMN card_clients.region; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.region IS 'Адрес: Область';


--
-- Name: COLUMN card_clients.street; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.street IS 'Адрес: Улица';


--
-- Name: COLUMN card_clients.zip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.zip IS 'Адрес: Индекс';


--
-- Name: COLUMN card_clients.deleted; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.deleted IS 'эта запись удалена - недействительна';


--
-- Name: COLUMN card_clients.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.email IS '(добавить описание)';


--
-- Name: COLUMN card_clients.firstname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.firstname IS 'Имя';


--
-- Name: COLUMN card_clients.guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.guid IS '(добавить описание)';


--
-- Name: COLUMN card_clients.iscompleted; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.iscompleted IS '(добавить описание): конченный клиент или не конченный?';


--
-- Name: COLUMN card_clients.lastchangedate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.lastchangedate IS '(добавить описание)';


--
-- Name: COLUMN card_clients.lastname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.lastname IS 'Фамилия';


--
-- Name: COLUMN card_clients.marital; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.marital IS 'Женат/замужем?';


--
-- Name: COLUMN card_clients.middlename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.middlename IS 'Отчество';


--
-- Name: COLUMN card_clients.mobileoperator; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.mobileoperator IS 'Оператор';


--
-- Name: COLUMN card_clients.mobilephone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.mobilephone IS 'Моб телефон';


--
-- Name: COLUMN card_clients.delivery; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.delivery IS 'Паспорт: (добавить описание)';


--
-- Name: COLUMN card_clients.deliverydate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.deliverydate IS 'Паспорт: (добавить описание)';


--
-- Name: COLUMN card_clients.passnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.passnumber IS 'Паспорт: номер';


--
-- Name: COLUMN card_clients.passserie; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.passserie IS 'Паспорт: серия';


--
-- Name: COLUMN card_clients.phone; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.phone IS '(добавить описание)';


--
-- Name: COLUMN card_clients.sendcatalog; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.sendcatalog IS 'Расслыть ли каталог true- рассылать,  false в противном случае';


--
-- Name: COLUMN card_clients.sex; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.sex IS 'Пол';


--
-- Name: COLUMN card_clients.shopnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.shopnumber IS 'Номер магазина (Видимо где была выдана карта)';


--
-- Name: COLUMN card_clients.creationdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.creationdate IS 'Дата создания анкеты';


--
-- Name: COLUMN card_clients.bonusbalance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.bonusbalance IS 'Бонусный баланс клиента';


--
-- Name: COLUMN card_clients.clienttype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.clienttype IS 'Тип клиента';


--
-- Name: COLUMN card_clients.receipt_feedback_means; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.receipt_feedback_means IS 'Битовая маска, определяющая способы оповещения картоносца о совершенной покупке. 0й бит: отправлять чек на email; 1й бит: по SMS';


--
-- Name: COLUMN card_clients.smartphone_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.smartphone_type IS 'Тип смартфона, принадлежащий данному картоносцу: IOS, ANDROID, SAMSUNG';


--
-- Name: COLUMN card_clients.wants_e_card; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_clients.wants_e_card IS 'Флаг-признак: хочет ли данный картоносец получить на свой телефон или email png-картинку с штрих-кодом своего номера карты';


--
-- Name: card_conditionchange; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_conditionchange; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_conditionchange IS 'Информация о смене категорий';


--
-- Name: card_coupons; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_coupons; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_coupons IS 'Тип карты: Купон';


--
-- Name: COLUMN card_coupons.activationdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_coupons.activationdate IS 'Дата активации';


--
-- Name: COLUMN card_coupons.expirationdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_coupons.expirationdate IS 'Действует до этой даты';


--
-- Name: COLUMN card_coupons.hasexpirationdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_coupons.hasexpirationdate IS 'признак бессрочности карты если true значит карта имеет конечный срок';


--
-- Name: COLUMN card_coupons.need_show_message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_coupons.need_show_message IS 'признак нужности отображать сообщения кассиру, если купон был использован и его нужно забрать';


--
-- Name: COLUMN card_coupons.name_for_client; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_coupons.name_for_client IS 'Название купона, которое показывается клиенту';


--
-- Name: COLUMN card_coupons.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_coupons.description IS 'Описание преференции, которую дает купон, которое показывается клиенту';


--
-- Name: COLUMN card_coupons.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_coupons.id IS 'Первичный ключ';


--
-- Name: COLUMN card_coupons.aoe; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_coupons.aoe IS '"Область действия" купонов данного вида: RECEIPT/POSITION/ITEM == купон действет на: весь чек/на позицию (возможно, не всю)/на одну единицу(штуку, кусок) товара; NULL распознается как RECEIPT';


--
-- Name: card_externalcards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.card_externalcards (
    percentagediscount bigint,
    processing character varying(255),
    useprocessing boolean NOT NULL,
    withoutdiscount boolean NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.card_externalcards OWNER TO postgres;

--
-- Name: TABLE card_externalcards; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_externalcards IS 'Внешние карты';


--
-- Name: card_internalcards; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_internalcards; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_internalcards IS 'Внутренние карты';


--
-- Name: card_presentcards; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_presentcards; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_presentcards IS 'Подарочные карты';


--
-- Name: card_presentcards_pending_op; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE card_presentcards_pending_op; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.card_presentcards_pending_op IS 'Отложенные операции по подарочным картам';


--
-- Name: COLUMN card_presentcards_pending_op.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.card_number IS 'Номер карты';


--
-- Name: COLUMN card_presentcards_pending_op.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.amount IS 'Сумма по карте';


--
-- Name: COLUMN card_presentcards_pending_op.created; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.created IS 'Дата создания отложенной операции';


--
-- Name: COLUMN card_presentcards_pending_op.reason; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.reason IS 'Причина, по которой была создана отложенная операция';


--
-- Name: COLUMN card_presentcards_pending_op.operation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.operation_type IS 'Тип операции';


--
-- Name: COLUMN card_presentcards_pending_op.cashier_tab_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.cashier_tab_num IS 'Табельный номер кассира';


--
-- Name: COLUMN card_presentcards_pending_op.cashier_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.cashier_name IS 'Имя кассира';


--
-- Name: COLUMN card_presentcards_pending_op.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.status IS 'Состояние обработки запросая';


--
-- Name: COLUMN card_presentcards_pending_op.shop_index; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.shop_index IS 'номер магазина';


--
-- Name: COLUMN card_presentcards_pending_op.cash_index; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.cash_index IS 'номер кассы';


--
-- Name: COLUMN card_presentcards_pending_op.shift_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.shift_num IS 'номер смены';


--
-- Name: COLUMN card_presentcards_pending_op.check_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.card_presentcards_pending_op.check_num IS 'номер чека';


--
-- Name: cards_lastcardid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards_lastcardid (
    id bigint NOT NULL,
    file_id bigint NOT NULL,
    processed_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cards_lastcardid OWNER TO postgres;

--
-- Name: TABLE cards_lastcardid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.cards_lastcardid IS 'Последний идентификатор файла с картами, что был скачан с сервера (CardsLastFileIdEntity)';


--
-- Name: COLUMN cards_lastcardid.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_lastcardid.id IS 'Первичный ключ';


--
-- Name: COLUMN cards_lastcardid.file_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_lastcardid.file_id IS 'Идентификатор файла-каталога, что был обработан';


--
-- Name: COLUMN cards_lastcardid.processed_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_lastcardid.processed_at IS 'Дата и время завершения обработки этого файла';


--
-- Name: cards_pending_operation; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE cards_pending_operation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.cards_pending_operation IS 'Отложенные операции в модуле карт';


--
-- Name: COLUMN cards_pending_operation.created; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.created IS 'Дата создания отложенной операции';


--
-- Name: COLUMN cards_pending_operation.store_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.store_id IS 'Номер (или идентификатор) магазина';


--
-- Name: COLUMN cards_pending_operation.cash_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.cash_id IS 'Номер (или идентификатор) кассы';


--
-- Name: COLUMN cards_pending_operation.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.card_number IS 'Номер карты';


--
-- Name: COLUMN cards_pending_operation.operation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.operation_type IS 'Тип операции';


--
-- Name: COLUMN cards_pending_operation.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.transaction_id IS 'Идентификатор транзакции операции; значение этого поля определяется типом операции';


--
-- Name: COLUMN cards_pending_operation.reason; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.reason IS 'Причина, по которой была создана отложенная операция';


--
-- Name: COLUMN cards_pending_operation.last_attempt_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.last_attempt_date IS 'Дата последней попытки повоторить операцию';


--
-- Name: COLUMN cards_pending_operation.last_attempt_error; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.last_attempt_error IS 'Ошибка, по которой не удалось повторить операцию';


--
-- Name: COLUMN cards_pending_operation.number_of_attempts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.number_of_attempts IS 'Количество попыток повоторить операцию';


--
-- Name: COLUMN cards_pending_operation.id_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.id_purchase IS 'ID чека для Siebel';


--
-- Name: COLUMN cards_pending_operation.guid_client; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.guid_client IS 'Guid клиента';


--
-- Name: COLUMN cards_pending_operation.shift_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.shift_num IS 'Номер смены';


--
-- Name: COLUMN cards_pending_operation.bonus_sum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.bonus_sum IS 'Количество бонусов, участвуещее в операции (для SetRetail10)';


--
-- Name: COLUMN cards_pending_operation.account_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.account_id IS 'Идентификатор бонусного счета (для SetRetail10)';


--
-- Name: COLUMN cards_pending_operation.additional_params; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_pending_operation.additional_params IS 'Дополнительные параметры отложенной операции';


--
-- Name: cards_processing_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards_processing_reports (
    id bigint NOT NULL,
    file_id bigint NOT NULL,
    card_object_type character varying(30),
    card_object_id bigint,
    processing_status boolean DEFAULT false NOT NULL,
    report_date timestamp without time zone DEFAULT now()
);


ALTER TABLE public.cards_processing_reports OWNER TO postgres;

--
-- Name: TABLE cards_processing_reports; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.cards_processing_reports IS 'Отчет по результатам обработки файла-каталога карт (карточных сущностей), что еще не был доложен серверу (CardsProcessingReportEntity)';


--
-- Name: COLUMN cards_processing_reports.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_processing_reports.id IS 'Первичный ключ';


--
-- Name: COLUMN cards_processing_reports.file_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_processing_reports.file_id IS 'Идентификатор файла-каталога, что был обработан';


--
-- Name: COLUMN cards_processing_reports.card_object_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_processing_reports.card_object_type IS 'Тип обработанной карточной сущности (карта, диапазон карт, держатель карты, тип карты, ...)';


--
-- Name: COLUMN cards_processing_reports.card_object_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_processing_reports.card_object_id IS 'Идентификатор обработанной карточной сущности (уникальный в рамках своего типа)';


--
-- Name: COLUMN cards_processing_reports.processing_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_processing_reports.processing_status IS 'Результат обработки этого каталога карт (успех/неуспех == true/false)';


--
-- Name: COLUMN cards_processing_reports.report_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_processing_reports.report_date IS 'Дата и время формирования этого отчета';


--
-- Name: cards_properties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards_properties (
    property_key character varying(100) NOT NULL,
    property_value character varying(1024)
);


ALTER TABLE public.cards_properties OWNER TO postgres;

--
-- Name: TABLE cards_properties; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.cards_properties IS 'Настройки модуля';


--
-- Name: COLUMN cards_properties.property_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_properties.property_key IS 'Название свойства; первичный ключ';


--
-- Name: COLUMN cards_properties.property_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_properties.property_value IS 'Значение свойства';


--
-- Name: cards_wholesale_restrictions; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- Name: TABLE cards_wholesale_restrictions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.cards_wholesale_restrictions IS 'Информация о покупках в рамках оптовых ограничений';


--
-- Name: COLUMN cards_wholesale_restrictions.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_wholesale_restrictions.id IS 'Синтетический ключ';


--
-- Name: COLUMN cards_wholesale_restrictions.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_wholesale_restrictions.card_number IS 'Номер примененной карты';


--
-- Name: COLUMN cards_wholesale_restrictions.product_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_wholesale_restrictions.product_id IS 'Идентификатор продукта, набора или группы продуктов, учет которых ведем';


--
-- Name: COLUMN cards_wholesale_restrictions.action_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_wholesale_restrictions.action_guid IS 'Идентификатор сработавшей акции';


--
-- Name: COLUMN cards_wholesale_restrictions.quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_wholesale_restrictions.quantity IS 'Количество купленого товара';


--
-- Name: COLUMN cards_wholesale_restrictions.date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_wholesale_restrictions.date IS 'Дата последней синхронизации с сервером или дата последней покупки';


--
-- Name: COLUMN cards_wholesale_restrictions.loy_tx_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.cards_wholesale_restrictions.loy_tx_id IS 'Идентификатор транзакции лояльности';


--
-- Name: card_cardactions card_cardactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cardactions
    ADD CONSTRAINT card_cardactions_pkey PRIMARY KEY (actionid);


--
-- Name: card_cardrange card_cardrange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cardrange
    ADD CONSTRAINT card_cardrange_pkey PRIMARY KEY (id);


--
-- Name: card_cards card_cards_numberfield_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT card_cards_numberfield_key UNIQUE (numberfield);


--
-- Name: card_cards card_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT card_cards_pkey PRIMARY KEY (id);


--
-- Name: card_cardtype card_cardtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cardtype
    ADD CONSTRAINT card_cardtype_pkey PRIMARY KEY (id);


--
-- Name: card_clients card_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_clients
    ADD CONSTRAINT card_clients_pkey PRIMARY KEY (id);


--
-- Name: card_conditionchange card_conditionchange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_conditionchange
    ADD CONSTRAINT card_conditionchange_pkey PRIMARY KEY (id);


--
-- Name: card_coupons card_coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_coupons
    ADD CONSTRAINT card_coupons_pkey PRIMARY KEY (id);


--
-- Name: card_externalcards card_externalcards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_externalcards
    ADD CONSTRAINT card_externalcards_pkey PRIMARY KEY (id);


--
-- Name: card_internalcards card_internalcards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_internalcards
    ADD CONSTRAINT card_internalcards_pkey PRIMARY KEY (id);


--
-- Name: card_presentcards_pending_op card_presentcards_pending_op_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_presentcards_pending_op
    ADD CONSTRAINT card_presentcards_pending_op_pk PRIMARY KEY (id);


--
-- Name: card_presentcards card_presentcards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_presentcards
    ADD CONSTRAINT card_presentcards_pkey PRIMARY KEY (id);


--
-- Name: cards_lastcardid cards_importing_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_lastcardid
    ADD CONSTRAINT cards_importing_history_pkey PRIMARY KEY (id);


--
-- Name: cards_pending_operation cards_pending_operation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_pending_operation
    ADD CONSTRAINT cards_pending_operation_pk PRIMARY KEY (id);


--
-- Name: cards_processing_reports cards_processing_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_processing_reports
    ADD CONSTRAINT cards_processing_reports_pkey PRIMARY KEY (id);


--
-- Name: cards_properties cards_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_properties
    ADD CONSTRAINT cards_properties_pkey PRIMARY KEY (property_key);


--
-- Name: cards_wholesale_restrictions cards_wholesale_restrictions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards_wholesale_restrictions
    ADD CONSTRAINT cards_wholesale_restrictions_pkey PRIMARY KEY (id);


--
-- Name: card_cards_cardtype_id_ndx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX card_cards_cardtype_id_ndx ON public.card_cards USING btree (cardtype_id);


--
-- Name: card_cards_client_id_ndx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX card_cards_client_id_ndx ON public.card_cards USING btree (client_id);


--
-- Name: card_cards_guid_ndx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX card_cards_guid_ndx ON public.card_cards USING btree (guid);


--
-- Name: card_cards_id_cardref_ndx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX card_cards_id_cardref_ndx ON public.card_cards USING btree (id_cardref);


--
-- Name: card_cards_newcardtype_id_ndx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX card_cards_newcardtype_id_ndx ON public.card_cards USING btree (newcardtype_id);


--
-- Name: card_cards_numberfield_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX card_cards_numberfield_idx ON public.card_cards USING btree (numberfield);


--
-- Name: card_clients_guid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX card_clients_guid_idx ON public.card_clients USING btree (guid);


--
-- Name: card_clients_ndx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX card_clients_ndx ON public.card_clients USING btree (guid);


--
-- Name: cards_pending_operation_created_ndx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cards_pending_operation_created_ndx ON public.cards_pending_operation USING btree (created);


--
-- Name: cards_pending_operation_type_ndx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cards_pending_operation_type_ndx ON public.cards_pending_operation USING btree (operation_type);


--
-- Name: cards_wholesale_restrictions_card_number_indx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cards_wholesale_restrictions_card_number_indx ON public.cards_wholesale_restrictions USING btree (card_number);


--
-- Name: card_cardrange fk227b059e85fd630e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cardrange
    ADD CONSTRAINT fk227b059e85fd630e FOREIGN KEY (cardtype_id) REFERENCES public.card_cardtype(id);


--
-- Name: card_coupons fk4a762adefa229cf9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_coupons
    ADD CONSTRAINT fk4a762adefa229cf9 FOREIGN KEY (id) REFERENCES public.card_cardtype(id) ON DELETE CASCADE;


--
-- Name: card_presentcards fk8758b837fa229cf9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_presentcards
    ADD CONSTRAINT fk8758b837fa229cf9 FOREIGN KEY (id) REFERENCES public.card_cardtype(id);


--
-- Name: card_externalcards fk8e54d769fa229cf9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_externalcards
    ADD CONSTRAINT fk8e54d769fa229cf9 FOREIGN KEY (id) REFERENCES public.card_cardtype(id);


--
-- Name: card_cards fkaf56257431d52ce3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT fkaf56257431d52ce3 FOREIGN KEY (id_cardref) REFERENCES public.card_cards(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: card_cards fkaf562574408f756e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT fkaf562574408f756e FOREIGN KEY (newcardtype_id) REFERENCES public.card_cardtype(id);


--
-- Name: card_cards fkaf56257485fd630e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT fkaf56257485fd630e FOREIGN KEY (cardtype_id) REFERENCES public.card_cardtype(id);


--
-- Name: card_cards fkaf562574a8ed2ece; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cards
    ADD CONSTRAINT fkaf562574a8ed2ece FOREIGN KEY (client_id) REFERENCES public.card_clients(id);


--
-- Name: card_cardactions fkf045811e1cc4f66b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_cardactions
    ADD CONSTRAINT fkf045811e1cc4f66b FOREIGN KEY (cardentity_id) REFERENCES public.card_cards(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: card_conditionchange fkf97897cab0b4d5c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_conditionchange
    ADD CONSTRAINT fkf97897cab0b4d5c FOREIGN KEY (cardcategory_id) REFERENCES public.card_internalcards(id);


--
-- Name: card_conditionchange fkf97897ccf8d2fbc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_conditionchange
    ADD CONSTRAINT fkf97897ccf8d2fbc FOREIGN KEY (newcardcategory_id) REFERENCES public.card_internalcards(id);


--
-- Name: card_internalcards fkfb707bb7fa229cf9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.card_internalcards
    ADD CONSTRAINT fkfb707bb7fa229cf9 FOREIGN KEY (id) REFERENCES public.card_cardtype(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

