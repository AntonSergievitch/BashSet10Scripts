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
-- Name: ch_bankcardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_bankcardpayment (
    id bigint NOT NULL,
    amount bigint,
    authcode character varying(255),
    cardnumber character varying(255),
    cardhash character varying(255),
    cardtype character varying(255),
    cashtransid bigint,
    cashtransdate timestamp without time zone,
    hosttransid bigint,
    merchantid character varying(255),
    message character varying(255),
    operationcode bigint,
    refnumber text,
    responsecode character varying(255),
    resultcode bigint,
    status boolean,
    terminalid character varying(255),
    bankid character varying(255) NOT NULL,
    banktype integer
);


ALTER TABLE public.ch_bankcardpayment OWNER TO postgres;

--
-- Name: TABLE ch_bankcardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_bankcardpayment IS 'Чек - Оплаты - Банковская карта';


--
-- Name: COLUMN ch_bankcardpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_bankcardpayment.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.amount IS 'Сумма оплаты';


--
-- Name: COLUMN ch_bankcardpayment.authcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.authcode IS 'Код авторизации';


--
-- Name: COLUMN ch_bankcardpayment.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.cardnumber IS 'Номер карты';


--
-- Name: COLUMN ch_bankcardpayment.cardtype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.cardtype IS 'Тип платежной системы';


--
-- Name: COLUMN ch_bankcardpayment.cashtransid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.cashtransid IS 'Номер транзакции';


--
-- Name: COLUMN ch_bankcardpayment.cashtransdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.cashtransdate IS 'Временная метка транзакции';


--
-- Name: COLUMN ch_bankcardpayment.hosttransid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.hosttransid IS 'Уникальный индентификатор транзакции коммуникационного сервера (используется при серверной авторизации)';


--
-- Name: COLUMN ch_bankcardpayment.merchantid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.merchantid IS 'Номер точки обслуживания';


--
-- Name: COLUMN ch_bankcardpayment.message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.message IS 'Ответ процессинга';


--
-- Name: COLUMN ch_bankcardpayment.operationcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.operationcode IS 'Код операции';


--
-- Name: COLUMN ch_bankcardpayment.refnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.refnumber IS 'Ссылка на номер транзакции коммуникационного сервера (используется при серверной авторизации)';


--
-- Name: COLUMN ch_bankcardpayment.responsecode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.responsecode IS 'Код ответа процессинга';


--
-- Name: COLUMN ch_bankcardpayment.resultcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.resultcode IS 'Код ответа авторизационного сервера (используется при серверной авторизации)';


--
-- Name: COLUMN ch_bankcardpayment.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.status IS 'Статус';


--
-- Name: COLUMN ch_bankcardpayment.terminalid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.terminalid IS 'Номер терминала';


--
-- Name: COLUMN ch_bankcardpayment.bankid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.bankid IS 'Код банка';


--
-- Name: COLUMN ch_bankcardpayment.banktype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment.banktype IS 'Перечисление некоторых типов банков: 0 - неизвестен, 1 - Сбербанк, ...';


--
-- Name: ch_bankcardpayment_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_bankcardpayment_transaction (
    id bigint NOT NULL,
    authcode character varying(255),
    cardnumber character varying(255),
    cardhash character varying(255),
    cardtype character varying(255),
    cashtransid bigint,
    cashtransdate timestamp without time zone,
    hosttransid bigint,
    merchantid character varying(255),
    message character varying(255),
    operationcode bigint,
    refnumber text,
    responsecode character varying(255),
    currency character varying(32),
    resultcode bigint,
    status boolean,
    terminalid character varying(255),
    bankid character varying(255) NOT NULL,
    banktype integer
);


ALTER TABLE public.ch_bankcardpayment_transaction OWNER TO postgres;

--
-- Name: TABLE ch_bankcardpayment_transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_bankcardpayment_transaction IS 'Чек - Оплаты - Банковская карта - Транзакции';


--
-- Name: COLUMN ch_bankcardpayment_transaction.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.id IS 'Первичный ключ';


--
-- Name: COLUMN ch_bankcardpayment_transaction.authcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.authcode IS 'Код авторизации';


--
-- Name: COLUMN ch_bankcardpayment_transaction.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.cardnumber IS 'Номер карты';


--
-- Name: COLUMN ch_bankcardpayment_transaction.cardhash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.cardhash IS 'cardHash';


--
-- Name: COLUMN ch_bankcardpayment_transaction.cardtype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.cardtype IS 'Тип платежной системы';


--
-- Name: COLUMN ch_bankcardpayment_transaction.cashtransid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.cashtransid IS 'Номер транзакции';


--
-- Name: COLUMN ch_bankcardpayment_transaction.cashtransdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.cashtransdate IS 'Временная метка транзакции';


--
-- Name: COLUMN ch_bankcardpayment_transaction.hosttransid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.hosttransid IS 'Уникальный индентификатор транзакции коммуникационного сервера (используется при серверной авторизации)';


--
-- Name: COLUMN ch_bankcardpayment_transaction.merchantid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.merchantid IS 'Номер точки обслуживания';


--
-- Name: COLUMN ch_bankcardpayment_transaction.message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.message IS 'Ответ процессинга';


--
-- Name: COLUMN ch_bankcardpayment_transaction.operationcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.operationcode IS 'Код операции';


--
-- Name: COLUMN ch_bankcardpayment_transaction.refnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.refnumber IS 'Ссылка на номер транзакции коммуникационного сервера (используется при серверной авторизации)';


--
-- Name: COLUMN ch_bankcardpayment_transaction.responsecode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.responsecode IS 'Код ответа процессинга';


--
-- Name: COLUMN ch_bankcardpayment_transaction.currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.currency IS 'валюта оплаты';


--
-- Name: COLUMN ch_bankcardpayment_transaction.resultcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.resultcode IS 'Код ответа авторизационного сервера (используется при серверной авторизации)';


--
-- Name: COLUMN ch_bankcardpayment_transaction.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.status IS 'Статус';


--
-- Name: COLUMN ch_bankcardpayment_transaction.terminalid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.terminalid IS 'Номер терминала';


--
-- Name: COLUMN ch_bankcardpayment_transaction.bankid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.bankid IS 'Код банка';


--
-- Name: COLUMN ch_bankcardpayment_transaction.banktype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bankcardpayment_transaction.banktype IS 'Перечисление некоторых типов банков: 0 - неизвестен, 1 - Сбербанк, ...';


--
-- Name: ch_bonuscardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_bonuscardpayment (
    id bigint NOT NULL,
    accountid bigint,
    accounttype integer,
    cancelbonuses integer,
    cardnumber character varying(255),
    authcode character varying(255)
);


ALTER TABLE public.ch_bonuscardpayment OWNER TO postgres;

--
-- Name: TABLE ch_bonuscardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_bonuscardpayment IS 'Чек - Оплаты - Бонусы';


--
-- Name: COLUMN ch_bonuscardpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonuscardpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_bonuscardpayment.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonuscardpayment.cardnumber IS 'Номер карты';


--
-- Name: COLUMN ch_bonuscardpayment.authcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonuscardpayment.authcode IS 'Код авторизации используется процессингом Informix';


--
-- Name: ch_bonussberbankpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_bonussberbankpayment (
    id bigint NOT NULL,
    cardnumber character varying(255) NOT NULL,
    transactionid character varying(255),
    terminalid character varying(255),
    partnerid character varying(255),
    clientid character varying(255),
    clientidtype integer,
    datetime character varying(255),
    location character varying(255),
    accountbonuses bigint
);


ALTER TABLE public.ch_bonussberbankpayment OWNER TO postgres;

--
-- Name: TABLE ch_bonussberbankpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_bonussberbankpayment IS 'Оплаты типа "Спасибо от Сбербанка" (ODBonusSberbankPaymentEntity)';


--
-- Name: COLUMN ch_bonussberbankpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonussberbankpayment.id IS 'Первичный ключ';


--
-- Name: COLUMN ch_bonussberbankpayment.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonussberbankpayment.cardnumber IS 'Номер карты';


--
-- Name: COLUMN ch_bonussberbankpayment.transactionid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonussberbankpayment.transactionid IS 'Уникальный номер транзакции на стороне кассы';


--
-- Name: COLUMN ch_bonussberbankpayment.terminalid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonussberbankpayment.terminalid IS 'Идентификатор внешнего устройства';


--
-- Name: COLUMN ch_bonussberbankpayment.partnerid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonussberbankpayment.partnerid IS 'Код банка';


--
-- Name: COLUMN ch_bonussberbankpayment.accountbonuses; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_bonussberbankpayment.accountbonuses IS 'Остаток бонусов на счете после оплаты ';


--
-- Name: ch_cashpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_cashpayment (
    id bigint NOT NULL,
    changecash bigint
);


ALTER TABLE public.ch_cashpayment OWNER TO postgres;

--
-- Name: TABLE ch_cashpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_cashpayment IS 'Чек - Оплаты - Наличные';


--
-- Name: COLUMN ch_cashpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cashpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_cashpayment.changecash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cashpayment.changecash IS 'Сумма сдачи';


--
-- Name: ch_cft_giftcardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_cft_giftcardpayment (
    id bigint NOT NULL,
    clientid character varying(128),
    clientidtype integer,
    balance bigint,
    terminal character varying(100),
    location character varying(50),
    partnerid character varying(18),
    datetime_act timestamp without time zone,
    datetime_deact timestamp without time zone,
    id_trans_act character varying(50),
    id_trans_deact character varying(50),
    slip_act character varying(4096),
    slip_deact character varying(4096),
    online_deact boolean
);


ALTER TABLE public.ch_cft_giftcardpayment OWNER TO postgres;

--
-- Name: TABLE ch_cft_giftcardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_cft_giftcardpayment IS 'Тип оплаты: подарочная карта ЦФТ';


--
-- Name: COLUMN ch_cft_giftcardpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.id IS 'Идентификатор товарной позиции';


--
-- Name: COLUMN ch_cft_giftcardpayment.clientid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.clientid IS 'Номер подарочной карты (хеш, трек, штрихкод или номер)';


--
-- Name: COLUMN ch_cft_giftcardpayment.clientidtype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.clientidtype IS 'Тип данных в clientID';


--
-- Name: COLUMN ch_cft_giftcardpayment.balance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.balance IS 'Остаток на счете карты';


--
-- Name: COLUMN ch_cft_giftcardpayment.terminal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.terminal IS 'Идентификатор кассы (POS)';


--
-- Name: COLUMN ch_cft_giftcardpayment.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.location IS 'Код места установки кассы';


--
-- Name: COLUMN ch_cft_giftcardpayment.partnerid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.partnerid IS 'Идентификатор участника';


--
-- Name: COLUMN ch_cft_giftcardpayment.datetime_act; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.datetime_act IS 'Время выполнения операции активации';


--
-- Name: COLUMN ch_cft_giftcardpayment.datetime_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.datetime_deact IS 'Время выполнения операции деактивации';


--
-- Name: COLUMN ch_cft_giftcardpayment.id_trans_act; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.id_trans_act IS 'Идентификатор транзакции ЦФТ';


--
-- Name: COLUMN ch_cft_giftcardpayment.id_trans_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.id_trans_deact IS 'Идентификатор транзакции деактивации ЦФТ';


--
-- Name: COLUMN ch_cft_giftcardpayment.slip_act; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.slip_act IS 'Слип активации ЦФТ';


--
-- Name: COLUMN ch_cft_giftcardpayment.slip_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.slip_deact IS 'Слип деактивации ЦФТ';


--
-- Name: COLUMN ch_cft_giftcardpayment.online_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftcardpayment.online_deact IS 'Признак онлайн/оффлайн отмены оплаты';


--
-- Name: ch_cft_giftegcpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_cft_giftegcpayment (
    id bigint NOT NULL,
    clientid character varying(128),
    clientidtype integer,
    balance bigint,
    activationtransactionid character varying(50),
    deactivationtransactionid character varying(50),
    terminal character varying(100),
    location character varying(50),
    partnerid character varying(18),
    activationdatetime timestamp without time zone,
    deactivationdatetime timestamp without time zone,
    activationslip character varying(4096),
    deactivationslip character varying(4096),
    online_deact boolean
);


ALTER TABLE public.ch_cft_giftegcpayment OWNER TO postgres;

--
-- Name: TABLE ch_cft_giftegcpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_cft_giftegcpayment IS 'Сущность, описывающая оплату по ЭПС ЦФТ';


--
-- Name: COLUMN ch_cft_giftegcpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.id IS 'Идентификатор';


--
-- Name: COLUMN ch_cft_giftegcpayment.clientid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.clientid IS 'Номер ЭПС (хеш, трек, штрихкод или номер)';


--
-- Name: COLUMN ch_cft_giftegcpayment.clientidtype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.clientidtype IS 'Тип данных в clientID';


--
-- Name: COLUMN ch_cft_giftegcpayment.balance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.balance IS 'Остаток на счете карты';


--
-- Name: COLUMN ch_cft_giftegcpayment.activationtransactionid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.activationtransactionid IS 'ЦФТ-идентификатор операции оплаты';


--
-- Name: COLUMN ch_cft_giftegcpayment.deactivationtransactionid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.deactivationtransactionid IS 'ЦФТ-идентификатор операции отмены оплаты';


--
-- Name: COLUMN ch_cft_giftegcpayment.terminal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.terminal IS 'Идентификатор кассы (POS)';


--
-- Name: COLUMN ch_cft_giftegcpayment.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.location IS 'Код места установки кассы';


--
-- Name: COLUMN ch_cft_giftegcpayment.partnerid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.partnerid IS 'Идентификатор участника';


--
-- Name: COLUMN ch_cft_giftegcpayment.activationdatetime; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.activationdatetime IS 'Время выполнения ЦФТ-операции оплаты';


--
-- Name: COLUMN ch_cft_giftegcpayment.deactivationdatetime; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.deactivationdatetime IS 'Время выполнения ЦФТ-операции отмены оплаты';


--
-- Name: COLUMN ch_cft_giftegcpayment.activationslip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.activationslip IS 'Слип ЦФТ-операции оплаты';


--
-- Name: COLUMN ch_cft_giftegcpayment.deactivationslip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.deactivationslip IS 'Слип ЦФТ-операции отмены оплаты';


--
-- Name: COLUMN ch_cft_giftegcpayment.online_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_cft_giftegcpayment.online_deact IS 'Признак оффлайн точки при выполнении ЦФТ-операции';


--
-- Name: ch_childrencardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_childrencardpayment (
    id bigint NOT NULL
);


ALTER TABLE public.ch_childrencardpayment OWNER TO postgres;

--
-- Name: TABLE ch_childrencardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_childrencardpayment IS 'Чек - Оплаты - Детская карта';


--
-- Name: COLUMN ch_childrencardpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_childrencardpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: ch_correctionreceipt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_correctionreceipt (
    id bigint NOT NULL,
    datecommit timestamp without time zone,
    datecreate timestamp without time zone,
    fiscaldocnum character varying(64),
    numberfield bigint,
    kpk bigint,
    spnd bigint,
    senttoserverstatus integer,
    filename character varying(255),
    id_session bigint NOT NULL,
    id_shift bigint,
    reason text,
    reasondocnumber character varying(32),
    reasondocdate timestamp without time zone,
    correctiontype text,
    accountsign text,
    inn character varying(255),
    taxsystem text
);


ALTER TABLE public.ch_correctionreceipt OWNER TO postgres;

--
-- Name: TABLE ch_correctionreceipt; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_correctionreceipt IS 'Чек коррекции';


--
-- Name: COLUMN ch_correctionreceipt.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.id IS 'Идентификатор документа';


--
-- Name: COLUMN ch_correctionreceipt.datecommit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.datecommit IS 'Временная метка регистрации документа';


--
-- Name: COLUMN ch_correctionreceipt.datecreate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.datecreate IS 'Временная метка создания документа';


--
-- Name: COLUMN ch_correctionreceipt.fiscaldocnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.fiscaldocnum IS 'Номер фискального документа';


--
-- Name: COLUMN ch_correctionreceipt.numberfield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.numberfield IS 'Номер чека';


--
-- Name: COLUMN ch_correctionreceipt.kpk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.kpk IS 'номер КПК (или порядковый номер если это нефискальный документ)';


--
-- Name: COLUMN ch_correctionreceipt.spnd; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.spnd IS 'номер СПНД';


--
-- Name: COLUMN ch_correctionreceipt.senttoserverstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.senttoserverstatus IS 'Статус оправки на сервер';


--
-- Name: COLUMN ch_correctionreceipt.filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.filename IS 'Имя файла выгрузки';


--
-- Name: COLUMN ch_correctionreceipt.id_session; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.id_session IS 'Идентификатор сессии';


--
-- Name: COLUMN ch_correctionreceipt.id_shift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.id_shift IS 'Идентификатор смены';


--
-- Name: COLUMN ch_correctionreceipt.reason; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.reason IS 'Основание для коррекции';


--
-- Name: COLUMN ch_correctionreceipt.reasondocnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.reasondocnumber IS 'Номер документа основания';


--
-- Name: COLUMN ch_correctionreceipt.reasondocdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.reasondocdate IS 'Дата документа основания';


--
-- Name: COLUMN ch_correctionreceipt.correctiontype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.correctiontype IS 'Тип коррекции';


--
-- Name: COLUMN ch_correctionreceipt.accountsign; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.accountsign IS 'Признак расчета';


--
-- Name: COLUMN ch_correctionreceipt.inn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.inn IS 'ИНН';


--
-- Name: COLUMN ch_correctionreceipt.taxsystem; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt.taxsystem IS 'Система налогооблажения';


--
-- Name: ch_correctionreceipt_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_correctionreceipt_payments (
    id_correction bigint NOT NULL,
    paymentname text NOT NULL,
    paymentsum bigint NOT NULL
);


ALTER TABLE public.ch_correctionreceipt_payments OWNER TO postgres;

--
-- Name: TABLE ch_correctionreceipt_payments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_correctionreceipt_payments IS 'Чек коррекции - Оплаты';


--
-- Name: COLUMN ch_correctionreceipt_payments.id_correction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt_payments.id_correction IS 'Ссылка на сущность чека коррекции';


--
-- Name: COLUMN ch_correctionreceipt_payments.paymentname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt_payments.paymentname IS 'Наименование типа оплаты';


--
-- Name: COLUMN ch_correctionreceipt_payments.paymentsum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt_payments.paymentsum IS 'Сумма оплаты';


--
-- Name: ch_correctionreceipt_taxes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_correctionreceipt_taxes (
    id_correction bigint NOT NULL,
    tax text NOT NULL,
    taxsum bigint NOT NULL
);


ALTER TABLE public.ch_correctionreceipt_taxes OWNER TO postgres;

--
-- Name: TABLE ch_correctionreceipt_taxes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_correctionreceipt_taxes IS 'Чек коррекции - Налоги';


--
-- Name: COLUMN ch_correctionreceipt_taxes.id_correction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt_taxes.id_correction IS 'Ссылка на сущность чека коррекции';


--
-- Name: COLUMN ch_correctionreceipt_taxes.tax; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt_taxes.tax IS 'Ставка НДС';


--
-- Name: COLUMN ch_correctionreceipt_taxes.taxsum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_correctionreceipt_taxes.taxsum IS 'Сумма налога';


--
-- Name: ch_egais_undispatched_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_egais_undispatched_data (
    id bigint NOT NULL,
    date date,
    data character varying(5000)
);


ALTER TABLE public.ch_egais_undispatched_data OWNER TO postgres;

--
-- Name: TABLE ch_egais_undispatched_data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_egais_undispatched_data IS 'Неотправленные данные в УТМ ЕГАИС';


--
-- Name: ch_externalbankterminalpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_externalbankterminalpayment (
    id bigint NOT NULL,
    authcode character varying(100),
    cardnum character varying(20),
    checknumber bigint
);


ALTER TABLE public.ch_externalbankterminalpayment OWNER TO postgres;

--
-- Name: TABLE ch_externalbankterminalpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_externalbankterminalpayment IS 'Чек - Оплаты - Банковская карта - Внешний банковский терминал';


--
-- Name: COLUMN ch_externalbankterminalpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_externalbankterminalpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_externalbankterminalpayment.authcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_externalbankterminalpayment.authcode IS 'Код авторизации';


--
-- Name: COLUMN ch_externalbankterminalpayment.cardnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_externalbankterminalpayment.cardnum IS 'Маскированый номер карты (max 20 символов)';


--
-- Name: COLUMN ch_externalbankterminalpayment.checknumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_externalbankterminalpayment.checknumber IS 'Номер чека банковского терминала';


--
-- Name: ch_fictivecashinout; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_fictivecashinout (
    cashout_date timestamp without time zone NOT NULL,
    casher text NOT NULL,
    summ bigint,
    id bigint NOT NULL
);


ALTER TABLE public.ch_fictivecashinout OWNER TO postgres;

--
-- Name: TABLE ch_fictivecashinout; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_fictivecashinout IS 'Информация по фиктивным изъятиям из ФР и внесениям в него для выравнивания счётчиков наличных у кешмашины и ФР(для округления по ФЗ 54)';


--
-- Name: COLUMN ch_fictivecashinout.cashout_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_fictivecashinout.cashout_date IS 'дата';


--
-- Name: COLUMN ch_fictivecashinout.casher; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_fictivecashinout.casher IS 'пользователь';


--
-- Name: COLUMN ch_fictivecashinout.summ; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_fictivecashinout.summ IS 'сумма в копейках';


--
-- Name: ch_fictivecashinout_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ch_fictivecashinout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ch_fictivecashinout_id_seq OWNER TO postgres;

--
-- Name: ch_fictivecashinout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ch_fictivecashinout_id_seq OWNED BY public.ch_fictivecashinout.id;


--
-- Name: ch_giftcardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_giftcardpayment (
    id bigint NOT NULL,
    amountcard bigint,
    cardnumber character varying(255)
);


ALTER TABLE public.ch_giftcardpayment OWNER TO postgres;

--
-- Name: TABLE ch_giftcardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_giftcardpayment IS 'Чек - Оплаты - Подарочная карта';


--
-- Name: COLUMN ch_giftcardpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_giftcardpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_giftcardpayment.amountcard; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_giftcardpayment.amountcard IS 'Номинал карты';


--
-- Name: COLUMN ch_giftcardpayment.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_giftcardpayment.cardnumber IS 'Номер карты';


--
-- Name: ch_internalcreditcardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_internalcreditcardpayment (
    id bigint NOT NULL,
    cardnumber character varying(255)
);


ALTER TABLE public.ch_internalcreditcardpayment OWNER TO postgres;

--
-- Name: TABLE ch_internalcreditcardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_internalcreditcardpayment IS 'Оплата кредитной картой';


--
-- Name: COLUMN ch_internalcreditcardpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_internalcreditcardpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_internalcreditcardpayment.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_internalcreditcardpayment.cardnumber IS 'Номер карты';


--
-- Name: ch_introduction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_introduction (
    id bigint NOT NULL,
    datecommit timestamp without time zone,
    datecreate timestamp without time zone,
    fiscaldocnum character varying(64),
    numberfield bigint,
    senttoserverstatus integer,
    id_session bigint,
    id_shift bigint,
    id_basecurrency character varying(3),
    id_currency character varying(3),
    value bigint,
    was_before bigint,
    valuebasecurrency bigint,
    kpk bigint,
    spnd bigint,
    filename character varying(255)
);


ALTER TABLE public.ch_introduction OWNER TO postgres;

--
-- Name: TABLE ch_introduction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_introduction IS 'Внесение денег';


--
-- Name: COLUMN ch_introduction.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.id IS 'Идентификатор внесения';


--
-- Name: COLUMN ch_introduction.datecommit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.datecommit IS 'Временная метка регитрации документа';


--
-- Name: COLUMN ch_introduction.datecreate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.datecreate IS 'Временная метка созлдания документа';


--
-- Name: COLUMN ch_introduction.fiscaldocnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.fiscaldocnum IS 'Номер фискального документа';


--
-- Name: COLUMN ch_introduction.numberfield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.numberfield IS 'Номер чека';


--
-- Name: COLUMN ch_introduction.senttoserverstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.senttoserverstatus IS 'Статус отправки на сервер';


--
-- Name: COLUMN ch_introduction.id_session; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.id_session IS 'Идентификатор сессии';


--
-- Name: COLUMN ch_introduction.id_shift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.id_shift IS 'Идентификатор смены';


--
-- Name: COLUMN ch_introduction.id_basecurrency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.id_basecurrency IS 'Идентификатор основной валюты';


--
-- Name: COLUMN ch_introduction.id_currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.id_currency IS 'Идентификатор валюты внесения';


--
-- Name: COLUMN ch_introduction.value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.value IS 'Сумма в валюте внесения';


--
-- Name: COLUMN ch_introduction.was_before; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.was_before IS 'Сумма в кассе до внесения';


--
-- Name: COLUMN ch_introduction.valuebasecurrency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.valuebasecurrency IS 'Сумма в базовой валюте';


--
-- Name: COLUMN ch_introduction.kpk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.kpk IS 'номер КПК (или порядковый номер если это нефискальный документ)';


--
-- Name: COLUMN ch_introduction.spnd; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.spnd IS 'номер СПНД';


--
-- Name: COLUMN ch_introduction.filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_introduction.filename IS 'Имя файла выгрузки';


--
-- Name: ch_inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_inventory (
    id bigint NOT NULL,
    banknotevalue bigint,
    count bigint,
    id_withdrawal bigint
);


ALTER TABLE public.ch_inventory OWNER TO postgres;

--
-- Name: TABLE ch_inventory; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_inventory IS 'Изъятие денег - покупюрная опись';


--
-- Name: COLUMN ch_inventory.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_inventory.id IS 'Идентификатор описи';


--
-- Name: COLUMN ch_inventory.banknotevalue; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_inventory.banknotevalue IS 'Идентификатор банкноты';


--
-- Name: COLUMN ch_inventory.count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_inventory.count IS 'Количество';


--
-- Name: COLUMN ch_inventory.id_withdrawal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_inventory.id_withdrawal IS 'Идентификатор изъятия';


--
-- Name: ch_kopilkabonuscardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_kopilkabonuscardpayment (
    id bigint NOT NULL,
    authcode text,
    cardnumber text,
    cardnumberhash text
);


ALTER TABLE public.ch_kopilkabonuscardpayment OWNER TO postgres;

--
-- Name: TABLE ch_kopilkabonuscardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_kopilkabonuscardpayment IS 'Чек - Оплаты - Бонусы Копилка';


--
-- Name: COLUMN ch_kopilkabonuscardpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_kopilkabonuscardpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_kopilkabonuscardpayment.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_kopilkabonuscardpayment.cardnumber IS 'Номер карты';


--
-- Name: ch_manual_position_adv_action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_manual_position_adv_action (
    id bigint NOT NULL,
    actionguid bigint NOT NULL,
    actionname character varying(255),
    qnty bigint NOT NULL,
    id_position bigint NOT NULL
);


ALTER TABLE public.ch_manual_position_adv_action OWNER TO postgres;

--
-- Name: TABLE ch_manual_position_adv_action; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_manual_position_adv_action IS 'Чек - Ручные рекламные акции';


--
-- Name: COLUMN ch_manual_position_adv_action.actionguid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_manual_position_adv_action.actionguid IS 'Guid рекламной акции';


--
-- Name: ch_message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_message (
    id bigint NOT NULL,
    data text
);


ALTER TABLE public.ch_message OWNER TO postgres;

--
-- Name: TABLE ch_message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_message IS 'Технические сообщения кассы в формате JSON';


--
-- Name: COLUMN ch_message.data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_message.data IS 'Сообщение в формате JSON';


--
-- Name: ch_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_payment (
    id bigint NOT NULL,
    id_basecurrency character varying(3),
    id_currency character varying(3),
    datecommit timestamp without time zone,
    datecreate timestamp without time zone,
    numberfield bigint,
    paymentstatus character(1),
    paymenttype character varying(40),
    sumpay bigint,
    sumpaybasecurrency bigint,
    id_purchase bigint,
    successprocessed boolean NOT NULL,
    originalpaymentnumber bigint
);


ALTER TABLE public.ch_payment OWNER TO postgres;

--
-- Name: TABLE ch_payment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_payment IS 'Чек - Оплаты';


--
-- Name: COLUMN ch_payment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_payment.id_basecurrency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.id_basecurrency IS 'Идентификатор основной валюты';


--
-- Name: COLUMN ch_payment.id_currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.id_currency IS 'Идентификатор валюты оплаты';


--
-- Name: COLUMN ch_payment.datecommit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.datecommit IS 'Временная метка завершения заведения оплаты';


--
-- Name: COLUMN ch_payment.datecreate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.datecreate IS 'Временная метка начала заведения оплаты';


--
-- Name: COLUMN ch_payment.numberfield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.numberfield IS 'Номер оплатной позиции';


--
-- Name: COLUMN ch_payment.paymentstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.paymentstatus IS 'Статус оплаты';


--
-- Name: COLUMN ch_payment.paymenttype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.paymenttype IS 'Тип оплаты';


--
-- Name: COLUMN ch_payment.sumpay; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.sumpay IS 'Сумма оплаты в валюте оплаты';


--
-- Name: COLUMN ch_payment.sumpaybasecurrency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.sumpaybasecurrency IS 'Сумма оплаты в основной валюте';


--
-- Name: COLUMN ch_payment.id_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.id_purchase IS 'Идентификатор чека';


--
-- Name: COLUMN ch_payment.successprocessed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment.successprocessed IS '???????';


--
-- Name: payment_property_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_property_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_property_sequence OWNER TO postgres;

--
-- Name: ch_payment_property; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_payment_property (
    id bigint DEFAULT nextval('public.payment_property_sequence'::regclass) NOT NULL,
    payment_id bigint NOT NULL,
    name_id bigint,
    prop_value text
);


ALTER TABLE public.ch_payment_property OWNER TO postgres;

--
-- Name: TABLE ch_payment_property; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_payment_property IS 'Дополнительные параметры оплат';


--
-- Name: COLUMN ch_payment_property.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_property.id IS 'Идентификатор параметра оплаты';


--
-- Name: COLUMN ch_payment_property.payment_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_property.payment_id IS 'Ссылка на сущность оплаты';


--
-- Name: COLUMN ch_payment_property.name_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_property.name_id IS 'Ссылка на справочник имен';


--
-- Name: COLUMN ch_payment_property.prop_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_property.prop_value IS 'Значение параметра';


--
-- Name: ch_payment_property_name; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_payment_property_name (
    id bigint DEFAULT nextval('public.payment_property_sequence'::regclass) NOT NULL,
    prop_name text NOT NULL
);


ALTER TABLE public.ch_payment_property_name OWNER TO postgres;

--
-- Name: TABLE ch_payment_property_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_payment_property_name IS 'Справочник имен дополнительных параметров оплат';


--
-- Name: COLUMN ch_payment_property_name.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_property_name.id IS 'Идентификатор имени';


--
-- Name: COLUMN ch_payment_property_name.prop_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_property_name.prop_name IS 'Имя дополнительного параметра';


--
-- Name: ch_payment_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_payment_transaction (
    id bigint NOT NULL,
    cash_num bigint,
    discriminator character varying(32),
    create_time timestamp without time zone,
    sumpay bigint NOT NULL,
    senttoserverstatus integer,
    filename character varying(255),
    id_purchase bigint,
    id_payment bigint,
    num_shift bigint NOT NULL,
    cash_guid bigint NOT NULL,
    shop_index bigint NOT NULL,
    annulling boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ch_payment_transaction OWNER TO postgres;

--
-- Name: TABLE ch_payment_transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_payment_transaction IS 'Транзакия оплаты по банковскому терминалу';


--
-- Name: COLUMN ch_payment_transaction.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.id IS 'Идентификатор транзакции оплаты';


--
-- Name: COLUMN ch_payment_transaction.cash_num; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.cash_num IS 'Номер кассы';


--
-- Name: COLUMN ch_payment_transaction.discriminator; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.discriminator IS 'Тип транзакции';


--
-- Name: COLUMN ch_payment_transaction.create_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.create_time IS 'Время создания';


--
-- Name: COLUMN ch_payment_transaction.sumpay; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.sumpay IS 'Сумма оплаты в валюте оплаты';


--
-- Name: COLUMN ch_payment_transaction.senttoserverstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.senttoserverstatus IS 'Статус отправки на сервер';


--
-- Name: COLUMN ch_payment_transaction.filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.filename IS 'Имя файла для отправки на сервер';


--
-- Name: COLUMN ch_payment_transaction.id_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.id_purchase IS 'Ссылка на чек если есть';


--
-- Name: COLUMN ch_payment_transaction.id_payment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.id_payment IS 'Ссылка на оплату если есть';


--
-- Name: COLUMN ch_payment_transaction.num_shift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.num_shift IS 'Номер смены в которой создана транзакция';


--
-- Name: COLUMN ch_payment_transaction.cash_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.cash_guid IS 'GUID транзакции сформированный на кассе на основе time';


--
-- Name: COLUMN ch_payment_transaction.shop_index; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.shop_index IS 'Номер магазина';


--
-- Name: COLUMN ch_payment_transaction.annulling; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction.annulling IS 'Транзакция отмены оплаты?';


--
-- Name: ch_payment_transaction_slip; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_payment_transaction_slip (
    payment_transaction_id bigint NOT NULL,
    number integer NOT NULL,
    text_data text NOT NULL
);


ALTER TABLE public.ch_payment_transaction_slip OWNER TO postgres;

--
-- Name: TABLE ch_payment_transaction_slip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_payment_transaction_slip IS 'Копия слипа банковского теримнала';


--
-- Name: COLUMN ch_payment_transaction_slip.payment_transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction_slip.payment_transaction_id IS 'id банковской оплаты';


--
-- Name: COLUMN ch_payment_transaction_slip.number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction_slip.number IS 'номер транзакции в оплате';


--
-- Name: COLUMN ch_payment_transaction_slip.text_data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_payment_transaction_slip.text_data IS 'текст слипа полученный в ходе транзакции';


--
-- Name: ch_position; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position (
    id bigint NOT NULL,
    barcode character varying(30),
    calculatediscount boolean,
    datecommit timestamp without time zone,
    deleted boolean,
    departnumber bigint,
    inserttype integer,
    item character varying(30),
    measure_code character varying(255) NOT NULL,
    name character varying(255),
    nds real,
    ndsclass character varying(3),
    ndssum bigint,
    numberfield bigint DEFAULT 1 NOT NULL,
    priceend bigint,
    pricestart bigint,
    product_type character varying(32),
    qnty bigint,
    "precision" double precision NOT NULL,
    successprocessed boolean NOT NULL,
    sumfield bigint,
    sumdiscount bigint DEFAULT 0 NOT NULL,
    typepricenumber integer,
    number_in_original bigint,
    soft_check_number character varying(255),
    id_purchase bigint,
    category_mask smallint NOT NULL,
    erpcode character varying(255),
    can_change_qnty boolean DEFAULT true NOT NULL,
    before_manual_price bigint,
    barcodetype character varying(20),
    goodsfeature character varying,
    seller bigint,
    minimal_price_alarm character varying(20),
    return_restricted boolean,
    collapsible boolean DEFAULT true NOT NULL,
    fixed_price boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ch_position OWNER TO postgres;

--
-- Name: TABLE ch_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position IS 'Чек - Товарные позиции';


--
-- Name: COLUMN ch_position.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.id IS 'Идентификатор позиции';


--
-- Name: COLUMN ch_position.barcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.barcode IS 'Штриховой код';


--
-- Name: COLUMN ch_position.calculatediscount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.calculatediscount IS 'Признак участия в расчете скидок: true - учавствует в расчете скидок; false - не учавствует в расчете скидок';


--
-- Name: COLUMN ch_position.datecommit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.datecommit IS 'Временная метка заведения пощиции';


--
-- Name: COLUMN ch_position.deleted; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.deleted IS 'Признак удаленности позиции';


--
-- Name: COLUMN ch_position.departnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.departnumber IS 'Код отдела';


--
-- Name: COLUMN ch_position.inserttype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.inserttype IS 'Спосооб добавления позиции';


--
-- Name: COLUMN ch_position.item; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.item IS 'Код товара';


--
-- Name: COLUMN ch_position.measure_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.measure_code IS 'Код единицы измерения';


--
-- Name: COLUMN ch_position.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.name IS 'Наименование товара';


--
-- Name: COLUMN ch_position.nds; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.nds IS 'Ставка НДС';


--
-- Name: COLUMN ch_position.ndsclass; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.ndsclass IS 'Класс НДС';


--
-- Name: COLUMN ch_position.ndssum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.ndssum IS 'Сумма НДС';


--
-- Name: COLUMN ch_position.numberfield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.numberfield IS 'Номер позиции';


--
-- Name: COLUMN ch_position.priceend; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.priceend IS 'Цена после расчета скидок';


--
-- Name: COLUMN ch_position.pricestart; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.pricestart IS 'Цена до расчета скидок';


--
-- Name: COLUMN ch_position.product_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.product_type IS 'Тип товара';


--
-- Name: COLUMN ch_position.qnty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.qnty IS 'Количество товара';


--
-- Name: COLUMN ch_position.successprocessed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.successprocessed IS '??????';


--
-- Name: COLUMN ch_position.sumfield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.sumfield IS 'Сумма';


--
-- Name: COLUMN ch_position.sumdiscount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.sumdiscount IS 'Сумма скидок на эту позицию, копеек';


--
-- Name: COLUMN ch_position.typepricenumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.typepricenumber IS '??????';


--
-- Name: COLUMN ch_position.number_in_original; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.number_in_original IS 'только для чеков возврата: содержит номер позиции в оригинальном чеке, которую возвращаем... ЭТОЙ позицией в ЭТОМ ВОЗВРАТНОМ чеке';


--
-- Name: COLUMN ch_position.soft_check_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.soft_check_number IS 'Номер мягкого чека из которого была добавлена позиция';


--
-- Name: COLUMN ch_position.id_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.id_purchase IS 'Идентификатор чека';


--
-- Name: COLUMN ch_position.category_mask; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.category_mask IS 'Маска, содержащая признак принадлежности товара к каким-либо типам, например бит 1 - детский товар, 2 - запрет печати информации о товаре в документах';


--
-- Name: COLUMN ch_position.erpcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.erpcode IS 'ERP код товара';


--
-- Name: COLUMN ch_position.can_change_qnty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.can_change_qnty IS 'Признак возможности изменять количество товара в позиции';


--
-- Name: COLUMN ch_position.before_manual_price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.before_manual_price IS 'В случае ручного редактирования цены ставим сюда старую цену';


--
-- Name: COLUMN ch_position.barcodetype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.barcodetype IS 'Признак штрихкода товара(GTIN)';


--
-- Name: COLUMN ch_position.goodsfeature; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.goodsfeature IS 'Признак товара (услуга - service)';


--
-- Name: COLUMN ch_position.seller; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.seller IS 'Продавец данной позиции';


--
-- Name: COLUMN ch_position.minimal_price_alarm; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.minimal_price_alarm IS 'Тип предупреждения о нарушениях МРЦ для последующей отправки сообщений через CashMessageERPI';


--
-- Name: COLUMN ch_position.return_restricted; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position.return_restricted IS 'Флаг, определяющий, запрещено ли возвращать позицию.';


--
-- Name: ch_position_cft_giftcard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_cft_giftcard (
    id bigint NOT NULL,
    clientid character varying(128),
    clientidtype integer,
    amount bigint,
    terminal character varying(100),
    location character varying(50),
    partnerid character varying(18),
    datetime_act timestamp without time zone,
    datetime_deact timestamp without time zone,
    id_trans_act character varying(50),
    id_trans_deact character varying(50),
    slip_act character varying(4096),
    slip_deact character varying(4096),
    online_deact boolean
);


ALTER TABLE public.ch_position_cft_giftcard OWNER TO postgres;

--
-- Name: TABLE ch_position_cft_giftcard; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_cft_giftcard IS 'Чек - Позиция - Подарочная карта ЦФТ';


--
-- Name: COLUMN ch_position_cft_giftcard.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.id IS 'Идентификатор товарной позиции';


--
-- Name: COLUMN ch_position_cft_giftcard.clientid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.clientid IS 'Номер подарочной карты (хеш, трек, штрихкод или номер)';


--
-- Name: COLUMN ch_position_cft_giftcard.clientidtype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.clientidtype IS 'Тип данных в clientID';


--
-- Name: COLUMN ch_position_cft_giftcard.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.amount IS 'Номинал активированной карты';


--
-- Name: COLUMN ch_position_cft_giftcard.terminal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.terminal IS 'Идентификатор кассы (POS)';


--
-- Name: COLUMN ch_position_cft_giftcard.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.location IS 'Код места установки кассы';


--
-- Name: COLUMN ch_position_cft_giftcard.partnerid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.partnerid IS 'Идентификатор участника';


--
-- Name: COLUMN ch_position_cft_giftcard.datetime_act; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.datetime_act IS 'Время выполнения операции активации в формате YYYYMMDDhhmmss';


--
-- Name: COLUMN ch_position_cft_giftcard.datetime_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.datetime_deact IS 'Время выполнения операции деактивации в формате YYYYMMDDhhmmss';


--
-- Name: COLUMN ch_position_cft_giftcard.id_trans_act; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.id_trans_act IS 'Идентификатор транзакции ЦФТ';


--
-- Name: COLUMN ch_position_cft_giftcard.id_trans_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.id_trans_deact IS 'Идентификатор транзакции деактивации ЦФТ';


--
-- Name: COLUMN ch_position_cft_giftcard.slip_act; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.slip_act IS 'Слип активации ЦФТ';


--
-- Name: COLUMN ch_position_cft_giftcard.slip_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.slip_deact IS 'Слип деактивации ЦФТ';


--
-- Name: COLUMN ch_position_cft_giftcard.online_deact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_cft_giftcard.online_deact IS 'Признак онлайн/оффлайн деактивации';


--
-- Name: ch_position_clothing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_clothing (
    id bigint NOT NULL,
    cis character varying(255)
);


ALTER TABLE public.ch_position_clothing OWNER TO postgres;

--
-- Name: TABLE ch_position_clothing; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_clothing IS 'Разновидность товара: "Одежда".';


--
-- Name: COLUMN ch_position_clothing.cis; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_clothing.cis IS 'КиЗ';


--
-- Name: ch_position_discount_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_discount_card (
    id bigint NOT NULL,
    card_number character varying(50),
    holder_id character varying(255),
    instant_applicable boolean DEFAULT true NOT NULL
);


ALTER TABLE public.ch_position_discount_card OWNER TO postgres;

--
-- Name: TABLE ch_position_discount_card; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_discount_card IS 'Чек - Товары - Дисконтная карта (PositionDiscountCardEntity)';


--
-- Name: COLUMN ch_position_discount_card.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_discount_card.id IS 'Идентификатор товарной позиции';


--
-- Name: COLUMN ch_position_discount_card.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_discount_card.card_number IS 'Номер дисконтной карты. Поле обязательно';


--
-- Name: COLUMN ch_position_discount_card.holder_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_discount_card.holder_id IS 'Некий идентификатор анкеты клиента, для которого куплена эта карта. Может отсутствовать';


--
-- Name: COLUMN ch_position_discount_card.instant_applicable; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_discount_card.instant_applicable IS 'Признак применения карты в чеке сразу при ее покупке';


--
-- Name: ch_position_exist_balance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_exist_balance (
    id bigint NOT NULL,
    uid character varying(36),
    processed boolean,
    cashtransactionid character varying(40),
    transactionid character varying(40),
    available_payments character varying(500)
);


ALTER TABLE public.ch_position_exist_balance OWNER TO postgres;

--
-- Name: TABLE ch_position_exist_balance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_exist_balance IS 'Разновидность товара: "Баланс IsNext" (ProductExistBalanceEntity)';


--
-- Name: COLUMN ch_position_exist_balance.uid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_exist_balance.uid IS 'uid клиента';


--
-- Name: COLUMN ch_position_exist_balance.processed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_exist_balance.processed IS 'признак обработки';


--
-- Name: COLUMN ch_position_exist_balance.cashtransactionid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_exist_balance.cashtransactionid IS 'Уникальный идентификатор транзакции кассы';


--
-- Name: COLUMN ch_position_exist_balance.transactionid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_exist_balance.transactionid IS 'Уникальный идентификатор транзакции полученный от IsNext';


--
-- Name: COLUMN ch_position_exist_balance.available_payments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_exist_balance.available_payments IS 'Доступные типы оплат. Хранятся все возможные оплаты в одной строке формата: Код - сумма оплаты;';


--
-- Name: ch_position_license_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_license_key (
    id bigint NOT NULL,
    client_last_name character varying(255),
    client_first_name character varying(255),
    client_middle_name character varying(255),
    client_phone_number character varying(10),
    client_address character varying(255),
    slips bytea,
    sublicensed boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ch_position_license_key OWNER TO postgres;

--
-- Name: TABLE ch_position_license_key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_license_key IS 'Разновидность товара: "Электронный ключ ПО".';


--
-- Name: COLUMN ch_position_license_key.client_last_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_license_key.client_last_name IS 'Фамилия клиента.';


--
-- Name: COLUMN ch_position_license_key.client_first_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_license_key.client_first_name IS 'Имя клиента.';


--
-- Name: COLUMN ch_position_license_key.client_middle_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_license_key.client_middle_name IS 'Отчество клиента.';


--
-- Name: COLUMN ch_position_license_key.client_phone_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_license_key.client_phone_number IS 'Номер телефона клиента.';


--
-- Name: COLUMN ch_position_license_key.client_address; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_license_key.client_address IS 'Номер телефона клиента.';


--
-- Name: COLUMN ch_position_license_key.slips; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_license_key.slips IS 'Все слипы, которые получаем от внешнего процессинга.';


--
-- Name: COLUMN ch_position_license_key.sublicensed; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_license_key.sublicensed IS 'Признак наличия сублицензионного договора.';


--
-- Name: ch_position_measure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_measure (
    code character varying(255) NOT NULL,
    name character varying(255)
);


ALTER TABLE public.ch_position_measure OWNER TO postgres;

--
-- Name: TABLE ch_position_measure; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_measure IS 'Единицы измерения (MeasurePositionEntity)';


--
-- Name: COLUMN ch_position_measure.code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_measure.code IS '"Коде" - уникальный код (с точки зрения ERP) этой единицы измерения';


--
-- Name: COLUMN ch_position_measure.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_measure.name IS 'Наименование';


--
-- Name: ch_position_production_date; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_production_date (
    position_id bigint NOT NULL,
    production_date timestamp without time zone NOT NULL,
    quantity bigint NOT NULL
);


ALTER TABLE public.ch_position_production_date OWNER TO postgres;

--
-- Name: TABLE ch_position_production_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_production_date IS 'Информация о датах производства в позиции';


--
-- Name: COLUMN ch_position_production_date.position_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_production_date.position_id IS 'Идентификатор позиции';


--
-- Name: COLUMN ch_position_production_date.production_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_production_date.production_date IS 'Дата производства';


--
-- Name: COLUMN ch_position_production_date.quantity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_production_date.quantity IS 'Количество товаров в позиции с данной датой производства';


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
-- Name: ch_position_seller; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_seller (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    codenum character varying(40) NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    middlename character varying(100)
);


ALTER TABLE public.ch_position_seller OWNER TO postgres;

--
-- Name: TABLE ch_position_seller; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_seller IS 'Продавцы в позициях';


--
-- Name: COLUMN ch_position_seller.codenum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_seller.codenum IS 'Код';


--
-- Name: COLUMN ch_position_seller.firstname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_seller.firstname IS 'Имя';


--
-- Name: COLUMN ch_position_seller.lastname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_seller.lastname IS 'Фамилия';


--
-- Name: COLUMN ch_position_seller.middlename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_position_seller.middlename IS 'Отчество';


--
-- Name: ch_position_siebel_giftcard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_position_siebel_giftcard (
    id bigint NOT NULL,
    cardnumber character varying(128)
);


ALTER TABLE public.ch_position_siebel_giftcard OWNER TO postgres;

--
-- Name: TABLE ch_position_siebel_giftcard; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_position_siebel_giftcard IS 'Разновидность товара: "Подарочная карта Siebel".';


--
-- Name: ch_positiongiftcard; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_positiongiftcard (
    id bigint NOT NULL,
    cardnumber character varying(30),
    amount bigint,
    expirationdate timestamp without time zone
);


ALTER TABLE public.ch_positiongiftcard OWNER TO postgres;

--
-- Name: TABLE ch_positiongiftcard; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_positiongiftcard IS 'Чек - Товары - Подарочная карта';


--
-- Name: COLUMN ch_positiongiftcard.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positiongiftcard.id IS 'Идентификатор товарной позиции';


--
-- Name: COLUMN ch_positiongiftcard.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positiongiftcard.cardnumber IS 'Номер карты';


--
-- Name: COLUMN ch_positiongiftcard.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positiongiftcard.amount IS 'Сумма на карте';


--
-- Name: COLUMN ch_positiongiftcard.expirationdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positiongiftcard.expirationdate IS 'Карта действует до...';


--
-- Name: ch_positionmobilepay; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_positionmobilepay (
    id bigint NOT NULL
);


ALTER TABLE public.ch_positionmobilepay OWNER TO postgres;

--
-- Name: TABLE ch_positionmobilepay; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_positionmobilepay IS 'Разновидность товара: "Мобильная оплата".';


--
-- Name: COLUMN ch_positionmobilepay.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positionmobilepay.id IS 'Идентификатор товарной позиции';


--
-- Name: ch_positionservice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_positionservice (
    id bigint NOT NULL,
    accountnumber character varying(255)
);


ALTER TABLE public.ch_positionservice OWNER TO postgres;

--
-- Name: TABLE ch_positionservice; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_positionservice IS 'Товарная позиция "Услуга"';


--
-- Name: COLUMN ch_positionservice.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positionservice.id IS 'Идентификатор товарной позиции';


--
-- Name: COLUMN ch_positionservice.accountnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positionservice.accountnumber IS 'Номер счета';


--
-- Name: ch_positionspirits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_positionspirits (
    id bigint NOT NULL,
    alcoholic_content double precision,
    volume double precision,
    kit boolean,
    alcoholic_type character varying(3)
);


ALTER TABLE public.ch_positionspirits OWNER TO postgres;

--
-- Name: TABLE ch_positionspirits; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_positionspirits IS 'Разновидность товара: "Крепкий алкоголь" (ProductSpiritsEntity)';


--
-- Name: COLUMN ch_positionspirits.alcoholic_content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positionspirits.alcoholic_content IS 'Процент содержания спирта';


--
-- Name: COLUMN ch_positionspirits.volume; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positionspirits.volume IS 'Объем бутыли (в литрах), в которой продается этот алкогольный товар';


--
-- Name: COLUMN ch_positionspirits.kit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positionspirits.kit IS 'Признак набора';


--
-- Name: COLUMN ch_positionspirits.alcoholic_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_positionspirits.alcoholic_type IS 'Код вида алкогольной продукции';


--
-- Name: ch_prepayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_prepayment (
    id bigint NOT NULL
);


ALTER TABLE public.ch_prepayment OWNER TO postgres;

--
-- Name: TABLE ch_prepayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_prepayment IS 'Чек - Оплаты - Зачет предоплаты';


--
-- Name: COLUMN ch_prepayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_prepayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: message_id_msg_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_id_msg_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_id_msg_seq OWNER TO postgres;

--
-- Name: ch_prisma_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_prisma_events (
    id bigint DEFAULT nextval('public.message_id_msg_seq'::regclass) NOT NULL,
    eventdate timestamp without time zone NOT NULL,
    message character varying(2000) NOT NULL
);


ALTER TABLE public.ch_prisma_events OWNER TO postgres;

--
-- Name: TABLE ch_prisma_events; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_prisma_events IS 'Сообщения призме, которые не удалось передать';


--
-- Name: COLUMN ch_prisma_events.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_prisma_events.id IS 'Идентификатор для очередности';


--
-- Name: COLUMN ch_prisma_events.eventdate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_prisma_events.eventdate IS 'Дата сообщения';


--
-- Name: COLUMN ch_prisma_events.message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_prisma_events.message IS 'Сообщение';


--
-- Name: ch_property; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_property (
    keyprop character varying(255) NOT NULL,
    valueprop character varying(255)
);


ALTER TABLE public.ch_property OWNER TO postgres;

--
-- Name: TABLE ch_property; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_property IS 'Свойство оплаты';


--
-- Name: ch_purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_purchase (
    id bigint NOT NULL,
    datecommit timestamp without time zone,
    datecreate timestamp without time zone,
    fiscaldocnum character varying(64),
    numberfield bigint,
    senttoserverstatus integer,
    id_session bigint,
    id_shift bigint,
    checkstatus integer,
    checksumend bigint,
    checksumstart bigint,
    currentchecknum integer,
    discountvaluetotal bigint,
    id_loyaltransaction bigint,
    operationtype boolean,
    id_purchaseref bigint,
    filename character varying(255),
    kpk bigint,
    spnd bigint,
    set5checknumber character varying(64),
    denyprinttodocuments boolean DEFAULT false NOT NULL,
    client_guid bigint,
    clienttype smallint,
    id_main_purchase bigint,
    inn character varying(255),
    vet_inspection boolean DEFAULT false NOT NULL,
    receipt_wide_discount bigint DEFAULT 0 NOT NULL,
    on_day boolean
);


ALTER TABLE public.ch_purchase OWNER TO postgres;

--
-- Name: TABLE ch_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_purchase IS 'Чеки (заголовки чеков)';


--
-- Name: COLUMN ch_purchase.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.id IS 'Идентификатор чека';


--
-- Name: COLUMN ch_purchase.datecommit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.datecommit IS 'Временная метка регистрации чека';


--
-- Name: COLUMN ch_purchase.datecreate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.datecreate IS 'Временная метка создания документа';


--
-- Name: COLUMN ch_purchase.fiscaldocnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.fiscaldocnum IS 'Номер фискального документа';


--
-- Name: COLUMN ch_purchase.numberfield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.numberfield IS 'Номер чека';


--
-- Name: COLUMN ch_purchase.senttoserverstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.senttoserverstatus IS 'Статус отправки документа на сервер';


--
-- Name: COLUMN ch_purchase.id_session; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.id_session IS 'Идентификатор сесси пользователя';


--
-- Name: COLUMN ch_purchase.id_shift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.id_shift IS 'Идентификатор смены';


--
-- Name: COLUMN ch_purchase.checkstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.checkstatus IS 'Статус чека';


--
-- Name: COLUMN ch_purchase.checksumend; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.checksumend IS 'Сумма чека после рассчета скидок';


--
-- Name: COLUMN ch_purchase.checksumstart; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.checksumstart IS 'Сумма чека до рассчета скидок';


--
-- Name: COLUMN ch_purchase.currentchecknum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.currentchecknum IS 'Номер параллельного чека';


--
-- Name: COLUMN ch_purchase.discountvaluetotal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.discountvaluetotal IS 'Сумма скидок';


--
-- Name: COLUMN ch_purchase.id_loyaltransaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.id_loyaltransaction IS 'Идентификатор транзакции расчета скидок по чеку';


--
-- Name: COLUMN ch_purchase.operationtype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.operationtype IS 'Операция';


--
-- Name: COLUMN ch_purchase.id_purchaseref; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.id_purchaseref IS 'Ссылка на оригинальный чек при возврате';


--
-- Name: COLUMN ch_purchase.filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.filename IS 'Имя файла выгрузки';


--
-- Name: COLUMN ch_purchase.kpk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.kpk IS 'номер КПК (или порядковый номер если это нефискальный документ)';


--
-- Name: COLUMN ch_purchase.spnd; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.spnd IS 'номер СПНД';


--
-- Name: COLUMN ch_purchase.set5checknumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.set5checknumber IS 'Номер чека продажи SET5 (заполняется только в случае возврата чека SET5)';


--
-- Name: COLUMN ch_purchase.denyprinttodocuments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.denyprinttodocuments IS 'Признак запрета печати сопроводительных документов для данного чека';


--
-- Name: COLUMN ch_purchase.client_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.client_guid IS 'GUID клиента, совершившего покупку';


--
-- Name: COLUMN ch_purchase.clienttype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.clienttype IS 'Тип клиента';


--
-- Name: COLUMN ch_purchase.id_main_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.id_main_purchase IS 'Ссылка на схлопнутый чек SRL-1263';


--
-- Name: COLUMN ch_purchase.inn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.inn IS 'ИНН Юр. лица';


--
-- Name: COLUMN ch_purchase.vet_inspection; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.vet_inspection IS 'Признак необходимости вет. контроля для системы Меркурий';


--
-- Name: COLUMN ch_purchase.receipt_wide_discount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.receipt_wide_discount IS 'Размер скидки на чек, что не удалось "распределить" по позициям чека';


--
-- Name: COLUMN ch_purchase.on_day; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase.on_day IS 'Признак для чека возврата "День в день"';


--
-- Name: ch_purchase_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_purchase_cards (
    id bigint NOT NULL,
    card_number character varying(256),
    card_guid character varying(16),
    display_number character varying(256),
    card_type character varying(128),
    id_purchase bigint,
    card_status integer,
    card_type_guid bigint,
    qnty bigint,
    id_position bigint,
    counterparty character varying(128),
    processing_name text,
    phone_number text,
    category integer,
    added_by integer,
    debitor_type text,
    pan character varying(255)
);


ALTER TABLE public.ch_purchase_cards OWNER TO postgres;

--
-- Name: TABLE ch_purchase_cards; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_purchase_cards IS 'Чек - Товарные позиции';


--
-- Name: COLUMN ch_purchase_cards.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.id IS 'Идентификатор карты в чеке';


--
-- Name: COLUMN ch_purchase_cards.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.card_number IS 'Номер карты';


--
-- Name: COLUMN ch_purchase_cards.card_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.card_guid IS 'Идентификатор карты';


--
-- Name: COLUMN ch_purchase_cards.display_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.display_number IS 'Отображаемое имя карты. В том виде, котором отображается пользователю. Может быть null';


--
-- Name: COLUMN ch_purchase_cards.card_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.card_type IS 'Тип карты [CardNotFound, InternalCard, ExternalCard, PresentCard,  BonusCard, CardCoupon, ChequeCoupon, ProcessingCoupon;]';


--
-- Name: COLUMN ch_purchase_cards.card_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.card_status IS 'Пока что состояние серийного купона: только что добавили, нужно вернуть или нужно забрать. Используется для вычисления: показать ли кассиру сообщение о действии или оно уже было показано.';


--
-- Name: COLUMN ch_purchase_cards.card_type_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.card_type_guid IS 'GUID категории карт, чтобы потом можно было найти при выгрузке в ERPI и подтащить доп инфу';


--
-- Name: COLUMN ch_purchase_cards.qnty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.qnty IS 'Количество товара, на который "наклеили" этот позиционный купон, в тысячных долях от единиц СИ (т.е., 1000 == 1 кг или 1 штука) - в "граммах"';


--
-- Name: COLUMN ch_purchase_cards.id_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.id_position IS 'Ссылка на позицию для позиционного купона';


--
-- Name: COLUMN ch_purchase_cards.counterparty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.counterparty IS 'Ссылка на справочник контрагента - сочетание ИНН;КПП';


--
-- Name: COLUMN ch_purchase_cards.processing_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.processing_name IS 'Имя процессинга, обрабатывающего данную карту или купон';


--
-- Name: COLUMN ch_purchase_cards.phone_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.phone_number IS 'Номер телефона, если карту или купон добавили по номеру мобильного телефона';


--
-- Name: COLUMN ch_purchase_cards.category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.category IS 'Категория карты для SET5 (оптимизация скорости)';


--
-- Name: COLUMN ch_purchase_cards.added_by; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.added_by IS 'способ добавления этой карты в чек: HAND(0)/SCANNER(1)/MSR(2)/PHONE(3)/ECARD(4)';


--
-- Name: COLUMN ch_purchase_cards.debitor_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.debitor_type IS 'Тип дебитора, например, Mercury';


--
-- Name: COLUMN ch_purchase_cards.pan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_cards.pan IS 'PAN со второй дорожки MSR (если номер карты на 3й)';


--
-- Name: ch_purchase_excise_bottle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_purchase_excise_bottle (
    id bigint NOT NULL,
    id_purchase bigint NOT NULL,
    item character varying(30) NOT NULL,
    barcode character varying(30) NOT NULL,
    excise_barcode character varying(255),
    volume double precision,
    price bigint,
    id_position_spirits bigint,
    alco_codes character varying(2000),
    count integer,
    name character varying(128),
    alcoholic_content double precision,
    alcoholic_type character varying(3),
    excise boolean DEFAULT true NOT NULL
);


ALTER TABLE public.ch_purchase_excise_bottle OWNER TO postgres;

--
-- Name: TABLE ch_purchase_excise_bottle; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_purchase_excise_bottle IS 'Бутылка акцизного алкогольного товара, когда алкогольный товар является набором';


--
-- Name: COLUMN ch_purchase_excise_bottle.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.id IS 'Идентификатор записи';


--
-- Name: COLUMN ch_purchase_excise_bottle.id_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.id_purchase IS 'Ссылка на чек';


--
-- Name: COLUMN ch_purchase_excise_bottle.item; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.item IS 'Артикул товара';


--
-- Name: COLUMN ch_purchase_excise_bottle.barcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.barcode IS 'Штрихкод бутылки';


--
-- Name: COLUMN ch_purchase_excise_bottle.excise_barcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.excise_barcode IS 'Штрихкод акцизной марки бутылки';


--
-- Name: COLUMN ch_purchase_excise_bottle.volume; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.volume IS 'Объем бутылки в литрах';


--
-- Name: COLUMN ch_purchase_excise_bottle.price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.price IS 'Цена бутылки ';


--
-- Name: COLUMN ch_purchase_excise_bottle.id_position_spirits; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.id_position_spirits IS 'Ссылка по алкогольную позицию, только если она является алкогольным набором';


--
-- Name: COLUMN ch_purchase_excise_bottle.alco_codes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.alco_codes IS 'Алко-коды акцизных бутылок';


--
-- Name: COLUMN ch_purchase_excise_bottle.count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.count IS 'Количество бутылок (для безакцизных)';


--
-- Name: COLUMN ch_purchase_excise_bottle.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.name IS 'Наименование';


--
-- Name: COLUMN ch_purchase_excise_bottle.alcoholic_content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.alcoholic_content IS 'Крепость';


--
-- Name: COLUMN ch_purchase_excise_bottle.alcoholic_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.alcoholic_type IS 'Код вида алкогольной продукции';


--
-- Name: COLUMN ch_purchase_excise_bottle.excise; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_excise_bottle.excise IS 'Признак того, что бутылка является акцизной';


--
-- Name: ch_purchase_ext_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_purchase_ext_data (
    id_purchase bigint NOT NULL,
    key character varying(100) NOT NULL,
    value text
);


ALTER TABLE public.ch_purchase_ext_data OWNER TO postgres;

--
-- Name: TABLE ch_purchase_ext_data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_purchase_ext_data IS 'Дополнительные данные чека, параметр=значение';


--
-- Name: COLUMN ch_purchase_ext_data.id_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_ext_data.id_purchase IS 'Id чека';


--
-- Name: COLUMN ch_purchase_ext_data.key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_ext_data.key IS 'Ключ значения';


--
-- Name: COLUMN ch_purchase_ext_data.value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_ext_data.value IS 'Значение';


--
-- Name: storno_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.storno_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.storno_sequence OWNER TO postgres;

--
-- Name: ch_purchase_storno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_purchase_storno (
    id bigint DEFAULT nextval('public.storno_sequence'::regclass) NOT NULL,
    id_purchase bigint NOT NULL,
    operation_time timestamp without time zone NOT NULL,
    tabnum character varying(40) NOT NULL,
    barcode character varying(30) NOT NULL,
    markingofthegood character varying(255) NOT NULL,
    name character varying(256) NOT NULL,
    operation_type smallint NOT NULL,
    amount_before bigint NOT NULL,
    amount_after bigint,
    price bigint NOT NULL,
    departnumber bigint
);


ALTER TABLE public.ch_purchase_storno OWNER TO postgres;

--
-- Name: TABLE ch_purchase_storno; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_purchase_storno IS 'Информация по сторно (отмене) и изменении позиций в чеке';


--
-- Name: COLUMN ch_purchase_storno.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.id IS 'Первичный ключ';


--
-- Name: COLUMN ch_purchase_storno.id_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.id_purchase IS 'Идентификатор чека';


--
-- Name: COLUMN ch_purchase_storno.operation_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.operation_time IS 'Время проведения операции';


--
-- Name: COLUMN ch_purchase_storno.tabnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.tabnum IS 'Табельный номер пользователя, который совершает оперцию сторно/изменения';


--
-- Name: COLUMN ch_purchase_storno.barcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.barcode IS 'Штриховой код';


--
-- Name: COLUMN ch_purchase_storno.markingofthegood; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.markingofthegood IS 'Артикул товара';


--
-- Name: COLUMN ch_purchase_storno.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.name IS 'Наименование товара';


--
-- Name: COLUMN ch_purchase_storno.operation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.operation_type IS 'Тип операции 0 - сторно (отмена), 1 - изменение';


--
-- Name: COLUMN ch_purchase_storno.amount_before; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.amount_before IS 'Количество в позиции до изменения';


--
-- Name: COLUMN ch_purchase_storno.amount_after; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.amount_after IS 'Количество в позиции после изменения';


--
-- Name: COLUMN ch_purchase_storno.price; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.price IS 'Цена единицы позиции';


--
-- Name: COLUMN ch_purchase_storno.departnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_storno.departnumber IS 'Номер отдела';


--
-- Name: ch_purchase_taxes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_purchase_taxes (
    id_purchase bigint NOT NULL,
    ndsclass character varying(3) NOT NULL,
    nds numeric(5,2) NOT NULL,
    ndssum bigint,
    paymentsum bigint
);


ALTER TABLE public.ch_purchase_taxes OWNER TO postgres;

--
-- Name: TABLE ch_purchase_taxes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_purchase_taxes IS 'Чек - налоги';


--
-- Name: COLUMN ch_purchase_taxes.id_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_taxes.id_purchase IS 'Идентификатор чека';


--
-- Name: COLUMN ch_purchase_taxes.ndsclass; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_taxes.ndsclass IS 'Класс налога';


--
-- Name: COLUMN ch_purchase_taxes.nds; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_taxes.nds IS 'Ставка НДС';


--
-- Name: COLUMN ch_purchase_taxes.ndssum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_taxes.ndssum IS 'Сумма налога';


--
-- Name: COLUMN ch_purchase_taxes.paymentsum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_purchase_taxes.paymentsum IS 'Сумма продаж';


--
-- Name: ch_reportshift; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_reportshift (
    id bigint NOT NULL,
    datecommit timestamp without time zone,
    datecreate timestamp without time zone,
    fiscaldocnum character varying(64),
    numberfield bigint,
    kpk bigint,
    spnd bigint,
    senttoserverstatus integer,
    id_session bigint NOT NULL,
    id_shift bigint,
    countcashin bigint,
    countcashout bigint,
    countcashpurchase bigint,
    countcashreturn bigint,
    countcashlesspurchase bigint,
    countcashlessreturn bigint,
    countpurchase bigint,
    countpurchasecancel bigint,
    countreturn bigint,
    reportz boolean,
    sumcashbegin bigint,
    sumcashend bigint,
    sumcashin bigint,
    sumcashout bigint,
    sumcashpurchase bigint,
    sumcashreturn bigint,
    sumcashlesspurchase bigint,
    sumcashlessreturn bigint,
    sumdiscount bigint,
    sumdiscountreturn bigint,
    sumpurchase bigint,
    sumpurchasecancel bigint,
    sumpurchasefiscal bigint,
    sumreturn bigint,
    sumreturnfiscal bigint,
    incresent_total_start bigint,
    incresent_total_finish bigint,
    incresent_total_ret_start bigint,
    incresent_total_ret_finish bigint,
    filename character varying(255),
    cash_name text,
    factory_cash_number text
);


ALTER TABLE public.ch_reportshift OWNER TO postgres;

--
-- Name: TABLE ch_reportshift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_reportshift IS 'Z/X-отчет';


--
-- Name: COLUMN ch_reportshift.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.id IS 'Идентификатор документа';


--
-- Name: COLUMN ch_reportshift.datecommit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.datecommit IS 'Временная метка регистрации документа';


--
-- Name: COLUMN ch_reportshift.datecreate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.datecreate IS 'Временная метка создания документа';


--
-- Name: COLUMN ch_reportshift.fiscaldocnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.fiscaldocnum IS 'Номер фискального документа';


--
-- Name: COLUMN ch_reportshift.numberfield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.numberfield IS 'Номер чека';


--
-- Name: COLUMN ch_reportshift.kpk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.kpk IS 'номер КПК (или порядковый номер если это нефискальный документ)';


--
-- Name: COLUMN ch_reportshift.spnd; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.spnd IS 'номер СПНД';


--
-- Name: COLUMN ch_reportshift.senttoserverstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.senttoserverstatus IS 'Статус оправки на сервер';


--
-- Name: COLUMN ch_reportshift.id_session; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.id_session IS 'Идентификатор сессии';


--
-- Name: COLUMN ch_reportshift.id_shift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.id_shift IS 'Идентификатор смены';


--
-- Name: COLUMN ch_reportshift.countcashin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countcashin IS 'Количество внесений';


--
-- Name: COLUMN ch_reportshift.countcashout; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countcashout IS 'Количество изъятий';


--
-- Name: COLUMN ch_reportshift.countcashpurchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countcashpurchase IS 'Количество наличных чеков продаж';


--
-- Name: COLUMN ch_reportshift.countcashreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countcashreturn IS 'Количество наличных чеков возвратов';


--
-- Name: COLUMN ch_reportshift.countcashlesspurchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countcashlesspurchase IS 'Количество безналичных чеков возвратов';


--
-- Name: COLUMN ch_reportshift.countcashlessreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countcashlessreturn IS 'Количество безналичных чеков возвратов';


--
-- Name: COLUMN ch_reportshift.countpurchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countpurchase IS 'Количество чеков продаж';


--
-- Name: COLUMN ch_reportshift.countpurchasecancel; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countpurchasecancel IS 'Количество аннулированных чеков';


--
-- Name: COLUMN ch_reportshift.countreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.countreturn IS 'Количество чеков возвратов';


--
-- Name: COLUMN ch_reportshift.reportz; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.reportz IS 'Признак Z-отчета';


--
-- Name: COLUMN ch_reportshift.sumcashbegin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumcashbegin IS 'Сумма денег на начало смены';


--
-- Name: COLUMN ch_reportshift.sumcashend; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumcashend IS 'Сумма денег на конец смены';


--
-- Name: COLUMN ch_reportshift.sumcashin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumcashin IS 'Сумма внесений';


--
-- Name: COLUMN ch_reportshift.sumcashout; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumcashout IS 'Сумма изъятий';


--
-- Name: COLUMN ch_reportshift.sumcashpurchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumcashpurchase IS 'Сумма наличных продаж';


--
-- Name: COLUMN ch_reportshift.sumcashreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumcashreturn IS 'Сумма наличных возвратов';


--
-- Name: COLUMN ch_reportshift.sumcashlesspurchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumcashlesspurchase IS 'Сумма безналичных продаж';


--
-- Name: COLUMN ch_reportshift.sumcashlessreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumcashlessreturn IS 'Сумма безналичных возвратов';


--
-- Name: COLUMN ch_reportshift.sumdiscount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumdiscount IS 'Сумма скидок';


--
-- Name: COLUMN ch_reportshift.sumdiscountreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumdiscountreturn IS 'Сумма скидок в возвратных чеках';


--
-- Name: COLUMN ch_reportshift.sumpurchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumpurchase IS 'Сумма продаж';


--
-- Name: COLUMN ch_reportshift.sumpurchasecancel; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumpurchasecancel IS 'Сумма аннулированных чеков';


--
-- Name: COLUMN ch_reportshift.sumpurchasefiscal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumpurchasefiscal IS 'ФР - сумма чеков продаж';


--
-- Name: COLUMN ch_reportshift.sumreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumreturn IS 'Сумма возвратов';


--
-- Name: COLUMN ch_reportshift.sumreturnfiscal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.sumreturnfiscal IS 'ФР - сумма возвратов';


--
-- Name: COLUMN ch_reportshift.incresent_total_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.incresent_total_start IS 'Нарастающий итог на начало смены';


--
-- Name: COLUMN ch_reportshift.incresent_total_finish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.incresent_total_finish IS 'Нарастающий итог на конец смены';


--
-- Name: COLUMN ch_reportshift.incresent_total_ret_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.incresent_total_ret_start IS 'Нарастающий итог возвратов на начало смены';


--
-- Name: COLUMN ch_reportshift.incresent_total_ret_finish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.incresent_total_ret_finish IS 'Нарастающий итог возвратов на конец смены';


--
-- Name: COLUMN ch_reportshift.filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.filename IS 'Имя файла выгрузки';


--
-- Name: COLUMN ch_reportshift.cash_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.cash_name IS 'Название устройства кассы';


--
-- Name: COLUMN ch_reportshift.factory_cash_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift.factory_cash_number IS 'Заводской номер фискального регистратора';


--
-- Name: ch_reportshift_taxes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_reportshift_taxes (
    id_report bigint NOT NULL,
    ndsclass character varying(3) NOT NULL,
    nds numeric(5,2) NOT NULL,
    ndssumsale bigint,
    ndssumreturn bigint,
    paymentsumsale bigint,
    paymentsumreturn bigint
);


ALTER TABLE public.ch_reportshift_taxes OWNER TO postgres;

--
-- Name: TABLE ch_reportshift_taxes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_reportshift_taxes IS 'Z/X-отчет - Налоги';


--
-- Name: COLUMN ch_reportshift_taxes.id_report; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift_taxes.id_report IS 'Идентификатор отчета';


--
-- Name: COLUMN ch_reportshift_taxes.ndsclass; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift_taxes.ndsclass IS 'Класс НДС';


--
-- Name: COLUMN ch_reportshift_taxes.nds; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift_taxes.nds IS 'Ставка НДС';


--
-- Name: COLUMN ch_reportshift_taxes.ndssumsale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift_taxes.ndssumsale IS 'Сумма налога продажи';


--
-- Name: COLUMN ch_reportshift_taxes.ndssumreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift_taxes.ndssumreturn IS 'Сумма налога возврата';


--
-- Name: COLUMN ch_reportshift_taxes.paymentsumsale; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift_taxes.paymentsumsale IS 'Сумма продаж по текущей налоговой ставке';


--
-- Name: COLUMN ch_reportshift_taxes.paymentsumreturn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportshift_taxes.paymentsumreturn IS 'Сумма возвратов по текущей налоговой ставке';


--
-- Name: ch_reportsshift_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_reportsshift_payments (
    id_report bigint NOT NULL,
    payment_type character varying(40) NOT NULL,
    operation_type character(1) NOT NULL,
    p_summ bigint NOT NULL
);


ALTER TABLE public.ch_reportsshift_payments OWNER TO postgres;

--
-- Name: TABLE ch_reportsshift_payments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_reportsshift_payments IS 'Типы оплат для отчетов операционного дня';


--
-- Name: COLUMN ch_reportsshift_payments.id_report; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportsshift_payments.id_report IS 'Ссылка на отчет';


--
-- Name: COLUMN ch_reportsshift_payments.payment_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportsshift_payments.payment_type IS 'Тип оплаты';


--
-- Name: COLUMN ch_reportsshift_payments.operation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportsshift_payments.operation_type IS 'тип операции - P(продажа), R(возврат)';


--
-- Name: COLUMN ch_reportsshift_payments.p_summ; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportsshift_payments.p_summ IS 'Сумма по группе';


--
-- Name: ch_reportsshift_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_reportsshift_products (
    id_report bigint NOT NULL,
    product_type character varying(40) NOT NULL,
    operation_type character(1) NOT NULL,
    p_summ bigint NOT NULL
);


ALTER TABLE public.ch_reportsshift_products OWNER TO postgres;

--
-- Name: TABLE ch_reportsshift_products; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_reportsshift_products IS 'Типы товаров для отчетов операционного дня';


--
-- Name: COLUMN ch_reportsshift_products.id_report; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportsshift_products.id_report IS 'Ссылка на отчет';


--
-- Name: COLUMN ch_reportsshift_products.product_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportsshift_products.product_type IS 'Тип товара';


--
-- Name: COLUMN ch_reportsshift_products.operation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportsshift_products.operation_type IS 'тип операции - P(продажа), R(возврат)';


--
-- Name: COLUMN ch_reportsshift_products.p_summ; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_reportsshift_products.p_summ IS 'Сумма по группе';


--
-- Name: ch_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_session (
    id bigint NOT NULL,
    datebegin timestamp without time zone NOT NULL,
    dateend timestamp without time zone,
    user_tabnum character varying(40),
    senttoserverstatus integer
);


ALTER TABLE public.ch_session OWNER TO postgres;

--
-- Name: TABLE ch_session; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_session IS 'Сессии пользователей в документах';


--
-- Name: COLUMN ch_session.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_session.id IS 'Идентификатор сессии';


--
-- Name: COLUMN ch_session.datebegin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_session.datebegin IS 'Временная метка начала сессии';


--
-- Name: COLUMN ch_session.dateend; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_session.dateend IS 'Временная метка окончания сессии';


--
-- Name: COLUMN ch_session.user_tabnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_session.user_tabnum IS 'Табельный номер';


--
-- Name: COLUMN ch_session.senttoserverstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_session.senttoserverstatus IS 'Статус отправки сессии на сервер';


--
-- Name: ch_shift; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_shift (
    id bigint NOT NULL,
    cashnum bigint,
    eklznum character varying(255),
    fiscalnum character varying(255),
    fiscalsum bigint,
    numshift bigint,
    shiftclose timestamp without time zone,
    shiftopen timestamp without time zone,
    shiftcreate timestamp without time zone,
    shopindex bigint,
    state integer NOT NULL,
    sumcashbegin bigint,
    id_sessionstart bigint,
    incresent_total_start bigint,
    incresent_total_finish bigint,
    incresent_total_ret_start bigint,
    incresent_total_ret_finish bigint,
    open_shift_kpk bigint,
    inn character varying(255)
);


ALTER TABLE public.ch_shift OWNER TO postgres;

--
-- Name: TABLE ch_shift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_shift IS 'Смены';


--
-- Name: COLUMN ch_shift.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.id IS 'Идентификатор смены';


--
-- Name: COLUMN ch_shift.cashnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.cashnum IS 'Номер кассы';


--
-- Name: COLUMN ch_shift.eklznum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.eklznum IS 'Номер ЭКЛЗ';


--
-- Name: COLUMN ch_shift.fiscalnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.fiscalnum IS 'Номер фискальной памяти';


--
-- Name: COLUMN ch_shift.fiscalsum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.fiscalsum IS 'Сумма за смену в фискальной памяти';


--
-- Name: COLUMN ch_shift.numshift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.numshift IS 'Номер смены';


--
-- Name: COLUMN ch_shift.shiftclose; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.shiftclose IS 'Временная метка закрытия смены';


--
-- Name: COLUMN ch_shift.shiftopen; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.shiftopen IS 'Временная метка открытия смены';


--
-- Name: COLUMN ch_shift.shiftcreate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.shiftcreate IS 'Временная метка открытия ПРОГРАММНОЙ смены';


--
-- Name: COLUMN ch_shift.shopindex; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.shopindex IS 'Номер магазина';


--
-- Name: COLUMN ch_shift.state; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.state IS 'Статус смены??????';


--
-- Name: COLUMN ch_shift.sumcashbegin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.sumcashbegin IS 'Сумма денег в кассе на начало смены';


--
-- Name: COLUMN ch_shift.id_sessionstart; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.id_sessionstart IS 'Идентификатор сессии пользователя, открывшего смену';


--
-- Name: COLUMN ch_shift.incresent_total_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.incresent_total_start IS 'Нарастающий итог на начало смены';


--
-- Name: COLUMN ch_shift.incresent_total_finish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.incresent_total_finish IS 'Нарастающий итог на конец смены';


--
-- Name: COLUMN ch_shift.incresent_total_ret_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.incresent_total_ret_start IS 'Нарастающий итог возвратов на начало смены';


--
-- Name: COLUMN ch_shift.incresent_total_ret_finish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.incresent_total_ret_finish IS 'Нарастающий итог возвратов на конец смены';


--
-- Name: COLUMN ch_shift.open_shift_kpk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.open_shift_kpk IS 'КПК на момент открытия смены';


--
-- Name: COLUMN ch_shift.inn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_shift.inn IS 'ИНН Юр.лица открывшего смену';


--
-- Name: ch_shiftstatusdata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_shiftstatusdata (
    id bigint NOT NULL,
    countannul bigint,
    countcashin bigint,
    countcashout bigint,
    countpurchases integer,
    isshiftopen boolean,
    lastkpk bigint,
    regnum character varying(255),
    shiftnum bigint,
    spnd bigint
);


ALTER TABLE public.ch_shiftstatusdata OWNER TO postgres;

--
-- Name: TABLE ch_shiftstatusdata; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_shiftstatusdata IS 'Статус смены';


--
-- Name: ch_siebelbonuscardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_siebelbonuscardpayment (
    id bigint NOT NULL,
    accountid bigint,
    cancelbonuses integer,
    cardnumber character varying(255)
);


ALTER TABLE public.ch_siebelbonuscardpayment OWNER TO postgres;

--
-- Name: TABLE ch_siebelbonuscardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_siebelbonuscardpayment IS 'Чек - Оплаты - Бонусы Siebel';


--
-- Name: COLUMN ch_siebelbonuscardpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_siebelbonuscardpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_siebelbonuscardpayment.cardnumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_siebelbonuscardpayment.cardnumber IS 'Номер карты';


--
-- Name: ch_siebelbonusesasgiftpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_siebelbonusesasgiftpayment (
    id bigint NOT NULL,
    cardnumber character varying(255)
);


ALTER TABLE public.ch_siebelbonusesasgiftpayment OWNER TO postgres;

--
-- Name: TABLE ch_siebelbonusesasgiftpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_siebelbonusesasgiftpayment IS 'Информация по оплате подарков в процессинге лояльности Siebel';


--
-- Name: ch_siebelgiftcardpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_siebelgiftcardpayment (
    id bigint NOT NULL,
    card_number character varying(255)
);


ALTER TABLE public.ch_siebelgiftcardpayment OWNER TO postgres;

--
-- Name: TABLE ch_siebelgiftcardpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_siebelgiftcardpayment IS 'Оплаты по подарочной карте Siebel';


--
-- Name: ch_suprapayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_suprapayment (
    id bigint NOT NULL,
    card_number character varying(50),
    verification_number character varying(5),
    auth_code character varying(50),
    amount bigint
);


ALTER TABLE public.ch_suprapayment OWNER TO postgres;

--
-- Name: TABLE ch_suprapayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_suprapayment IS 'Сущность, описывающая оплату по карте СУПРА';


--
-- Name: COLUMN ch_suprapayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_suprapayment.id IS 'Идентификатор';


--
-- Name: COLUMN ch_suprapayment.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_suprapayment.card_number IS 'Номер карты';


--
-- Name: COLUMN ch_suprapayment.verification_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_suprapayment.verification_number IS 'Верификационный (напечатанный на карте) номер';


--
-- Name: COLUMN ch_suprapayment.auth_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_suprapayment.auth_code IS 'Код авторизации при оплате';


--
-- Name: COLUMN ch_suprapayment.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_suprapayment.amount IS 'Величина списания';


--
-- Name: ch_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_transaction (
    id bigint NOT NULL,
    cashmsg text,
    cashnum bigint,
    checknum bigint,
    datetime timestamp without time zone,
    displaymsg text,
    numberfield bigint,
    printstr text,
    shiftnum bigint,
    shopnum bigint,
    sumoperator bigint,
    sumpay bigint,
    userfio character varying(255),
    id_position bigint
);


ALTER TABLE public.ch_transaction OWNER TO postgres;

--
-- Name: TABLE ch_transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_transaction IS 'Транзакции';


--
-- Name: ch_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_user (
    tabnum character varying(40) NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    middlename character varying(100),
    inn character varying(255)
);


ALTER TABLE public.ch_user OWNER TO postgres;

--
-- Name: TABLE ch_user; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_user IS 'Пользователи в документах смены';


--
-- Name: COLUMN ch_user.tabnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_user.tabnum IS 'Табельный номер';


--
-- Name: COLUMN ch_user.firstname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_user.firstname IS 'Имя';


--
-- Name: COLUMN ch_user.lastname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_user.lastname IS 'Фамилия';


--
-- Name: COLUMN ch_user.middlename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_user.middlename IS 'Отчество';


--
-- Name: COLUMN ch_user.inn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_user.inn IS 'ИНН';


--
-- Name: ch_voucherpayment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_voucherpayment (
    id bigint NOT NULL,
    vouchernumber character varying(255)
);


ALTER TABLE public.ch_voucherpayment OWNER TO postgres;

--
-- Name: TABLE ch_voucherpayment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_voucherpayment IS 'Оплата ваучером';


--
-- Name: COLUMN ch_voucherpayment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_voucherpayment.id IS 'Идентификатор оплатной позиции';


--
-- Name: COLUMN ch_voucherpayment.vouchernumber; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_voucherpayment.vouchernumber IS 'Номер ваучера';


--
-- Name: ch_withdrawal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ch_withdrawal (
    id bigint NOT NULL,
    datecommit timestamp without time zone,
    datecreate timestamp without time zone,
    fiscaldocnum character varying(64),
    numberfield bigint,
    senttoserverstatus integer,
    id_session bigint NOT NULL,
    id_shift bigint,
    id_basecurrency character varying(3),
    id_currency character varying(3),
    sumcoins bigint,
    value bigint,
    was_before bigint,
    valuebasecurrency bigint,
    kpk bigint,
    spnd bigint,
    filename character varying(255),
    exchange_residue boolean
);


ALTER TABLE public.ch_withdrawal OWNER TO postgres;

--
-- Name: TABLE ch_withdrawal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.ch_withdrawal IS 'Изъятия наличных';


--
-- Name: COLUMN ch_withdrawal.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.id IS 'Идентификатор изъятия';


--
-- Name: COLUMN ch_withdrawal.datecommit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.datecommit IS 'Временная метка регистрации документа';


--
-- Name: COLUMN ch_withdrawal.datecreate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.datecreate IS 'Временная метка создания документа';


--
-- Name: COLUMN ch_withdrawal.fiscaldocnum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.fiscaldocnum IS 'Номер фискального документа';


--
-- Name: COLUMN ch_withdrawal.numberfield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.numberfield IS 'Номер чека';


--
-- Name: COLUMN ch_withdrawal.senttoserverstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.senttoserverstatus IS 'Статус отправки на сервер';


--
-- Name: COLUMN ch_withdrawal.id_session; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.id_session IS 'Идентификатор сессии';


--
-- Name: COLUMN ch_withdrawal.id_shift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.id_shift IS 'Идентификатор смены';


--
-- Name: COLUMN ch_withdrawal.id_basecurrency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.id_basecurrency IS 'Идентификатор основной валюты';


--
-- Name: COLUMN ch_withdrawal.id_currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.id_currency IS 'Идентификатор валюты изъятия';


--
-- Name: COLUMN ch_withdrawal.sumcoins; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.sumcoins IS 'Сумма монет';


--
-- Name: COLUMN ch_withdrawal.value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.value IS 'Сумма в валюте изъятия';


--
-- Name: COLUMN ch_withdrawal.was_before; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.was_before IS 'Сумма в кассе до изъятия';


--
-- Name: COLUMN ch_withdrawal.valuebasecurrency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.valuebasecurrency IS 'Сумма в основной валюте';


--
-- Name: COLUMN ch_withdrawal.kpk; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.kpk IS 'номер КПК (или порядковый номер если это нефискальный документ)';


--
-- Name: COLUMN ch_withdrawal.spnd; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.spnd IS 'номер СПНД';


--
-- Name: COLUMN ch_withdrawal.filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.filename IS 'Имя файла выгрузки';


--
-- Name: COLUMN ch_withdrawal.exchange_residue; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.ch_withdrawal.exchange_residue IS 'Признак того, что изъятие является разменным остатком';


--
-- Name: egais_interactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.egais_interactions (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    shop_number integer NOT NULL,
    cash_number integer NOT NULL,
    shift_number integer NOT NULL,
    receipt_number integer NOT NULL,
    fiscal_printer_number character varying(125) NOT NULL,
    request_date timestamp with time zone NOT NULL,
    request text NOT NULL,
    response_date timestamp with time zone NOT NULL,
    response text NOT NULL,
    status character varying(255) NOT NULL,
    senttoserverstatus integer,
    filename character varying(255),
    response_time integer NOT NULL
);


ALTER TABLE public.egais_interactions OWNER TO postgres;

--
-- Name: TABLE egais_interactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.egais_interactions IS 'Таблица для логов взаимодействия с ЕГАИС (запросы, ответы, ошибки связи по таймауту)';


--
-- Name: COLUMN egais_interactions.shop_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.shop_number IS 'Номер магазина';


--
-- Name: COLUMN egais_interactions.cash_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.cash_number IS 'Номер кассы';


--
-- Name: COLUMN egais_interactions.shift_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.shift_number IS 'Номер смены';


--
-- Name: COLUMN egais_interactions.receipt_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.receipt_number IS 'Номер чека';


--
-- Name: COLUMN egais_interactions.fiscal_printer_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.fiscal_printer_number IS 'Номер фискального регистратора';


--
-- Name: COLUMN egais_interactions.request_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.request_date IS 'Дата отправки запроса';


--
-- Name: COLUMN egais_interactions.request; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.request IS 'Текст запроса';


--
-- Name: COLUMN egais_interactions.response_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.response_date IS 'Дата получения ответа';


--
-- Name: COLUMN egais_interactions.response; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.response IS 'Текст ответа';


--
-- Name: COLUMN egais_interactions.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.status IS 'Статус запроса (SUCCESS/FAIL/UNKNOWN)';


--
-- Name: COLUMN egais_interactions.senttoserverstatus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.senttoserverstatus IS 'Статус отсылки на сервер: NO_SENT(0), WAIT_ACKNOWLEDGEMENT(1), SENT(2), SENT_ERROR(3), REQUESTED(4), UNCOMMITED(5)';


--
-- Name: COLUMN egais_interactions.filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.filename IS 'Имя файла на сервере в который сохранена запись лога ЕГАИС (особенности синхронизации записей с кассы на сервер)';


--
-- Name: COLUMN egais_interactions.response_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.egais_interactions.response_time IS 'Время отклика ЕГАИС';


--
-- Name: message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message (
    id_msg bigint DEFAULT nextval('public.message_id_msg_seq'::regclass) NOT NULL,
    discriminator integer NOT NULL,
    msg_date timestamp without time zone,
    msg_type bigint,
    cash_num bigint,
    shop_num bigint,
    msg character varying(255),
    status bigint,
    log_in_date timestamp without time zone,
    log_out_date timestamp without time zone,
    log_out_user character varying(40),
    barcode_not_found character varying(255),
    fiscal_num character varying(255),
    shift_num bigint,
    tab_number bigint
);


ALTER TABLE public.message OWNER TO postgres;

--
-- Name: TABLE message; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.message IS 'Лог активностей кассы';


--
-- Name: ch_fictivecashinout id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_fictivecashinout ALTER COLUMN id SET DEFAULT nextval('public.ch_fictivecashinout_id_seq'::regclass);


--
-- Name: ch_position_measure cg_measure_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_measure
    ADD CONSTRAINT cg_measure_pkey PRIMARY KEY (code);


--
-- Name: ch_bankcardpayment_transaction ch_bankcardpayment_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_bankcardpayment_transaction
    ADD CONSTRAINT ch_bankcardpayment_transaction_pkey PRIMARY KEY (id);


--
-- Name: ch_bonussberbankpayment ch_bonussberbankpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_bonussberbankpayment
    ADD CONSTRAINT ch_bonussberbankpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_cashpayment ch_cashpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_cashpayment
    ADD CONSTRAINT ch_cashpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_cft_giftcardpayment ch_cft_giftcardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_cft_giftcardpayment
    ADD CONSTRAINT ch_cft_giftcardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_cft_giftegcpayment ch_cft_giftegcpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_cft_giftegcpayment
    ADD CONSTRAINT ch_cft_giftegcpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_childrencardpayment ch_childrencardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_childrencardpayment
    ADD CONSTRAINT ch_childrencardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_position_clothing ch_clothing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_clothing
    ADD CONSTRAINT ch_clothing_pkey PRIMARY KEY (id);


--
-- Name: ch_correctionreceipt_payments ch_correctionreceipt_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_correctionreceipt_payments
    ADD CONSTRAINT ch_correctionreceipt_payments_pkey PRIMARY KEY (id_correction, paymentname);


--
-- Name: ch_correctionreceipt ch_correctionreceipt_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_correctionreceipt
    ADD CONSTRAINT ch_correctionreceipt_pk PRIMARY KEY (id);


--
-- Name: ch_correctionreceipt_taxes ch_correctionreceipt_taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_correctionreceipt_taxes
    ADD CONSTRAINT ch_correctionreceipt_taxes_pkey PRIMARY KEY (id_correction, tax);


--
-- Name: ch_externalbankterminalpayment ch_externalbankterminalpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_externalbankterminalpayment
    ADD CONSTRAINT ch_externalbankterminalpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_fictivecashinout ch_fictivecashinout_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_fictivecashinout
    ADD CONSTRAINT ch_fictivecashinout_pk PRIMARY KEY (id);


--
-- Name: ch_giftcardpayment ch_giftcardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_giftcardpayment
    ADD CONSTRAINT ch_giftcardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_introduction ch_introduction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_introduction
    ADD CONSTRAINT ch_introduction_pkey PRIMARY KEY (id);


--
-- Name: ch_inventory ch_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_inventory
    ADD CONSTRAINT ch_inventory_pkey PRIMARY KEY (id);


--
-- Name: ch_position_license_key ch_license_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_license_key
    ADD CONSTRAINT ch_license_key_pkey PRIMARY KEY (id);


--
-- Name: ch_manual_position_adv_action ch_manual_position_adv_action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_manual_position_adv_action
    ADD CONSTRAINT ch_manual_position_adv_action_pkey PRIMARY KEY (id);


--
-- Name: ch_message ch_message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_message
    ADD CONSTRAINT ch_message_pkey PRIMARY KEY (id);


--
-- Name: ch_payment ch_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment
    ADD CONSTRAINT ch_payment_pkey PRIMARY KEY (id);


--
-- Name: ch_payment_property_name ch_payment_property_name_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_property_name
    ADD CONSTRAINT ch_payment_property_name_pkey PRIMARY KEY (id);


--
-- Name: ch_payment_property ch_payment_property_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_property
    ADD CONSTRAINT ch_payment_property_pkey PRIMARY KEY (id);


--
-- Name: ch_payment_transaction ch_payment_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_transaction
    ADD CONSTRAINT ch_payment_transaction_pkey PRIMARY KEY (id);


--
-- Name: ch_payment_transaction_slip ch_payment_transaction_slip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_transaction_slip
    ADD CONSTRAINT ch_payment_transaction_slip_pk PRIMARY KEY (payment_transaction_id, number);


--
-- Name: ch_position_cft_giftcard ch_position_cft_giftcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_cft_giftcard
    ADD CONSTRAINT ch_position_cft_giftcard_pkey PRIMARY KEY (id);


--
-- Name: ch_position_discount_card ch_position_discount_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_discount_card
    ADD CONSTRAINT ch_position_discount_card_pkey PRIMARY KEY (id);


--
-- Name: ch_position_exist_balance ch_position_exist_balance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_exist_balance
    ADD CONSTRAINT ch_position_exist_balance_pkey PRIMARY KEY (id);


--
-- Name: ch_position ch_position_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position
    ADD CONSTRAINT ch_position_pkey PRIMARY KEY (id);


--
-- Name: ch_position_production_date ch_position_production_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_production_date
    ADD CONSTRAINT ch_position_production_date_key PRIMARY KEY (position_id, production_date);


--
-- Name: ch_position_seller ch_position_seller_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_seller
    ADD CONSTRAINT ch_position_seller_pkey PRIMARY KEY (id);


--
-- Name: ch_position_siebel_giftcard ch_position_siebel_giftcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_siebel_giftcard
    ADD CONSTRAINT ch_position_siebel_giftcard_pkey PRIMARY KEY (id);


--
-- Name: ch_positiongiftcard ch_positiongiftcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_positiongiftcard
    ADD CONSTRAINT ch_positiongiftcard_pkey PRIMARY KEY (id);


--
-- Name: ch_positionmobilepay ch_positionmobilepay_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_positionmobilepay
    ADD CONSTRAINT ch_positionmobilepay_pkey PRIMARY KEY (id);


--
-- Name: ch_positionservice ch_positionservice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_positionservice
    ADD CONSTRAINT ch_positionservice_pkey PRIMARY KEY (id);


--
-- Name: ch_positionspirits ch_positionspirits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_positionspirits
    ADD CONSTRAINT ch_positionspirits_pkey PRIMARY KEY (id);


--
-- Name: ch_prepayment ch_prepayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_prepayment
    ADD CONSTRAINT ch_prepayment_pkey PRIMARY KEY (id);


--
-- Name: ch_prisma_events ch_prisma_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_prisma_events
    ADD CONSTRAINT ch_prisma_events_pkey PRIMARY KEY (id);


--
-- Name: ch_property ch_property_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_property
    ADD CONSTRAINT ch_property_pkey PRIMARY KEY (keyprop);


--
-- Name: ch_purchase_cards ch_purchase_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_cards
    ADD CONSTRAINT ch_purchase_cards_pkey PRIMARY KEY (id);


--
-- Name: ch_purchase_excise_bottle ch_purchase_excise_bottle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_excise_bottle
    ADD CONSTRAINT ch_purchase_excise_bottle_pkey PRIMARY KEY (id);


--
-- Name: ch_purchase_ext_data ch_purchase_ext_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_ext_data
    ADD CONSTRAINT ch_purchase_ext_data_pkey PRIMARY KEY (id_purchase, key);


--
-- Name: ch_purchase ch_purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase
    ADD CONSTRAINT ch_purchase_pkey PRIMARY KEY (id);


--
-- Name: ch_purchase_storno ch_purchase_storno_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_storno
    ADD CONSTRAINT ch_purchase_storno_pkey PRIMARY KEY (id);


--
-- Name: ch_purchase_taxes ch_purchase_taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_taxes
    ADD CONSTRAINT ch_purchase_taxes_pkey PRIMARY KEY (id_purchase, ndsclass, nds);


--
-- Name: ch_reportshift ch_reportshift_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportshift
    ADD CONSTRAINT ch_reportshift_pkey PRIMARY KEY (id);


--
-- Name: ch_reportshift_taxes ch_reportshift_taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportshift_taxes
    ADD CONSTRAINT ch_reportshift_taxes_pkey PRIMARY KEY (id_report, ndsclass, nds);


--
-- Name: ch_reportsshift_payments ch_reportsshift_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportsshift_payments
    ADD CONSTRAINT ch_reportsshift_payments_pkey PRIMARY KEY (id_report, payment_type, operation_type);


--
-- Name: ch_reportsshift_products ch_reportsshift_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportsshift_products
    ADD CONSTRAINT ch_reportsshift_products_pkey PRIMARY KEY (id_report, product_type, operation_type);


--
-- Name: ch_session ch_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_session
    ADD CONSTRAINT ch_session_pkey PRIMARY KEY (id);


--
-- Name: ch_shift ch_shift_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_shift
    ADD CONSTRAINT ch_shift_pkey PRIMARY KEY (id);


--
-- Name: ch_shiftstatusdata ch_shiftstatusdata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_shiftstatusdata
    ADD CONSTRAINT ch_shiftstatusdata_pkey PRIMARY KEY (id);


--
-- Name: ch_suprapayment ch_suprapayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_suprapayment
    ADD CONSTRAINT ch_suprapayment_pkey PRIMARY KEY (id);


--
-- Name: ch_user ch_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_user
    ADD CONSTRAINT ch_user_pkey PRIMARY KEY (tabnum);


--
-- Name: ch_withdrawal ch_withdrawal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_withdrawal
    ADD CONSTRAINT ch_withdrawal_pkey PRIMARY KEY (id);


--
-- Name: egais_interactions egais_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.egais_interactions
    ADD CONSTRAINT egais_interactions_pkey PRIMARY KEY (id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id_msg);


--
-- Name: ch_bankcardpayment pa_bankcardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_bankcardpayment
    ADD CONSTRAINT pa_bankcardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_bonuscardpayment pa_bonuscardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_bonuscardpayment
    ADD CONSTRAINT pa_bonuscardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_internalcreditcardpayment pa_internalcreditcardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_internalcreditcardpayment
    ADD CONSTRAINT pa_internalcreditcardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_kopilkabonuscardpayment pa_kopilkabonuscardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_kopilkabonuscardpayment
    ADD CONSTRAINT pa_kopilkabonuscardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_siebelbonuscardpayment pa_siebelbonuscardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_siebelbonuscardpayment
    ADD CONSTRAINT pa_siebelbonuscardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_siebelbonusesasgiftpayment pa_siebelbonusesasgiftpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_siebelbonusesasgiftpayment
    ADD CONSTRAINT pa_siebelbonusesasgiftpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_siebelgiftcardpayment pa_siebelgiftcardpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_siebelgiftcardpayment
    ADD CONSTRAINT pa_siebelgiftcardpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_voucherpayment pa_voucherpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_voucherpayment
    ADD CONSTRAINT pa_voucherpayment_pkey PRIMARY KEY (id);


--
-- Name: ch_transaction ps_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_transaction
    ADD CONSTRAINT ps_transaction_pkey PRIMARY KEY (id);


--
-- Name: ch_payment_property_name uniq_us_user__tab_num; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_property_name
    ADD CONSTRAINT uniq_us_user__tab_num UNIQUE (prop_name);


--
-- Name: ch_payment_transaction_id_payment_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ch_payment_transaction_id_payment_idx ON public.ch_payment_transaction USING btree (id_payment);


--
-- Name: ch_payment_transaction_id_purchase_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ch_payment_transaction_id_purchase_idx ON public.ch_payment_transaction USING btree (id_purchase);


--
-- Name: ch_purchase_cards_id_position_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ch_purchase_cards_id_position_idx ON public.ch_purchase_cards USING btree (id_position);


--
-- Name: ch_purchase_excise_bottle_id_position_spirits; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ch_purchase_excise_bottle_id_position_spirits ON public.ch_purchase_excise_bottle USING btree (id_position_spirits);


--
-- Name: ch_purchase_ext_data_id_purchase_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ch_purchase_ext_data_id_purchase_idx ON public.ch_purchase_ext_data USING btree (id_purchase);


--
-- Name: ch_purchase_storno_id_purchase_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ch_purchase_storno_id_purchase_idx ON public.ch_purchase_storno USING btree (id_purchase);


--
-- Name: idx_ch_introduction__id_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_introduction__id_session ON public.ch_introduction USING btree (id_session);


--
-- Name: idx_ch_introduction__id_shift; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_introduction__id_shift ON public.ch_introduction USING btree (id_shift);


--
-- Name: idx_ch_inventory__id_withdrawal; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_inventory__id_withdrawal ON public.ch_inventory USING btree (id_withdrawal);


--
-- Name: idx_ch_manual_position_adv_action__id_position; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_manual_position_adv_action__id_position ON public.ch_manual_position_adv_action USING btree (id_position);


--
-- Name: idx_ch_payment__id_purchase; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_payment__id_purchase ON public.ch_payment USING btree (id_purchase);


--
-- Name: idx_ch_position__id_purchase; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_position__id_purchase ON public.ch_position USING btree (id_purchase);


--
-- Name: idx_ch_position_measure_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_position_measure_code ON public.ch_position USING btree (measure_code);


--
-- Name: idx_ch_prisma_events_eventdate; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_prisma_events_eventdate ON public.ch_prisma_events USING btree (eventdate);


--
-- Name: idx_ch_purchase__id_purchaseref; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_purchase__id_purchaseref ON public.ch_purchase USING btree (id_purchaseref);


--
-- Name: idx_ch_purchase__id_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_purchase__id_session ON public.ch_purchase USING btree (id_session);


--
-- Name: idx_ch_purchase__id_shift; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_purchase__id_shift ON public.ch_purchase USING btree (id_shift);


--
-- Name: idx_ch_purchase_cards__id_purchase; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_purchase_cards__id_purchase ON public.ch_purchase_cards USING btree (id_purchase);


--
-- Name: idx_ch_purchase_excise_bottle__id_purchase; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_purchase_excise_bottle__id_purchase ON public.ch_purchase_excise_bottle USING btree (id_purchase);


--
-- Name: idx_ch_purchase_taxes_id_purchase; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_purchase_taxes_id_purchase ON public.ch_purchase_taxes USING btree (id_purchase);


--
-- Name: idx_ch_reportshift__id_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_reportshift__id_session ON public.ch_reportshift USING btree (id_session);


--
-- Name: idx_ch_reportshift__id_shift; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_reportshift__id_shift ON public.ch_reportshift USING btree (id_shift);


--
-- Name: idx_ch_reportshift_taxes__id_report; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_reportshift_taxes__id_report ON public.ch_reportshift_taxes USING btree (id_report);


--
-- Name: idx_ch_reportsshift_payments__id_report; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_reportsshift_payments__id_report ON public.ch_reportsshift_payments USING btree (id_report);


--
-- Name: idx_ch_reportsshift_products__id_report; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_reportsshift_products__id_report ON public.ch_reportsshift_products USING btree (id_report);


--
-- Name: idx_ch_session__user_tabnum; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_session__user_tabnum ON public.ch_session USING btree (user_tabnum);


--
-- Name: idx_ch_shift__id_sessionstart; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_shift__id_sessionstart ON public.ch_shift USING btree (id_sessionstart);


--
-- Name: idx_ch_withdrawal__id_session; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_withdrawal__id_session ON public.ch_withdrawal USING btree (id_session);


--
-- Name: idx_ch_withdrawal__id_shift; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ch_withdrawal__id_shift ON public.ch_withdrawal USING btree (id_shift);


--
-- Name: idx_ps_transaction__id_position; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ps_transaction__id_position ON public.ch_transaction USING btree (id_position);


--
-- Name: ix_ch_payment_property_payment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_ch_payment_property_payment_id ON public.ch_payment_property USING btree (payment_id);


--
-- Name: ch_reportsshift_payments FK_ch_reportshift_payment_types_ch_reportshift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportsshift_payments
    ADD CONSTRAINT "FK_ch_reportshift_payment_types_ch_reportshift" FOREIGN KEY (id_report) REFERENCES public.ch_reportshift(id) ON DELETE CASCADE;


--
-- Name: ch_reportsshift_products FK_ch_reportshift_product_types_ch_reportshift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportsshift_products
    ADD CONSTRAINT "FK_ch_reportshift_product_types_ch_reportshift" FOREIGN KEY (id_report) REFERENCES public.ch_reportshift(id) ON DELETE CASCADE;


--
-- Name: ch_bankcardpayment_transaction fk_ch_bankcardpayment_transaction__payment_trans; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_bankcardpayment_transaction
    ADD CONSTRAINT fk_ch_bankcardpayment_transaction__payment_trans FOREIGN KEY (id) REFERENCES public.ch_payment_transaction(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ch_bonussberbankpayment fk_ch_bonussberbankpayment_ch_payment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_bonussberbankpayment
    ADD CONSTRAINT fk_ch_bonussberbankpayment_ch_payment_id FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_bankcardpayment fk_ch_payment__ch_bankcardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_bankcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_bankcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_bonuscardpayment fk_ch_payment__ch_bonuscardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_bonuscardpayment
    ADD CONSTRAINT fk_ch_payment__ch_bonuscardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_cashpayment fk_ch_payment__ch_cashpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_cashpayment
    ADD CONSTRAINT fk_ch_payment__ch_cashpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_cft_giftcardpayment fk_ch_payment__ch_cft_giftcardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_cft_giftcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_cft_giftcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_cft_giftegcpayment fk_ch_payment__ch_cft_giftegcpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_cft_giftegcpayment
    ADD CONSTRAINT fk_ch_payment__ch_cft_giftegcpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ch_childrencardpayment fk_ch_payment__ch_childrencardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_childrencardpayment
    ADD CONSTRAINT fk_ch_payment__ch_childrencardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_externalbankterminalpayment fk_ch_payment__ch_externalbankterminalpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_externalbankterminalpayment
    ADD CONSTRAINT fk_ch_payment__ch_externalbankterminalpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_giftcardpayment fk_ch_payment__ch_giftcardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_giftcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_giftcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_internalcreditcardpayment fk_ch_payment__ch_internalcreditcardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_internalcreditcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_internalcreditcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_kopilkabonuscardpayment fk_ch_payment__ch_kopilkabonuscardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_kopilkabonuscardpayment
    ADD CONSTRAINT fk_ch_payment__ch_kopilkabonuscardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_prepayment fk_ch_payment__ch_prepayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_prepayment
    ADD CONSTRAINT fk_ch_payment__ch_prepayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_siebelbonuscardpayment fk_ch_payment__ch_siebelbonuscardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_siebelbonuscardpayment
    ADD CONSTRAINT fk_ch_payment__ch_siebelbonuscardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_siebelbonusesasgiftpayment fk_ch_payment__ch_siebelbonusesasgiftpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_siebelbonusesasgiftpayment
    ADD CONSTRAINT fk_ch_payment__ch_siebelbonusesasgiftpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_siebelgiftcardpayment fk_ch_payment__ch_siebelgiftcardpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_siebelgiftcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_siebelgiftcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_suprapayment fk_ch_payment__ch_suprapayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_suprapayment
    ADD CONSTRAINT fk_ch_payment__ch_suprapayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ch_voucherpayment fk_ch_payment__ch_voucherpayment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_voucherpayment
    ADD CONSTRAINT fk_ch_payment__ch_voucherpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;


--
-- Name: ch_payment_property fk_ch_payment_property__ch_payment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_property
    ADD CONSTRAINT fk_ch_payment_property__ch_payment FOREIGN KEY (payment_id) REFERENCES public.ch_payment(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ch_payment_property fk_ch_payment_property__ch_payment_property_name; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_property
    ADD CONSTRAINT fk_ch_payment_property__ch_payment_property_name FOREIGN KEY (name_id) REFERENCES public.ch_payment_property_name(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ch_payment_transaction fk_ch_payment_transaction__ch_payment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_transaction
    ADD CONSTRAINT fk_ch_payment_transaction__ch_payment FOREIGN KEY (id_payment) REFERENCES public.ch_payment(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ch_payment_transaction fk_ch_payment_transaction__ch_purchase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_transaction
    ADD CONSTRAINT fk_ch_payment_transaction__ch_purchase FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ch_payment_transaction_slip fk_ch_payment_transaction_slip__payment_trans; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment_transaction_slip
    ADD CONSTRAINT fk_ch_payment_transaction_slip__payment_trans FOREIGN KEY (payment_transaction_id) REFERENCES public.ch_payment_transaction(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ch_position_clothing fk_ch_position__ch_clothing; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_clothing
    ADD CONSTRAINT fk_ch_position__ch_clothing FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_position_license_key fk_ch_position__ch_license_key; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_license_key
    ADD CONSTRAINT fk_ch_position__ch_license_key FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_manual_position_adv_action fk_ch_position__ch_manual_position_adv_action; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_manual_position_adv_action
    ADD CONSTRAINT fk_ch_position__ch_manual_position_adv_action FOREIGN KEY (id_position) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_position_cft_giftcard fk_ch_position__ch_position_cft_giftcard; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_cft_giftcard
    ADD CONSTRAINT fk_ch_position__ch_position_cft_giftcard FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_position_exist_balance fk_ch_position__ch_position_exist_balance; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_exist_balance
    ADD CONSTRAINT fk_ch_position__ch_position_exist_balance FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_position_siebel_giftcard fk_ch_position__ch_position_siebel_giftcard; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_siebel_giftcard
    ADD CONSTRAINT fk_ch_position__ch_position_siebel_giftcard FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_positiongiftcard fk_ch_position__ch_positiongiftcard; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_positiongiftcard
    ADD CONSTRAINT fk_ch_position__ch_positiongiftcard FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_positionservice fk_ch_position__ch_positionservice; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_positionservice
    ADD CONSTRAINT fk_ch_position__ch_positionservice FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_positionspirits fk_ch_position__ch_positionspirits; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_positionspirits
    ADD CONSTRAINT fk_ch_position__ch_positionspirits FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_purchase_cards fk_ch_position__ch_purchase_cards; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_cards
    ADD CONSTRAINT fk_ch_position__ch_purchase_cards FOREIGN KEY (id_position) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_position fk_ch_position_ch_position_measure_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position
    ADD CONSTRAINT fk_ch_position_ch_position_measure_code FOREIGN KEY (measure_code) REFERENCES public.ch_position_measure(code);


--
-- Name: ch_position_discount_card fk_ch_position_discount_card__ch_position; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_discount_card
    ADD CONSTRAINT fk_ch_position_discount_card__ch_position FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;


--
-- Name: ch_positionmobilepay fk_ch_positionservice__ch_positionmobilepay; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_positionmobilepay
    ADD CONSTRAINT fk_ch_positionservice__ch_positionmobilepay FOREIGN KEY (id) REFERENCES public.ch_positionservice(id) ON DELETE CASCADE;


--
-- Name: ch_transaction fk_ch_positionservice__ch_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_transaction
    ADD CONSTRAINT fk_ch_positionservice__ch_transaction FOREIGN KEY (id_position) REFERENCES public.ch_positionservice(id) ON DELETE CASCADE;


--
-- Name: ch_payment fk_ch_purchase__ch_payment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_payment
    ADD CONSTRAINT fk_ch_purchase__ch_payment FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;


--
-- Name: ch_position fk_ch_purchase__ch_position; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position
    ADD CONSTRAINT fk_ch_purchase__ch_position FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;


--
-- Name: ch_purchase fk_ch_purchase__ch_purchase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase
    ADD CONSTRAINT fk_ch_purchase__ch_purchase FOREIGN KEY (id_purchaseref) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;


--
-- Name: ch_purchase_cards fk_ch_purchase__ch_purchase_cards; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_cards
    ADD CONSTRAINT fk_ch_purchase__ch_purchase_cards FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;


--
-- Name: ch_purchase_taxes fk_ch_purchase__ch_purchase_taxes; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_taxes
    ADD CONSTRAINT fk_ch_purchase__ch_purchase_taxes FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;


--
-- Name: ch_purchase_excise_bottle fk_ch_purchase_excise_bottle__ch_position; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_excise_bottle
    ADD CONSTRAINT fk_ch_purchase_excise_bottle__ch_position FOREIGN KEY (id_position_spirits) REFERENCES public.ch_positionspirits(id) ON DELETE CASCADE;


--
-- Name: ch_purchase_excise_bottle fk_ch_purchase_excise_bottle__ch_purchase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_excise_bottle
    ADD CONSTRAINT fk_ch_purchase_excise_bottle__ch_purchase FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;


--
-- Name: ch_purchase_ext_data fk_ch_purchase_ext_data_pkey__ch_purchase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_ext_data
    ADD CONSTRAINT fk_ch_purchase_ext_data_pkey__ch_purchase FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;


--
-- Name: ch_purchase_storno fk_ch_purchase_storno__ch_purchase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase_storno
    ADD CONSTRAINT fk_ch_purchase_storno__ch_purchase FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;


--
-- Name: ch_reportshift_taxes fk_ch_reportshift__ch_reportshift_taxes; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportshift_taxes
    ADD CONSTRAINT fk_ch_reportshift__ch_reportshift_taxes FOREIGN KEY (id_report) REFERENCES public.ch_reportshift(id) ON DELETE CASCADE;


--
-- Name: ch_introduction fk_ch_session__ch_introduction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_introduction
    ADD CONSTRAINT fk_ch_session__ch_introduction FOREIGN KEY (id_session) REFERENCES public.ch_session(id) ON DELETE CASCADE;


--
-- Name: ch_purchase fk_ch_session__ch_purchase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase
    ADD CONSTRAINT fk_ch_session__ch_purchase FOREIGN KEY (id_session) REFERENCES public.ch_session(id);


--
-- Name: ch_reportshift fk_ch_session__ch_reportshift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportshift
    ADD CONSTRAINT fk_ch_session__ch_reportshift FOREIGN KEY (id_session) REFERENCES public.ch_session(id);


--
-- Name: ch_shift fk_ch_session__ch_shift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_shift
    ADD CONSTRAINT fk_ch_session__ch_shift FOREIGN KEY (id_sessionstart) REFERENCES public.ch_session(id);


--
-- Name: ch_withdrawal fk_ch_session__ch_withdrawal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_withdrawal
    ADD CONSTRAINT fk_ch_session__ch_withdrawal FOREIGN KEY (id_session) REFERENCES public.ch_session(id);


--
-- Name: ch_introduction fk_ch_shift__ch_introduction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_introduction
    ADD CONSTRAINT fk_ch_shift__ch_introduction FOREIGN KEY (id_shift) REFERENCES public.ch_shift(id) ON DELETE CASCADE;


--
-- Name: ch_purchase fk_ch_shift__ch_purchase; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_purchase
    ADD CONSTRAINT fk_ch_shift__ch_purchase FOREIGN KEY (id_shift) REFERENCES public.ch_shift(id) ON DELETE CASCADE;


--
-- Name: ch_reportshift fk_ch_shift__ch_reportshift; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_reportshift
    ADD CONSTRAINT fk_ch_shift__ch_reportshift FOREIGN KEY (id_shift) REFERENCES public.ch_shift(id) ON DELETE CASCADE;


--
-- Name: ch_withdrawal fk_ch_shift__ch_withdrawal; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_withdrawal
    ADD CONSTRAINT fk_ch_shift__ch_withdrawal FOREIGN KEY (id_shift) REFERENCES public.ch_shift(id) ON DELETE CASCADE;


--
-- Name: ch_session fk_ch_user__ch_session; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_session
    ADD CONSTRAINT fk_ch_user__ch_session FOREIGN KEY (user_tabnum) REFERENCES public.ch_user(tabnum);


--
-- Name: ch_inventory fk_ch_withdrawal__ch_inventory; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_inventory
    ADD CONSTRAINT fk_ch_withdrawal__ch_inventory FOREIGN KEY (id_withdrawal) REFERENCES public.ch_withdrawal(id) ON DELETE CASCADE;


--
-- Name: ch_position_production_date position_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position_production_date
    ADD CONSTRAINT position_fkey FOREIGN KEY (position_id) REFERENCES public.ch_position(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ch_position seller_position_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ch_position
    ADD CONSTRAINT seller_position_fkey FOREIGN KEY (seller) REFERENCES public.ch_position_seller(id);


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

