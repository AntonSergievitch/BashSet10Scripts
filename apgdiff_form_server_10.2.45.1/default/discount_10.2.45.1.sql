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
-- Name: discounts_action_plugin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts_action_plugin (
    id bigint NOT NULL,
    action_id bigint,
    class_name character varying(255) NOT NULL,
    type character varying(32) NOT NULL
);


ALTER TABLE public.discounts_action_plugin OWNER TO postgres;

--
-- Name: TABLE discounts_action_plugin; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.discounts_action_plugin IS 'Плагины, задействованные в РА (ActionPluginEntity)';


--
-- Name: COLUMN discounts_action_plugin.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin.id IS 'Первичный ключ';


--
-- Name: COLUMN discounts_action_plugin.action_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin.action_id IS 'Рекламная акция';


--
-- Name: COLUMN discounts_action_plugin.class_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin.class_name IS 'Полное имя класса этого плагина';


--
-- Name: COLUMN discounts_action_plugin.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin.type IS 'тип этого плагина: ACTION_RESULT/APPLY_OBJECT/CONDITIONAL_PLUGIN';


--
-- Name: discounts_action_plugin_property; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts_action_plugin_property (
    id bigint NOT NULL,
    plugin_id bigint,
    plugin_name character varying(512),
    name character varying(512) NOT NULL,
    value character varying(2048),
    type character varying(255),
    class_name character varying(255) NOT NULL,
    parent_id bigint,
    action_id bigint
);


ALTER TABLE public.discounts_action_plugin_property OWNER TO postgres;

--
-- Name: TABLE discounts_action_plugin_property; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.discounts_action_plugin_property IS 'Свойства плагина РА (ActionPluginPropertyEntity)';


--
-- Name: COLUMN discounts_action_plugin_property.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.id IS 'Первичный ключ';


--
-- Name: COLUMN discounts_action_plugin_property.plugin_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.plugin_id IS 'Плагин, к которому относится это свойство';


--
-- Name: COLUMN discounts_action_plugin_property.plugin_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.plugin_name IS 'Просто информационное поле';


--
-- Name: COLUMN discounts_action_plugin_property.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.name IS 'Название свойства';


--
-- Name: COLUMN discounts_action_plugin_property.value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.value IS 'Значение свойства';


--
-- Name: COLUMN discounts_action_plugin_property.type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.type IS 'Тип свойства';


--
-- Name: COLUMN discounts_action_plugin_property.class_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.class_name IS 'Java-class';


--
-- Name: COLUMN discounts_action_plugin_property.parent_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.parent_id IS 'Родительское свойство, по отношению к которому это является вложенным';


--
-- Name: COLUMN discounts_action_plugin_property.action_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_action_plugin_property.action_id IS 'Идентификатор рекламной акции';


--
-- Name: discounts_advertisingactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts_advertisingactions (
    id bigint NOT NULL,
    active boolean,
    allnodes boolean,
    description character varying(255),
    displaystylename character varying(255),
    guid bigint,
    lastchanges timestamp without time zone,
    modefield integer,
    name character varying(255),
    parentguid bigint,
    priority double precision,
    userestrictions boolean,
    version integer NOT NULL,
    periodfinish timestamp without time zone,
    periodstart timestamp without time zone,
    worksanytime boolean,
    external_code character varying(255),
    discount_type character varying(255),
    pricetag_mask smallint DEFAULT 0 NOT NULL,
    exempt_from_bonus_discounts boolean,
    author character varying(255),
    editor character varying(255),
    disable_charge_on_bonuses boolean,
    ti character varying(255)
);


ALTER TABLE public.discounts_advertisingactions OWNER TO postgres;

--
-- Name: TABLE discounts_advertisingactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.discounts_advertisingactions IS 'Рекламные акции (AdvertisingActionEntity)';


--
-- Name: COLUMN discounts_advertisingactions.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.id IS 'Первичный ключ';


--
-- Name: COLUMN discounts_advertisingactions.active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.active IS '(добавить описание)';


--
-- Name: COLUMN discounts_advertisingactions.allnodes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.allnodes IS 'Действует во всей сети (все магазины)?';


--
-- Name: COLUMN discounts_advertisingactions.description; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.description IS 'Описание рекалмной акции';


--
-- Name: COLUMN discounts_advertisingactions.displaystylename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.displaystylename IS '(добавить описание)';


--
-- Name: COLUMN discounts_advertisingactions.guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.guid IS 'Глобальный уникальный идентификатор';


--
-- Name: COLUMN discounts_advertisingactions.lastchanges; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.lastchanges IS 'Дата/время последних изменений в акции';


--
-- Name: COLUMN discounts_advertisingactions.modefield; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.modefield IS 'Условие применения скидки: Автоматическая, Ручная, Безусловная';


--
-- Name: COLUMN discounts_advertisingactions.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.name IS 'Название рекламной акции';


--
-- Name: COLUMN discounts_advertisingactions.parentguid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.parentguid IS '(добавить описание)';


--
-- Name: COLUMN discounts_advertisingactions.priority; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.priority IS 'Приоритет применения этой акции; используется при расчёте скидок';


--
-- Name: COLUMN discounts_advertisingactions.userestrictions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.userestrictions IS '(добавить описание)';


--
-- Name: COLUMN discounts_advertisingactions.version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.version IS 'Технологическое поле - для OptimisticLock';


--
-- Name: COLUMN discounts_advertisingactions.periodfinish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.periodfinish IS 'Окончание действия акции';


--
-- Name: COLUMN discounts_advertisingactions.periodstart; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.periodstart IS 'Начало действия акции';


--
-- Name: COLUMN discounts_advertisingactions.worksanytime; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.worksanytime IS 'Без ограничения периода действия';


--
-- Name: COLUMN discounts_advertisingactions.external_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.external_code IS 'Внешний код рекламной акции (определяется внешней системой, в которой акция была создана)';


--
-- Name: COLUMN discounts_advertisingactions.discount_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.discount_type IS 'Тип скидки (тип рекламной акции); в настоящей версии - тип скидки в Set5';


--
-- Name: COLUMN discounts_advertisingactions.pricetag_mask; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.pricetag_mask IS 'Битовая маска, определяющая типы ценников, что надо распечатать на данную РА. Биты: 0/1/2 == акционный/дополнительный/замещающий ценник';


--
-- Name: COLUMN discounts_advertisingactions.exempt_from_bonus_discounts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.exempt_from_bonus_discounts IS 'Флаг-признак, указывающий на то, что на товары, на которые сработала данная РА, нельзя давать скидки типа "бонусы как скидка". NULL распознается как FALSE';


--
-- Name: COLUMN discounts_advertisingactions.author; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.author IS 'Login автора (создателя) данной РА. Если NULL - значит, РА была создана в результате импорта из ERP';


--
-- Name: COLUMN discounts_advertisingactions.editor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.editor IS 'Login последнего пользователя, что редактировал данную РА. Если NULL - значит, РА была изменена в результате импорта из ERP';


--
-- Name: COLUMN discounts_advertisingactions.disable_charge_on_bonuses; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.disable_charge_on_bonuses IS 'Флаг-признак, запрещающий начисление бонусных баллов на товары, на которые сработала данная РА';


--
-- Name: COLUMN discounts_advertisingactions.ti; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions.ti IS 'Идентификатор транспортного пакета';


--
-- Name: discounts_advertisingactions_masteractionguids; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts_advertisingactions_masteractionguids (
    discounts_advertisingactions_id bigint NOT NULL,
    element bigint
);


ALTER TABLE public.discounts_advertisingactions_masteractionguids OWNER TO postgres;

--
-- Name: TABLE discounts_advertisingactions_masteractionguids; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.discounts_advertisingactions_masteractionguids IS 'Рекламные акции с мастер-GUID';


--
-- Name: discounts_advertisingactions_pricetags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts_advertisingactions_pricetags (
    action_id bigint NOT NULL,
    pricetag_ext_code character varying(255) NOT NULL,
    count smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.discounts_advertisingactions_pricetags OWNER TO postgres;

--
-- Name: TABLE discounts_advertisingactions_pricetags; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.discounts_advertisingactions_pricetags IS 'Привязки РА к шаблонам ценников, на которых содержимое этой РА можно распечатать по умолчанию (AdvertisingActionEntity#pricetagTemplateCodes)';


--
-- Name: COLUMN discounts_advertisingactions_pricetags.action_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions_pricetags.action_id IS 'ID РА - см. discounts_advertisingactions.id';


--
-- Name: COLUMN discounts_advertisingactions_pricetags.pricetag_ext_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions_pricetags.pricetag_ext_code IS 'Внешний код шаблона ценника - см. un_cg_pricetag.ext_code';


--
-- Name: COLUMN discounts_advertisingactions_pricetags.count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_advertisingactions_pricetags.count IS 'количество цеников этого шаблона, что надо распечатать по умолчнию';


--
-- Name: discounts_advertisingactions_resulttypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts_advertisingactions_resulttypes (
    discounts_advertisingactions_id bigint NOT NULL,
    element integer
);


ALTER TABLE public.discounts_advertisingactions_resulttypes OWNER TO postgres;

--
-- Name: TABLE discounts_advertisingactions_resulttypes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.discounts_advertisingactions_resulttypes IS 'Тип результата рекламной акции';


--
-- Name: discounts_topology_condition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts_topology_condition (
    id bigint NOT NULL,
    action_id bigint NOT NULL,
    location_type character varying(20),
    location_code bigint
);


ALTER TABLE public.discounts_topology_condition OWNER TO postgres;

--
-- Name: TABLE discounts_topology_condition; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.discounts_topology_condition IS 'Список правил, накладывающих ограничения на область применения рекламной акции (CoverageAreaEntity)';


--
-- Name: COLUMN discounts_topology_condition.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_topology_condition.id IS 'Первичный ключ';


--
-- Name: COLUMN discounts_topology_condition.action_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_topology_condition.action_id IS 'Рекламная акция, к которой прицеплено это ограничение (по зоне охвата)';


--
-- Name: COLUMN discounts_topology_condition.location_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_topology_condition.location_type IS 'Тип области действия ограничения: Регион, Город, Магазин';


--
-- Name: COLUMN discounts_topology_condition.location_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_topology_condition.location_code IS 'Код области (типа location_type) - код конкретного Региона, Города, Магазина';


--
-- Name: discounts_topology_condition_formats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts_topology_condition_formats (
    discounts_topology_condition_id bigint NOT NULL,
    element bigint NOT NULL
);


ALTER TABLE public.discounts_topology_condition_formats OWNER TO postgres;

--
-- Name: TABLE discounts_topology_condition_formats; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.discounts_topology_condition_formats IS 'Список кодов форматов магазинов, на которые распространяется родительское правило';


--
-- Name: COLUMN discounts_topology_condition_formats.discounts_topology_condition_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_topology_condition_formats.discounts_topology_condition_id IS 'Ссылка на правило-родитель';


--
-- Name: COLUMN discounts_topology_condition_formats.element; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.discounts_topology_condition_formats.element IS 'Код формата магазина';


--
-- Name: formats_advertisingactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formats_advertisingactions (
    action_id bigint NOT NULL,
    format_ext_code character varying(255) NOT NULL
);


ALTER TABLE public.formats_advertisingactions OWNER TO postgres;

--
-- Name: TABLE formats_advertisingactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.formats_advertisingactions IS 'Таблица привязки форматов к акциям';


--
-- Name: COLUMN formats_advertisingactions.action_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.formats_advertisingactions.action_id IS 'Первичный ключ акции';


--
-- Name: COLUMN formats_advertisingactions.format_ext_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.formats_advertisingactions.format_ext_code IS 'Внешний код формата';


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
-- Name: loy_adv_action_in_purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_adv_action_in_purchase (
    guid bigint NOT NULL,
    action_name character varying(512) NOT NULL,
    action_type character varying(128) NOT NULL,
    apply_mode character varying(128) NOT NULL,
    external_code character varying(255),
    discount_type character varying(255)
);


ALTER TABLE public.loy_adv_action_in_purchase OWNER TO postgres;

--
-- Name: TABLE loy_adv_action_in_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_adv_action_in_purchase IS 'Примененные в чеках Рекламные акции (LoyAdvActionInPurchaseEntity)';


--
-- Name: COLUMN loy_adv_action_in_purchase.guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_adv_action_in_purchase.guid IS 'Идентификатор акции';


--
-- Name: COLUMN loy_adv_action_in_purchase.action_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_adv_action_in_purchase.action_name IS 'Название Рекламной акции';


--
-- Name: COLUMN loy_adv_action_in_purchase.action_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_adv_action_in_purchase.action_type IS 'Тип Рекламной акции (Set – набор, FixPrice – фиксированная цена, Composite – Составной объект, Discount – все остальные скидки)';


--
-- Name: COLUMN loy_adv_action_in_purchase.apply_mode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_adv_action_in_purchase.apply_mode IS 'Способ срабатывания рекламной акции';


--
-- Name: COLUMN loy_adv_action_in_purchase.external_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_adv_action_in_purchase.external_code IS 'Внешний код рекламной акции (определяется внешней системой, в которой акция была создана)';


--
-- Name: COLUMN loy_adv_action_in_purchase.discount_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_adv_action_in_purchase.discount_type IS 'Тип скидки (тип рекламной акции); в настоящей версии - тип скидки в Set5';


--
-- Name: loy_bonus_plastek_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_bonus_plastek_transaction (
    id bigint NOT NULL,
    transaction_id bigint,
    card_number character varying(16) NOT NULL,
    bns_change bigint,
    check_number integer NOT NULL,
    shift_number integer NOT NULL,
    loy_transaction_id bigint NOT NULL
);


ALTER TABLE public.loy_bonus_plastek_transaction OWNER TO postgres;

--
-- Name: TABLE loy_bonus_plastek_transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_bonus_plastek_transaction IS 'Списания и начисления бонусов Plas Tek (LoyBonusPlastekTransactionEntity)';


--
-- Name: COLUMN loy_bonus_plastek_transaction.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_plastek_transaction.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_bonus_plastek_transaction.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_plastek_transaction.transaction_id IS 'Идентификатор транзакции (на стороне процессинга Plas Tek), по которому произошло это изменение балланса бонусной карты';


--
-- Name: COLUMN loy_bonus_plastek_transaction.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_plastek_transaction.card_number IS 'Номер карты, чей балланс поменялся в результате этой транзакции начисления/списания бонусов';


--
-- Name: COLUMN loy_bonus_plastek_transaction.bns_change; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_plastek_transaction.bns_change IS 'Изменение счета доступных бонусов (целое число в бонусокопейках, положительное или отрицательное)';


--
-- Name: COLUMN loy_bonus_plastek_transaction.check_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_plastek_transaction.check_number IS 'Номер чека, при процессинге которого была проведена эта транзакция (списания/начисления)';


--
-- Name: COLUMN loy_bonus_plastek_transaction.shift_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_plastek_transaction.shift_number IS 'Номер смены, в которой была проведена эта операция списания/начисления';


--
-- Name: COLUMN loy_bonus_plastek_transaction.loy_transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_plastek_transaction.loy_transaction_id IS 'Сама транзакция лояльности, в рамках которой выполнена эта операция изменения бонусного балланса карты Plas Tek, - со всеми начисленными скидками на чек';


--
-- Name: loy_bonus_positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_bonus_positions (
    id bigint NOT NULL,
    bonus_amount bigint NOT NULL,
    good_code character varying(255) NOT NULL,
    position_order integer NOT NULL,
    advert_act_guid bigint NOT NULL,
    transaction_id bigint
);


ALTER TABLE public.loy_bonus_positions OWNER TO postgres;

--
-- Name: TABLE loy_bonus_positions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_bonus_positions IS 'Детализация начисления/списания бонусов по позициям в чеке (LoyBonusPositionEntity)';


--
-- Name: COLUMN loy_bonus_positions.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_positions.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_bonus_positions.bonus_amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_positions.bonus_amount IS 'Сумма начисленных баллов';


--
-- Name: COLUMN loy_bonus_positions.good_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_positions.good_code IS 'Код товара';


--
-- Name: COLUMN loy_bonus_positions.position_order; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_positions.position_order IS 'Номер позиции, на которую начислен/списан этот бонус';


--
-- Name: COLUMN loy_bonus_positions.advert_act_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_positions.advert_act_guid IS 'Сработавшая РА';


--
-- Name: COLUMN loy_bonus_positions.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_positions.transaction_id IS 'Транзакция/покупка, при которой был начислен/списан этот бонус';


--
-- Name: loy_bonus_sberbank_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_bonus_sberbank_transaction (
    id bigint NOT NULL,
    transaction_id character varying(50) NOT NULL,
    transaction_type integer NOT NULL,
    transaction_date timestamp without time zone NOT NULL,
    mode integer NOT NULL,
    amount bigint NOT NULL,
    client_id character varying(128) NOT NULL,
    pan_4 character varying(19) NOT NULL,
    terminal character varying(100) NOT NULL,
    location character varying(50) NOT NULL,
    partner_id bigint NOT NULL,
    bns_change bigint,
    bns_delay_change bigint,
    loy_transaction_id bigint,
    user_id character varying(10) DEFAULT 'SOSB'::character varying NOT NULL
);


ALTER TABLE public.loy_bonus_sberbank_transaction OWNER TO postgres;

--
-- Name: TABLE loy_bonus_sberbank_transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_bonus_sberbank_transaction IS 'Транзакция начисления/списания/возврат по списанию/возврат по начислению бонусов через процессинг ЦФТ: "Спасибо от Сбербанка", бонусы ЦФТ, и проч.';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.transaction_id IS 'Внешний идентификатор транзакции в структуре запроса';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.transaction_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.transaction_type IS 'Тип транзакции (0 – списание бонусов, 1 – начисление бонусов, 2 – возврат по списанию, 3 – возврат по начислению)';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.transaction_date; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.transaction_date IS 'Дата и время транзакции с точностью до секунды';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.mode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.mode IS 'Режим выполнения транзакции (0 – online; 1 – offline)';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.amount IS 'Сумма транзакции (целое число в копейках)';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.client_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.client_id IS 'Идентификатор карты в транзакции (хэш SHA1(PAN))';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.pan_4; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.pan_4 IS 'Маскированный PAN карты';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.terminal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.terminal IS 'Идентификатор терминала';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.location; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.location IS 'Идентификатор точки';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.partner_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.partner_id IS 'Идентификатор партнера';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.bns_change; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.bns_change IS 'Изменение счета доступных бонусов (целое число в бонусокопейках, положительное или отрицательное)';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.bns_delay_change; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.bns_delay_change IS 'Изменение счета отложенных бонусов (целое число в бонусокопейках, положительное или отрицательное)';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.loy_transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.loy_transaction_id IS 'Внешний ключ на транзакцию расчётов';


--
-- Name: COLUMN loy_bonus_sberbank_transaction.user_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_sberbank_transaction.user_id IS 'Код пользователя процессинга ЦФТ, которому "принадлежит" это изменение бонусного баланса';


--
-- Name: loy_bonus_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_bonus_transactions (
    id bigint NOT NULL,
    bonus_account_type bigint NOT NULL,
    bonus_amount bigint NOT NULL,
    bonus_period_finish timestamp without time zone,
    bonus_period_start timestamp without time zone,
    discount_card character varying(256),
    advert_act_guid bigint NOT NULL,
    transaction_id bigint,
    sum_amount bigint,
    payment_sum bigint,
    auth_code text,
    sponsor_id text
);


ALTER TABLE public.loy_bonus_transactions OWNER TO postgres;

--
-- Name: TABLE loy_bonus_transactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_bonus_transactions IS 'Транзакции: начисления/списания бонусов (LoyBonusTransactionEntity)';


--
-- Name: COLUMN loy_bonus_transactions.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_bonus_transactions.bonus_account_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.bonus_account_type IS 'Код типа бонусного счета';


--
-- Name: COLUMN loy_bonus_transactions.bonus_amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.bonus_amount IS 'Сумма начисленных баллов';


--
-- Name: COLUMN loy_bonus_transactions.bonus_period_finish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.bonus_period_finish IS 'Дата окончания действия баллов';


--
-- Name: COLUMN loy_bonus_transactions.bonus_period_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.bonus_period_start IS 'Дата начала действия баллов';


--
-- Name: COLUMN loy_bonus_transactions.discount_card; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.discount_card IS 'Номер примененной карты';


--
-- Name: COLUMN loy_bonus_transactions.advert_act_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.advert_act_guid IS 'Сработавшая РА';


--
-- Name: COLUMN loy_bonus_transactions.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.transaction_id IS 'Транзакция/покупка, при которой был начислен/списан этот бонус';


--
-- Name: COLUMN loy_bonus_transactions.sum_amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.sum_amount IS 'Сумма начисленных баллов в деньгах';


--
-- Name: COLUMN loy_bonus_transactions.payment_sum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.payment_sum IS 'Сумма в копейках, с которой начислены рассчитаны бонусы';


--
-- Name: COLUMN loy_bonus_transactions.auth_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.auth_code IS 'Код авторизации';


--
-- Name: COLUMN loy_bonus_transactions.sponsor_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonus_transactions.sponsor_id IS 'Идентификатор поставщика скидки';


--
-- Name: loy_bonusdiscount_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_bonusdiscount_transactions (
    id bigint NOT NULL,
    bonus_transaction_id bytea NOT NULL,
    bonus_transaction_id_as_string character varying(255),
    transaction_id bigint
);


ALTER TABLE public.loy_bonusdiscount_transactions OWNER TO postgres;

--
-- Name: TABLE loy_bonusdiscount_transactions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_bonusdiscount_transactions IS 'Идентификатор (полученный от внешней системы) транзакции списания бонусов как скидки (LoyBonusDiscountTransactionEntity)';


--
-- Name: COLUMN loy_bonusdiscount_transactions.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonusdiscount_transactions.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_bonusdiscount_transactions.bonus_transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonusdiscount_transactions.bonus_transaction_id IS 'Идентификатор транзакции списания бонусов';


--
-- Name: COLUMN loy_bonusdiscount_transactions.bonus_transaction_id_as_string; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_bonusdiscount_transactions.bonus_transaction_id_as_string IS 'х.з. для чего надо. Наверно, только для того, чтоб выгружать в ERP?';


--
-- Name: loy_cheque_coupons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_cheque_coupons (
    id bigint NOT NULL,
    coupon_barcode character varying(256) NOT NULL,
    discount_procent integer,
    discount_sum bigint,
    advert_act_guid bigint,
    coupon_type_guid bigint,
    transaction_id bigint
);


ALTER TABLE public.loy_cheque_coupons OWNER TO postgres;

--
-- Name: TABLE loy_cheque_coupons; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_cheque_coupons IS 'Напечатанные на чеке купоны (LoyChequeCouponEntity)';


--
-- Name: COLUMN loy_cheque_coupons.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_cheque_coupons.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_cheque_coupons.coupon_barcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_cheque_coupons.coupon_barcode IS 'Напечатанный ШК';


--
-- Name: COLUMN loy_cheque_coupons.discount_procent; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_cheque_coupons.discount_procent IS 'Процент скидки, напечатанной на купоне';


--
-- Name: COLUMN loy_cheque_coupons.discount_sum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_cheque_coupons.discount_sum IS 'Сумма скидки, напечатанной на купоне';


--
-- Name: COLUMN loy_cheque_coupons.advert_act_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_cheque_coupons.advert_act_guid IS 'Сработавшая РА';


--
-- Name: COLUMN loy_cheque_coupons.coupon_type_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_cheque_coupons.coupon_type_guid IS 'GUID категории уникальных купонов, номер экземпляра которого представлен колонкой coupon_barcode. Заполняется только для уникальных купонов';


--
-- Name: COLUMN loy_cheque_coupons.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_cheque_coupons.transaction_id IS 'Транзакция/покупка, при которой был распечатан этот купон';


--
-- Name: loy_discount_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_discount_cards (
    id bigint NOT NULL,
    card_number character varying(256) NOT NULL,
    card_type character varying(100) NOT NULL,
    transaction_id bigint,
    advert_act_guid bigint NOT NULL
);


ALTER TABLE public.loy_discount_cards OWNER TO postgres;

--
-- Name: TABLE loy_discount_cards; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_discount_cards IS 'Примененные карты и купоны (при покупке) (LoyDiscountCardEntity)';


--
-- Name: COLUMN loy_discount_cards.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_cards.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_discount_cards.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_cards.card_number IS 'Номер примененной карты или купона';


--
-- Name: COLUMN loy_discount_cards.card_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_cards.card_type IS 'Тип карты из Enum [Coupon, CheckCoupon, InternalCard, ExternalCard]';


--
-- Name: COLUMN loy_discount_cards.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_cards.transaction_id IS 'Транзакция/покупка, при которой была применена эта карта';


--
-- Name: COLUMN loy_discount_cards.advert_act_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_cards.advert_act_guid IS 'Сработавшая РА';


--
-- Name: loy_discount_positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_discount_positions (
    id bigint NOT NULL,
    discount_amount bigint NOT NULL,
    good_code character varying(256) NOT NULL,
    is_discount_purchase boolean NOT NULL,
    position_order integer NOT NULL,
    advert_act_guid bigint NOT NULL,
    transaction_id bigint,
    qnty bigint,
    wre_qnty bigint,
    originalsetqnty bigint,
    discount_identifier character varying(32),
    discount_full_id character varying(255),
    card_number character varying(255),
    ext_tx_id character varying(255),
    pan character varying(255)
);


ALTER TABLE public.loy_discount_positions OWNER TO postgres;

--
-- Name: TABLE loy_discount_positions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_discount_positions IS 'Скидки на позицию (LoyDiscountPositionEntity)';


--
-- Name: COLUMN loy_discount_positions.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_discount_positions.discount_amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.discount_amount IS 'Сумма скидки';


--
-- Name: COLUMN loy_discount_positions.good_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.good_code IS 'Код товара';


--
-- Name: COLUMN loy_discount_positions.is_discount_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.is_discount_purchase IS 'Признак того, что данная скидка является частью размазанной скидки на чек';


--
-- Name: COLUMN loy_discount_positions.position_order; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.position_order IS 'Номер позиции';


--
-- Name: COLUMN loy_discount_positions.advert_act_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.advert_act_guid IS 'Сработавшая РА';


--
-- Name: COLUMN loy_discount_positions.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.transaction_id IS 'Транзакция/покупка, при которой была применена эта скидка';


--
-- Name: COLUMN loy_discount_positions.qnty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.qnty IS 'Количество товаров, на которые сработала скидка, в "граммах"';


--
-- Name: COLUMN loy_discount_positions.wre_qnty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.wre_qnty IS 'количество товара, на которое сработала скидка с точки зрения учета оптовых ограничений, в "граммах"';


--
-- Name: COLUMN loy_discount_positions.discount_identifier; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.discount_identifier IS 'Идентификатор скидки по данной позиции (уникальный код 3/4 цены, например)';


--
-- Name: COLUMN loy_discount_positions.discount_full_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.discount_full_id IS 'Вот это поле поможет определить по какому условию какого плагина ЭТОЙ РА (см. advert_act_guid) была дана ЭТА скидка';


--
-- Name: COLUMN loy_discount_positions.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.card_number IS 'Номер карты, по которой была дана эта скидка';


--
-- Name: COLUMN loy_discount_positions.ext_tx_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.ext_tx_id IS 'Идентификатор [внешней] транзакции лояльности, в рамках которой была дана эта скидка на позицию. Может заполняться, например, для скидок типа "бонусы как скидка": идентификатор транзакции, в рамках которой эти бонусы были списаны';


--
-- Name: COLUMN loy_discount_positions.pan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_discount_positions.pan IS 'PAN бонусной карты, по которой была дана эта скидка';


--
-- Name: loy_feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_feedback (
    receipt_id bigint NOT NULL,
    payload text,
    provider_id character varying(30) NOT NULL,
    feedback_time character varying(30) DEFAULT 'AFTER_FISCALIZE'::character varying NOT NULL,
    processing_name character varying(128),
    resend_count integer
);


ALTER TABLE public.loy_feedback OWNER TO postgres;

--
-- Name: TABLE loy_feedback; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_feedback IS 'Фидбэк(ответ) для сторонних поставщиков услуг лояльности по результатам расчета преференций на чек (LoyExtProviderFeedback)';


--
-- Name: COLUMN loy_feedback.receipt_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_feedback.receipt_id IS 'Идентификатор чека, при расчете преференций на который и был создан этот фидбэк. См. CASH.ch_purchase.id';


--
-- Name: COLUMN loy_feedback.payload; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_feedback.payload IS 'сама "полезная нагрузка" фидбэка';


--
-- Name: COLUMN loy_feedback.provider_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_feedback.provider_id IS 'Идентификатор стороннего поставщика лояльности, для которого создан этот фидбэк. Не может быть null';


--
-- Name: COLUMN loy_feedback.feedback_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_feedback.feedback_time IS 'Момент времени в техпроцессе оформления продажи чека, после наступления котрого можно отправить данный фидбэк';


--
-- Name: COLUMN loy_feedback.processing_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_feedback.processing_name IS 'Идентификатор процессинга, который находится в подчинении поставщика лояльности';


--
-- Name: COLUMN loy_feedback.resend_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_feedback.resend_count IS 'Количество переотправок отложенных фидбеков';


--
-- Name: loy_gift_note; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_gift_note (
    id bigint NOT NULL,
    advert_act_guid bigint,
    total_count integer DEFAULT 0 NOT NULL,
    loy_transaction_id bigint
);


ALTER TABLE public.loy_gift_note OWNER TO postgres;

--
-- Name: TABLE loy_gift_note; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_gift_note IS 'Информация о начисленных подарках ("смурфиках") по РА (LoyGiftNoteEnity)';


--
-- Name: COLUMN loy_gift_note.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_gift_note.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_gift_note.advert_act_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_gift_note.advert_act_guid IS 'Сработавшая РА, на основании которой были выданны эти "подарки"';


--
-- Name: COLUMN loy_gift_note.total_count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_gift_note.total_count IS 'Общее количество подарков/наклеек/смурфиков выданное по срабатыванию РА в чеке';


--
-- Name: COLUMN loy_gift_note.loy_transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_gift_note.loy_transaction_id IS 'Сама TX лояльности в рамках которой насчитаны эти подарки';


--
-- Name: loy_gift_note_by_cond; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_gift_note_by_cond (
    id bigint NOT NULL,
    parent bigint,
    cond_id character varying(255),
    calculated_qnty integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.loy_gift_note_by_cond OWNER TO postgres;

--
-- Name: TABLE loy_gift_note_by_cond; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_gift_note_by_cond IS 'Детализация информация о начисленных подарках ("смурфиках") по РА - в разрезе условий/калькуляторов количества подарков (LoyGiftNoteByConditionEnity)';


--
-- Name: COLUMN loy_gift_note_by_cond.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_gift_note_by_cond.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_gift_note_by_cond.parent; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_gift_note_by_cond.parent IS '"total" информации о начисленных подарках в чеке по РА (детализируемая информация данной записью)';


--
-- Name: COLUMN loy_gift_note_by_cond.cond_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_gift_note_by_cond.cond_id IS 'Идентификатор условия (уникален в рамках РА), по которому производилось начисление/расчет количества подарков.';


--
-- Name: COLUMN loy_gift_note_by_cond.calculated_qnty; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_gift_note_by_cond.calculated_qnty IS 'Расчетное количество "подарков" по данному условию';


--
-- Name: loy_lastdiscountsid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_lastdiscountsid (
    id bigint NOT NULL,
    deleted boolean NOT NULL,
    guid bigint NOT NULL,
    version smallint NOT NULL,
    discountid bigint,
    savedindb boolean,
    sendtoserver boolean
);


ALTER TABLE public.loy_lastdiscountsid OWNER TO postgres;

--
-- Name: TABLE loy_lastdiscountsid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_lastdiscountsid IS 'Идентификатор последней загруженной РА';


--
-- Name: loy_notsenddiscountsguid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_notsenddiscountsguid (
    id bigint NOT NULL,
    deleted boolean NOT NULL,
    guid bigint NOT NULL,
    version smallint NOT NULL,
    discountguid bigint
);


ALTER TABLE public.loy_notsenddiscountsguid OWNER TO postgres;

--
-- Name: TABLE loy_notsenddiscountsguid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_notsenddiscountsguid IS 'Не присланные РА по GUID';


--
-- Name: loy_processing_coupons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_processing_coupons (
    id bigint NOT NULL,
    card_number character varying(256) NOT NULL,
    coupon_barcode character varying(256) NOT NULL,
    coupon_prefix character varying(32) NOT NULL,
    date_finish timestamp without time zone,
    date_start timestamp without time zone NOT NULL,
    discount_amount bigint NOT NULL,
    max_discount bigint,
    discount_type integer NOT NULL,
    is_used boolean NOT NULL,
    advert_act_guid bigint,
    transaction_id bigint
);


ALTER TABLE public.loy_processing_coupons OWNER TO postgres;

--
-- Name: TABLE loy_processing_coupons; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_processing_coupons IS 'Обработанные купоны';


--
-- Name: COLUMN loy_processing_coupons.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.id IS 'первичный ключ';


--
-- Name: COLUMN loy_processing_coupons.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.card_number IS 'номер карты клиента, требующийся для применения купона. может быть NULL, если для применения не требуется карта';


--
-- Name: COLUMN loy_processing_coupons.coupon_barcode; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.coupon_barcode IS 'уникальный шрихкод купона';


--
-- Name: COLUMN loy_processing_coupons.date_finish; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.date_finish IS 'дата окончания действия купона, может быть NULL, если купон бессрочный';


--
-- Name: COLUMN loy_processing_coupons.date_start; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.date_start IS 'дата начала действия купона';


--
-- Name: COLUMN loy_processing_coupons.discount_amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.discount_amount IS 'величина скидки';


--
-- Name: COLUMN loy_processing_coupons.max_discount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.max_discount IS 'максимальный размер скидки по купону, в копейках';


--
-- Name: COLUMN loy_processing_coupons.discount_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.discount_type IS 'тип скидки, 
1 - процентная, 
2 - фиксированная сумма, 
3 - вычисление, сумма скидки текущего чека';


--
-- Name: COLUMN loy_processing_coupons.is_used; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.is_used IS 'признак использования купона';


--
-- Name: COLUMN loy_processing_coupons.advert_act_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.advert_act_guid IS 'идентификатор рекламной акции';


--
-- Name: COLUMN loy_processing_coupons.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_processing_coupons.transaction_id IS 'ссылка на транзакцию расчета скидок';


--
-- Name: loy_purchase_cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_purchase_cards (
    id bigint NOT NULL,
    card_number character varying(256) NOT NULL,
    card_type character varying(100) NOT NULL,
    transaction_id bigint
);


ALTER TABLE public.loy_purchase_cards OWNER TO postgres;

--
-- Name: TABLE loy_purchase_cards; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_purchase_cards IS 'Примененные карты и купоны (при покупке) (LoyDiscountCardEntity)';


--
-- Name: COLUMN loy_purchase_cards.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_purchase_cards.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_purchase_cards.card_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_purchase_cards.card_number IS 'Номер примененной карты или купона';


--
-- Name: COLUMN loy_purchase_cards.card_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_purchase_cards.card_type IS 'Тип карты из Enum [Coupon, CheckCoupon, InternalCard, ExternalCard]';


--
-- Name: COLUMN loy_purchase_cards.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_purchase_cards.transaction_id IS 'Транзакция/покупка, при которой была применена эта карта';


--
-- Name: loy_questionary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_questionary (
    id bigint NOT NULL,
    answer_boolean_type boolean,
    answer_number_type integer,
    question_number integer NOT NULL,
    advert_act_guid bigint NOT NULL,
    transaction_id bigint
);


ALTER TABLE public.loy_questionary OWNER TO postgres;

--
-- Name: TABLE loy_questionary; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_questionary IS 'Ответы на вопросы анкеты (LoyQuestionaryEntity)';


--
-- Name: COLUMN loy_questionary.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_questionary.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_questionary.answer_boolean_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_questionary.answer_boolean_type IS 'Ответ, если ответ на вопрос типа Да/Нет';


--
-- Name: COLUMN loy_questionary.answer_number_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_questionary.answer_number_type IS 'Ответ, если ответ на вопрос типа Число';


--
-- Name: COLUMN loy_questionary.question_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_questionary.question_number IS 'Номер вопроса';


--
-- Name: COLUMN loy_questionary.advert_act_guid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_questionary.advert_act_guid IS 'Сработавшая РА';


--
-- Name: COLUMN loy_questionary.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_questionary.transaction_id IS 'Транзакция/покупка, при которой был получен этот ответ на анкету';


--
-- Name: loy_set_api_loyalty_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_set_api_loyalty_transaction (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    bonus_transaction_id character varying(255) NOT NULL,
    processing_name character varying(255) NOT NULL
);


ALTER TABLE public.loy_set_api_loyalty_transaction OWNER TO postgres;

--
-- Name: COLUMN loy_set_api_loyalty_transaction.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_set_api_loyalty_transaction.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_set_api_loyalty_transaction.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_set_api_loyalty_transaction.transaction_id IS 'Сама транзакция лояльности';


--
-- Name: COLUMN loy_set_api_loyalty_transaction.bonus_transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_set_api_loyalty_transaction.bonus_transaction_id IS 'Идентификатор транзакции в внешней системе';


--
-- Name: COLUMN loy_set_api_loyalty_transaction.processing_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_set_api_loyalty_transaction.processing_name IS 'Идентификатор внешней системы';


--
-- Name: loy_tokens_siebel_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_tokens_siebel_transaction (
    id bigint NOT NULL,
    payment_option_id integer NOT NULL,
    ean character varying(255) NOT NULL,
    transaction_id bigint NOT NULL
);


ALTER TABLE public.loy_tokens_siebel_transaction OWNER TO postgres;

--
-- Name: TABLE loy_tokens_siebel_transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_tokens_siebel_transaction IS 'Списания марок Siebel (LoyTokenSiebelTransactionEntity)';


--
-- Name: COLUMN loy_tokens_siebel_transaction.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_tokens_siebel_transaction.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_tokens_siebel_transaction.payment_option_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_tokens_siebel_transaction.payment_option_id IS 'ID акции для списания (На стороне Siebel)';


--
-- Name: COLUMN loy_tokens_siebel_transaction.ean; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_tokens_siebel_transaction.ean IS 'Штрих-код акционного товара';


--
-- Name: COLUMN loy_tokens_siebel_transaction.transaction_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_tokens_siebel_transaction.transaction_id IS 'Сама транзакция лояльности';


--
-- Name: loy_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_transaction (
    id bigint NOT NULL,
    cash_number bigint NOT NULL,
    operation_type boolean NOT NULL,
    purchase_number bigint NOT NULL,
    sale_time timestamp without time zone NOT NULL,
    sent_to_server_status integer,
    shift_number bigint NOT NULL,
    shop_number bigint NOT NULL,
    status integer NOT NULL,
    transaction_time timestamp without time zone NOT NULL,
    discountvalue bigint NOT NULL,
    purchase_amount bigint DEFAULT 0 NOT NULL,
    filename character varying(255),
    need_send_to_erp boolean DEFAULT true NOT NULL,
    need_send_bonus boolean DEFAULT true NOT NULL,
    need_send_accumulation boolean DEFAULT true NOT NULL,
    purchase bigint,
    inn character varying(255)
);


ALTER TABLE public.loy_transaction OWNER TO postgres;

--
-- Name: TABLE loy_transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_transaction IS 'Транзакции/Проводки/Продажи (LoyTransactionEntity)';


--
-- Name: COLUMN loy_transaction.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_transaction.cash_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.cash_number IS 'Номер кассы';


--
-- Name: COLUMN loy_transaction.operation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.operation_type IS 'Тип операции продажа / возврат';


--
-- Name: COLUMN loy_transaction.purchase_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.purchase_number IS 'Номер чека';


--
-- Name: COLUMN loy_transaction.sale_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.sale_time IS 'Дата продажи';


--
-- Name: COLUMN loy_transaction.sent_to_server_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.sent_to_server_status IS 'Статус отправки на сервер';


--
-- Name: COLUMN loy_transaction.shift_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.shift_number IS 'Номер смены';


--
-- Name: COLUMN loy_transaction.shop_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.shop_number IS 'Номер магазина';


--
-- Name: COLUMN loy_transaction.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.status IS 'Статус транзакции. 0 – Подтверждена, 2 – Отменена';


--
-- Name: COLUMN loy_transaction.transaction_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.transaction_time IS 'Время создания транзакции';


--
-- Name: COLUMN loy_transaction.discountvalue; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.discountvalue IS 'Общая сумма скидки по чеку';


--
-- Name: COLUMN loy_transaction.purchase_amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.purchase_amount IS 'Сумма чека';


--
-- Name: COLUMN loy_transaction.filename; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.filename IS 'Имя файла, при отправке на сервер (полный относительный путь)';


--
-- Name: COLUMN loy_transaction.need_send_to_erp; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.need_send_to_erp IS 'Необходимость отправки в ERP';


--
-- Name: COLUMN loy_transaction.need_send_bonus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.need_send_bonus IS 'Необходимость отправки бонусов';


--
-- Name: COLUMN loy_transaction.need_send_accumulation; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.need_send_accumulation IS 'Необходимость отправки накоплений';


--
-- Name: COLUMN loy_transaction.purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.purchase IS ' Чек, при вычислении скидок на который, была создана эта транзакция';


--
-- Name: COLUMN loy_transaction.inn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction.inn IS 'ИНН смены в которой зарегистрирована транзакция';


--
-- Name: loy_transaction_purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_transaction_purchase (
    id bigint NOT NULL,
    shop bigint,
    cash bigint,
    shift bigint,
    doc_number bigint,
    sale_time timestamp without time zone,
    operation_type boolean,
    bottom_line_cost bigint,
    discount_value bigint
);


ALTER TABLE public.loy_transaction_purchase OWNER TO postgres;

--
-- Name: TABLE loy_transaction_purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_transaction_purchase IS 'Описывает покупку, на которую была создана транзакция лояльности (вычисление скидок) (LoyPurchaseEntity)';


--
-- Name: COLUMN loy_transaction_purchase.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_transaction_purchase.shop; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.shop IS 'Номер магазина, в котором была совершена эта покупка';


--
-- Name: COLUMN loy_transaction_purchase.cash; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.cash IS 'Номер кассы, на которой была совершена эта покупка';


--
-- Name: COLUMN loy_transaction_purchase.shift; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.shift IS 'Номер смены, в которую была совершена эта покупка';


--
-- Name: COLUMN loy_transaction_purchase.doc_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.doc_number IS 'Номер этого документа (чека продажи) в течение смены';


--
-- Name: COLUMN loy_transaction_purchase.sale_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.sale_time IS 'Дата и время совершения этой покупки (фискализации чека)';


--
-- Name: COLUMN loy_transaction_purchase.operation_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.operation_type IS 'Тип операции (продажа(true) / возврат(false))';


--
-- Name: COLUMN loy_transaction_purchase.bottom_line_cost; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.bottom_line_cost IS 'Итоговая сумма по чеку, в "копейках"';


--
-- Name: COLUMN loy_transaction_purchase.discount_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase.discount_value IS 'Полная сумма скидки по чеку, в "копейках"';


--
-- Name: loy_transaction_purchase_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_transaction_purchase_payment (
    id bigint NOT NULL,
    amount bigint,
    typeclass character varying(255),
    purchase bigint NOT NULL
);


ALTER TABLE public.loy_transaction_purchase_payment OWNER TO postgres;

--
-- Name: TABLE loy_transaction_purchase_payment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_transaction_purchase_payment IS 'Описывает оплату, что была использована при покупке (LoyPurchasePaymentEntity)';


--
-- Name: COLUMN loy_transaction_purchase_payment.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_payment.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_transaction_purchase_payment.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_payment.amount IS 'Сумма оплаты по данному виду платежа, в "копейках"';


--
-- Name: COLUMN loy_transaction_purchase_payment.typeclass; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_payment.typeclass IS 'Имя класса типа оплаты';


--
-- Name: COLUMN loy_transaction_purchase_payment.purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_payment.purchase IS 'Ссылка на чек';


--
-- Name: loy_transaction_purchase_position; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loy_transaction_purchase_position (
    id bigint NOT NULL,
    purchase bigint NOT NULL,
    position_order bigint DEFAULT 1 NOT NULL,
    depart_number bigint,
    good_code character varying(255),
    bar_code character varying(255),
    count bigint,
    cost bigint,
    cost_with_discount bigint,
    nds double precision,
    ndssum bigint,
    discount_value bigint,
    amount bigint,
    measure_code character varying(255)
);


ALTER TABLE public.loy_transaction_purchase_position OWNER TO postgres;

--
-- Name: TABLE loy_transaction_purchase_position; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.loy_transaction_purchase_position IS 'Описывает позицию в покупке (LoyPurchasePositionEntity)';


--
-- Name: COLUMN loy_transaction_purchase_position.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.id IS 'Первичный ключ';


--
-- Name: COLUMN loy_transaction_purchase_position.purchase; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.purchase IS 'покупка, к которой эта позиция относится';


--
-- Name: COLUMN loy_transaction_purchase_position.position_order; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.position_order IS 'Порядковый номер позиции в чеке';


--
-- Name: COLUMN loy_transaction_purchase_position.depart_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.depart_number IS 'Номер отдела, в котором продан товар в позиции';


--
-- Name: COLUMN loy_transaction_purchase_position.good_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.good_code IS 'Артикул товара';


--
-- Name: COLUMN loy_transaction_purchase_position.bar_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.bar_code IS 'Штрих код товара';


--
-- Name: COLUMN loy_transaction_purchase_position.count; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.count IS 'Количество товара, умноженное в 1000 раз (1 кг == 1000, 15 гр. == 15, 1 шт. == 1000)';


--
-- Name: COLUMN loy_transaction_purchase_position.cost; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.cost IS 'Цена без учёта скидки';


--
-- Name: COLUMN loy_transaction_purchase_position.cost_with_discount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.cost_with_discount IS 'Цена (с учётом скидок на позицию и размазанной скидки чека, если таковая была)';


--
-- Name: COLUMN loy_transaction_purchase_position.nds; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.nds IS 'НДС хранится в процентах';


--
-- Name: COLUMN loy_transaction_purchase_position.ndssum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.ndssum IS 'Сумма НДС, в "копейках"';


--
-- Name: COLUMN loy_transaction_purchase_position.discount_value; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.discount_value IS 'Значение скидки на позицию';


--
-- Name: COLUMN loy_transaction_purchase_position.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.amount IS 'Сумма по позиции';


--
-- Name: COLUMN loy_transaction_purchase_position.measure_code; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.loy_transaction_purchase_position.measure_code IS 'Код единицы измерения, в которой измерен товар в этой позиции';


--
-- Name: discounts_action_plugin discounts_action_plugin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_action_plugin
    ADD CONSTRAINT discounts_action_plugin_pkey PRIMARY KEY (id);


--
-- Name: discounts_action_plugin_property discounts_action_plugin_property_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_action_plugin_property
    ADD CONSTRAINT discounts_action_plugin_property_pkey PRIMARY KEY (id);


--
-- Name: discounts_advertisingactions discounts_advertisingactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_advertisingactions
    ADD CONSTRAINT discounts_advertisingactions_pkey PRIMARY KEY (id);


--
-- Name: discounts_topology_condition discounts_topology_condition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_topology_condition
    ADD CONSTRAINT discounts_topology_condition_pkey PRIMARY KEY (id);


--
-- Name: loy_adv_action_in_purchase loy_adv_action_in_purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_adv_action_in_purchase
    ADD CONSTRAINT loy_adv_action_in_purchase_pkey PRIMARY KEY (guid);


--
-- Name: loy_bonus_plastek_transaction loy_bonus_plastek_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_plastek_transaction
    ADD CONSTRAINT loy_bonus_plastek_transaction_pkey PRIMARY KEY (id);


--
-- Name: loy_bonus_positions loy_bonus_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_positions
    ADD CONSTRAINT loy_bonus_positions_pkey PRIMARY KEY (id);


--
-- Name: loy_bonus_sberbank_transaction loy_bonus_sberbank_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_sberbank_transaction
    ADD CONSTRAINT loy_bonus_sberbank_transaction_pkey PRIMARY KEY (id);


--
-- Name: loy_bonus_transactions loy_bonus_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_transactions
    ADD CONSTRAINT loy_bonus_transactions_pkey PRIMARY KEY (id);


--
-- Name: loy_bonusdiscount_transactions loy_bonusdiscount_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonusdiscount_transactions
    ADD CONSTRAINT loy_bonusdiscount_transactions_pkey PRIMARY KEY (id);


--
-- Name: loy_cheque_coupons loy_cheque_coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_cheque_coupons
    ADD CONSTRAINT loy_cheque_coupons_pkey PRIMARY KEY (id);


--
-- Name: loy_discount_cards loy_discount_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_discount_cards
    ADD CONSTRAINT loy_discount_cards_pkey PRIMARY KEY (id);


--
-- Name: loy_discount_positions loy_discount_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_discount_positions
    ADD CONSTRAINT loy_discount_positions_pkey PRIMARY KEY (id);


--
-- Name: loy_feedback loy_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_feedback
    ADD CONSTRAINT loy_feedback_pkey PRIMARY KEY (receipt_id, provider_id, feedback_time);


--
-- Name: loy_gift_note_by_cond loy_gift_note_by_cond_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_gift_note_by_cond
    ADD CONSTRAINT loy_gift_note_by_cond_pkey PRIMARY KEY (id);


--
-- Name: loy_gift_note loy_gift_note_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_gift_note
    ADD CONSTRAINT loy_gift_note_pkey PRIMARY KEY (id);


--
-- Name: loy_lastdiscountsid loy_lastdiscountsid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_lastdiscountsid
    ADD CONSTRAINT loy_lastdiscountsid_pkey PRIMARY KEY (id);


--
-- Name: loy_notsenddiscountsguid loy_notsenddiscountsguid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_notsenddiscountsguid
    ADD CONSTRAINT loy_notsenddiscountsguid_pkey PRIMARY KEY (id);


--
-- Name: loy_processing_coupons loy_processing_coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_processing_coupons
    ADD CONSTRAINT loy_processing_coupons_pkey PRIMARY KEY (id);


--
-- Name: loy_purchase_cards loy_purchase_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_purchase_cards
    ADD CONSTRAINT loy_purchase_cards_pkey PRIMARY KEY (id);


--
-- Name: loy_questionary loy_questionary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_questionary
    ADD CONSTRAINT loy_questionary_pkey PRIMARY KEY (id);


--
-- Name: loy_set_api_loyalty_transaction loy_set_api_loyalty_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_set_api_loyalty_transaction
    ADD CONSTRAINT loy_set_api_loyalty_transaction_pkey PRIMARY KEY (id);


--
-- Name: loy_tokens_siebel_transaction loy_tokens_siebel_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_tokens_siebel_transaction
    ADD CONSTRAINT loy_tokens_siebel_transaction_pkey PRIMARY KEY (id);


--
-- Name: loy_transaction loy_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_transaction
    ADD CONSTRAINT loy_transaction_pkey PRIMARY KEY (id);


--
-- Name: loy_transaction_purchase_payment loy_transaction_purchase_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_transaction_purchase_payment
    ADD CONSTRAINT loy_transaction_purchase_payment_pkey PRIMARY KEY (id);


--
-- Name: loy_transaction_purchase loy_transaction_purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_transaction_purchase
    ADD CONSTRAINT loy_transaction_purchase_pkey PRIMARY KEY (id);


--
-- Name: loy_transaction_purchase_position loy_transaction_purchase_position_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_transaction_purchase_position
    ADD CONSTRAINT loy_transaction_purchase_position_pkey PRIMARY KEY (id);


--
-- Name: action_pricetags_fk_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX action_pricetags_fk_idx ON public.discounts_advertisingactions_pricetags USING btree (action_id);


--
-- Name: discounts_action_plugin_action_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discounts_action_plugin_action_id_idx ON public.discounts_action_plugin USING btree (action_id);


--
-- Name: discounts_action_plugin_property_action_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discounts_action_plugin_property_action_id_idx ON public.discounts_action_plugin_property USING btree (action_id);


--
-- Name: discounts_action_plugin_property_parent_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discounts_action_plugin_property_parent_id_idx ON public.discounts_action_plugin_property USING btree (parent_id);


--
-- Name: discounts_action_plugin_property_plugin_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discounts_action_plugin_property_plugin_id_idx ON public.discounts_action_plugin_property USING btree (plugin_id);


--
-- Name: discounts_formats_action_fk_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discounts_formats_action_fk_idx ON public.formats_advertisingactions USING btree (action_id);


--
-- Name: discounts_formats_format_fk_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX discounts_formats_format_fk_idx ON public.formats_advertisingactions USING btree (format_ext_code);


--
-- Name: idx_loy_bonusdiscount_transactions__loy_tx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loy_bonusdiscount_transactions__loy_tx ON public.loy_bonusdiscount_transactions USING btree (transaction_id);


--
-- Name: idx_loy_gift_note__action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loy_gift_note__action ON public.loy_gift_note USING btree (advert_act_guid);


--
-- Name: idx_loy_gift_note__loy_tx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loy_gift_note__loy_tx ON public.loy_gift_note USING btree (loy_transaction_id);


--
-- Name: idx_loy_gift_note_by_cond__parent; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_loy_gift_note_by_cond__parent ON public.loy_gift_note_by_cond USING btree (parent);


--
-- Name: ix_bonus_positions_id_trans; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_bonus_positions_id_trans ON public.loy_bonus_positions USING btree (transaction_id);


--
-- Name: ix_bonus_transactions_id_trans; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_bonus_transactions_id_trans ON public.loy_bonus_transactions USING btree (transaction_id);


--
-- Name: ix_disc_cards_id_trans; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_disc_cards_id_trans ON public.loy_discount_cards USING btree (transaction_id);


--
-- Name: ix_disc_positions_id_trans; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_disc_positions_id_trans ON public.loy_discount_positions USING btree (transaction_id);


--
-- Name: ix_loy_bpt_tx_to_tx_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_loy_bpt_tx_to_tx_fkey ON public.loy_bonus_plastek_transaction USING btree (loy_transaction_id);


--
-- Name: ix_loy_bsb_tx_to_tx_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_loy_bsb_tx_to_tx_fkey ON public.loy_bonus_sberbank_transaction USING btree (loy_transaction_id);


--
-- Name: ix_loy_cheque_coupons_id_trans; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_loy_cheque_coupons_id_trans ON public.loy_cheque_coupons USING btree (transaction_id);


--
-- Name: ix_loy_questionary_id_trans; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_loy_questionary_id_trans ON public.loy_questionary USING btree (transaction_id);


--
-- Name: ix_loy_transaction_sale_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_loy_transaction_sale_time ON public.loy_transaction USING btree (sale_time);


--
-- Name: ix_process_coupons_id_trans; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_process_coupons_id_trans ON public.loy_processing_coupons USING btree (transaction_id);


--
-- Name: ix_purch_cards_id_trans; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_purch_cards_id_trans ON public.loy_purchase_cards USING btree (transaction_id);


--
-- Name: loy_api_tst_tx_to_tx_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX loy_api_tst_tx_to_tx_fkey ON public.loy_set_api_loyalty_transaction USING btree (transaction_id);


--
-- Name: loy_tst_tx_to_tx_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX loy_tst_tx_to_tx_fkey ON public.loy_tokens_siebel_transaction USING btree (transaction_id);


--
-- Name: loy_bonus_positions fk19f1d961e31da7b4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_positions
    ADD CONSTRAINT fk19f1d961e31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);


--
-- Name: loy_bonus_positions fk__loy_bonus_positions__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_positions
    ADD CONSTRAINT fk__loy_bonus_positions__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_bonus_transactions fk__loy_bonus_transactions__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_transactions
    ADD CONSTRAINT fk__loy_bonus_transactions__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_bonusdiscount_transactions fk__loy_bonusdiscount_transactions__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonusdiscount_transactions
    ADD CONSTRAINT fk__loy_bonusdiscount_transactions__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_cheque_coupons fk__loy_cheque_coupons__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_cheque_coupons
    ADD CONSTRAINT fk__loy_cheque_coupons__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_discount_cards fk__loy_discount_cards__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_discount_cards
    ADD CONSTRAINT fk__loy_discount_cards__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_discount_positions fk__loy_discount_positions__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_discount_positions
    ADD CONSTRAINT fk__loy_discount_positions__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_processing_coupons fk__loy_processing_coupons__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_processing_coupons
    ADD CONSTRAINT fk__loy_processing_coupons__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_purchase_cards fk__loy_purchase_cards__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_purchase_cards
    ADD CONSTRAINT fk__loy_purchase_cards__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_questionary fk__loy_questionary__loy_transaction; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_questionary
    ADD CONSTRAINT fk__loy_questionary__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: discounts_action_plugin fk_discounts_action_plugin_discounts_advertisingactions_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_action_plugin
    ADD CONSTRAINT fk_discounts_action_plugin_discounts_advertisingactions_id FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: discounts_action_plugin_property fk_discounts_action_plugin_property_discounts_action_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_action_plugin_property
    ADD CONSTRAINT fk_discounts_action_plugin_property_discounts_action_id FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: discounts_action_plugin_property fk_discounts_action_plugin_property_discounts_action_plugin_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_action_plugin_property
    ADD CONSTRAINT fk_discounts_action_plugin_property_discounts_action_plugin_id FOREIGN KEY (plugin_id) REFERENCES public.discounts_action_plugin(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: discounts_action_plugin_property fk_discounts_action_plugin_property_discounts_action_plugin_pro; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_action_plugin_property
    ADD CONSTRAINT fk_discounts_action_plugin_property_discounts_action_plugin_pro FOREIGN KEY (parent_id) REFERENCES public.discounts_action_plugin_property(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: discounts_advertisingactions_masteractionguids fk_discounts_advertisingactions_masteractionguids_discounts_adv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_advertisingactions_masteractionguids
    ADD CONSTRAINT fk_discounts_advertisingactions_masteractionguids_discounts_adv FOREIGN KEY (discounts_advertisingactions_id) REFERENCES public.discounts_advertisingactions(id) ON DELETE CASCADE;


--
-- Name: discounts_advertisingactions_pricetags fk_discounts_advertisingactions_pricetags_action_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_advertisingactions_pricetags
    ADD CONSTRAINT fk_discounts_advertisingactions_pricetags_action_id FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON DELETE CASCADE;


--
-- Name: discounts_topology_condition fk_discounts_topology_condition_discounts_advertisingactions; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_topology_condition
    ADD CONSTRAINT fk_discounts_topology_condition_discounts_advertisingactions FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON DELETE CASCADE;


--
-- Name: discounts_topology_condition_formats fk_discounts_topology_condition_formats_discounts_topology_cond; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_topology_condition_formats
    ADD CONSTRAINT fk_discounts_topology_condition_formats_discounts_topology_cond FOREIGN KEY (discounts_topology_condition_id) REFERENCES public.discounts_topology_condition(id) ON DELETE CASCADE;


--
-- Name: loy_gift_note fk_loy_gift_note__action; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_gift_note
    ADD CONSTRAINT fk_loy_gift_note__action FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid) ON DELETE SET NULL;


--
-- Name: loy_gift_note fk_loy_gift_note__loy_tx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_gift_note
    ADD CONSTRAINT fk_loy_gift_note__loy_tx FOREIGN KEY (loy_transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_gift_note_by_cond fk_loy_gift_note_by_cond__loy_gift_note; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_gift_note_by_cond
    ADD CONSTRAINT fk_loy_gift_note_by_cond__loy_gift_note FOREIGN KEY (parent) REFERENCES public.loy_gift_note(id) ON DELETE CASCADE;


--
-- Name: loy_transaction fk_loy_transaction_loy_transaction_purchase_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_transaction
    ADD CONSTRAINT fk_loy_transaction_loy_transaction_purchase_id FOREIGN KEY (purchase) REFERENCES public.loy_transaction_purchase(id);


--
-- Name: loy_transaction_purchase_payment fk_loy_transaction_purchase_payment_loy_transaction_purchase_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_transaction_purchase_payment
    ADD CONSTRAINT fk_loy_transaction_purchase_payment_loy_transaction_purchase_id FOREIGN KEY (purchase) REFERENCES public.loy_transaction_purchase(id) ON DELETE CASCADE;


--
-- Name: loy_transaction_purchase_position fk_loy_transaction_purchase_position_loy_transaction_purchase_i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_transaction_purchase_position
    ADD CONSTRAINT fk_loy_transaction_purchase_position_loy_transaction_purchase_i FOREIGN KEY (purchase) REFERENCES public.loy_transaction_purchase(id) ON DELETE CASCADE;


--
-- Name: loy_questionary fka80f9d59e31da7b4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_questionary
    ADD CONSTRAINT fka80f9d59e31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);


--
-- Name: loy_bonus_transactions fka9a504fee31da7b4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_transactions
    ADD CONSTRAINT fka9a504fee31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);


--
-- Name: loy_processing_coupons fkaabd076ae31da7b4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_processing_coupons
    ADD CONSTRAINT fkaabd076ae31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);


--
-- Name: loy_discount_positions fkbb82e675e31da7b4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_discount_positions
    ADD CONSTRAINT fkbb82e675e31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid) ON DELETE SET NULL;


--
-- Name: loy_discount_cards fkbb987654321cbcf4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_discount_cards
    ADD CONSTRAINT fkbb987654321cbcf4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);


--
-- Name: loy_cheque_coupons fkc7d208f8e31da7b4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_cheque_coupons
    ADD CONSTRAINT fkc7d208f8e31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);


--
-- Name: discounts_advertisingactions_resulttypes fkd9099723c6383af; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts_advertisingactions_resulttypes
    ADD CONSTRAINT fkd9099723c6383af FOREIGN KEY (discounts_advertisingactions_id) REFERENCES public.discounts_advertisingactions(id);


--
-- Name: formats_advertisingactions formats_advertisingactions_action_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formats_advertisingactions
    ADD CONSTRAINT formats_advertisingactions_action_id_fkey FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON DELETE CASCADE;


--
-- Name: loy_set_api_loyalty_transaction loy_api_tst_tx_to_tx_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_set_api_loyalty_transaction
    ADD CONSTRAINT loy_api_tst_tx_to_tx_fkey FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_bonus_plastek_transaction loy_bpt_tx_to_tx_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_plastek_transaction
    ADD CONSTRAINT loy_bpt_tx_to_tx_fkey FOREIGN KEY (loy_transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_bonus_sberbank_transaction loy_bsb_tx_to_tx_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_bonus_sberbank_transaction
    ADD CONSTRAINT loy_bsb_tx_to_tx_fkey FOREIGN KEY (loy_transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


--
-- Name: loy_tokens_siebel_transaction loy_tst_tx_to_tx_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loy_tokens_siebel_transaction
    ADD CONSTRAINT loy_tst_tx_to_tx_fkey FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;


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

