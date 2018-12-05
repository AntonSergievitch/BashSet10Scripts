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
CREATE TABLE public.cg_barcode (
    barcode character varying(30) NOT NULL,
    price_begindate timestamp without time zone,
    count bigint,
    defaultcode boolean,
    price_enddate timestamp without time zone,
    name character varying(255),
    price bigint,
    type character varying(255),
    product_item character varying(30),
    barcodetype character varying(20)
);
ALTER TABLE public.cg_barcode OWNER TO postgres;
COMMENT ON TABLE public.cg_barcode IS 'Штрих-код товара';---- Name: cg_clothing_cis; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_clothing_cis (
    cis character varying(255) NOT NULL,
    barcode character varying(255) NOT NULL
);
ALTER TABLE public.cg_clothing_cis OWNER TO postgres;
COMMENT ON TABLE public.cg_clothing_cis IS 'КиЗ (Контрольный идентификационный знак)';---- Name: COLUMN cg_clothing_cis.cis; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_currency (
    id character varying(3) NOT NULL,
    guid bigint,
    name character varying(50),
    symbol character varying(3),
    rounding_mode character varying(11) DEFAULT 'HALF_EVEN'::character varying NOT NULL,
    round_to integer DEFAULT 1 NOT NULL,
    round_to_nds integer DEFAULT 1 NOT NULL,
    fraction_digits integer DEFAULT 2 NOT NULL,
    has_coins boolean DEFAULT true NOT NULL
);
ALTER TABLE public.cg_currency OWNER TO postgres;
COMMENT ON TABLE public.cg_currency IS 'Валюта';---- Name: COLUMN cg_currency.rounding_mode; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_currencybanknote (
    id bigint NOT NULL,
    name character varying(50),
    value bigint,
    id_currency character varying(3),
    is_coin boolean
);
ALTER TABLE public.cg_currencybanknote OWNER TO postgres;
COMMENT ON TABLE public.cg_currencybanknote IS 'Тип валюты';---- Name: cg_currencycourse; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_currencycourse (
    id bigint NOT NULL,
    course bigint,
    datevalid date,
    id_currency character varying(3)
);
ALTER TABLE public.cg_currencycourse OWNER TO postgres;
COMMENT ON TABLE public.cg_currencycourse IS 'Валютный курс';---- Name: cg_lastproductsid; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_lastproductsid (
    id integer NOT NULL,
    productid bigint
);
ALTER TABLE public.cg_lastproductsid OWNER TO postgres;
COMMENT ON TABLE public.cg_lastproductsid IS 'Идентификатор последнего успешно полученного файла задания на загрузку товара';---- Name: cg_limits_age; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_limits_age (
    id bigint NOT NULL,
    type smallint NOT NULL,
    min_age smallint DEFAULT 18 NOT NULL
);
ALTER TABLE public.cg_limits_age OWNER TO postgres;
COMMENT ON TABLE public.cg_limits_age IS 'Ограничение продажи по возрасту покупателя';---- Name: COLUMN cg_limits_age.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_limits_alcohol (
    id bigint NOT NULL,
    min_percent numeric(4,2) DEFAULT 0 NOT NULL,
    time_from time without time zone,
    time_to time without time zone,
    date_from date,
    date_to date,
    min_liter_price bigint,
    day_of_week integer
);
ALTER TABLE public.cg_limits_alcohol OWNER TO postgres;
COMMENT ON TABLE public.cg_limits_alcohol IS 'Ограничение времени продажи алкогольной продукции';---- Name: COLUMN cg_limits_alcohol.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.hibernate_sequence OWNER TO postgres;
CREATE TABLE public.cg_limits_base (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    guid character(36) NOT NULL,
    limit_name character varying(255) NOT NULL,
    discriminator character(3) NOT NULL,
    deleted boolean NOT NULL,
    create_date timestamp without time zone NOT NULL,
    update_date timestamp without time zone,
    from_apper_point boolean DEFAULT false NOT NULL
);
ALTER TABLE public.cg_limits_base OWNER TO postgres;
COMMENT ON TABLE public.cg_limits_base IS 'Ограничения продажи внутри системы SET10';---- Name: COLUMN cg_limits_base.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_measure (
    code character varying(255) NOT NULL,
    name character varying(255)
);
ALTER TABLE public.cg_measure OWNER TO postgres;
COMMENT ON TABLE public.cg_measure IS 'Единицы измерения (MeasureEntity)';---- Name: COLUMN cg_measure.code; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_notsendproductitems (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    productid character varying(255),
    status integer
);
ALTER TABLE public.cg_notsendproductitems OWNER TO postgres;
COMMENT ON TABLE public.cg_notsendproductitems IS 'В случае неуспешного статуса обработки файла список товаров из полученного запроса заносится в таблицу';---- Name: cg_price; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_price (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    begindate timestamp without time zone,
    id_currency character varying(3),
    departnumber bigint,
    enddate timestamp without time zone,
    price_number integer,
    price bigint NOT NULL,
    product_item character varying(30),
    pack_count integer
);
ALTER TABLE public.cg_price OWNER TO postgres;
COMMENT ON TABLE public.cg_price IS 'Цены';---- Name: COLUMN cg_price.pack_count; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_product (
    item character varying(30) NOT NULL,
    discriminator character varying(32),
    lastimporttime timestamp without time zone NOT NULL,
    measure_code character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    nds real NOT NULL,
    ndsclass character varying(3),
    "precision" double precision NOT NULL,
    status integer,
    amount_in_package integer,
    category_mask smallint NOT NULL,
    erpcode character varying(255),
    group_code character varying(255),
    goodsfeature character varying,
    vet_inspection boolean DEFAULT false NOT NULL,
    use_by_date integer
);
ALTER TABLE public.cg_product OWNER TO postgres;
COMMENT ON TABLE public.cg_product IS 'Товарный справочник';---- Name: COLUMN cg_product.amount_in_package; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_product_cg_salegroup (
    cg_product_item character varying(30) NOT NULL,
    salegroups_code character varying(255) NOT NULL
);
ALTER TABLE public.cg_product_cg_salegroup OWNER TO postgres;
COMMENT ON TABLE public.cg_product_cg_salegroup IS 'Привязка id товаров и id группы продаж';---- Name: cg_product_discount_card; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_product_discount_card (
    item character varying(30) NOT NULL
);
ALTER TABLE public.cg_product_discount_card OWNER TO postgres;
COMMENT ON TABLE public.cg_product_discount_card IS 'Сущность, описывающая товар "Дисконтная карта" (ProductDiscountCardEntity)';---- Name: cg_product_license_key; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_product_license_key (
    item character varying(30) NOT NULL,
    sublicensed boolean NOT NULL
);
ALTER TABLE public.cg_product_license_key OWNER TO postgres;
COMMENT ON TABLE public.cg_product_license_key IS 'Товары типа "Электронный ключ ПО"';---- Name: COLUMN cg_product_license_key.item; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productciggy (
    item character varying(30) NOT NULL
);
ALTER TABLE public.cg_productciggy OWNER TO postgres;
COMMENT ON TABLE public.cg_productciggy IS 'Тип товара: табачное изделие';---- Name: cg_productciggy_prices; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productciggy_prices (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    product_item character varying(30),
    price bigint,
    sale_price bigint
);
ALTER TABLE public.cg_productciggy_prices OWNER TO postgres;
COMMENT ON TABLE public.cg_productciggy_prices IS 'МРЦ табачного товара';---- Name: cg_productclothing; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productclothing (
    item character varying(30) NOT NULL,
    cisable boolean DEFAULT false NOT NULL
);
ALTER TABLE public.cg_productclothing OWNER TO postgres;
COMMENT ON TABLE public.cg_productclothing IS 'Тип товара: Одежда';---- Name: COLUMN cg_productclothing.cisable; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productgiftcard (
    amountcard bigint,
    numbercard character varying(30),
    item character varying(30) NOT NULL
);
ALTER TABLE public.cg_productgiftcard OWNER TO postgres;
COMMENT ON TABLE public.cg_productgiftcard IS 'Тип товара: Подарочная карта';---- Name: cg_productjewel; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productjewel (
    item character varying(30) NOT NULL,
    weight numeric(9,3),
    j_size numeric(9,3),
    hallmark integer,
    price_per_gramm bigint
);
ALTER TABLE public.cg_productjewel OWNER TO postgres;
COMMENT ON TABLE public.cg_productjewel IS 'Тип товара: Ювелирный';---- Name: cg_productmetric; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productmetric (
    item character varying(30) NOT NULL
);
ALTER TABLE public.cg_productmetric OWNER TO postgres;
COMMENT ON TABLE public.cg_productmetric IS 'Тип товара: Метрический';---- Name: cg_productspirits; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productspirits (
    alcoholic_content double precision,
    volume double precision,
    item character varying(30) NOT NULL,
    alcoholic_type character varying(3)
);
ALTER TABLE public.cg_productspirits OWNER TO postgres;
COMMENT ON TABLE public.cg_productspirits IS 'Тип товара: Алкогольный';---- Name: COLUMN cg_productspirits.alcoholic_type; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productspirits_bottle (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    name character varying(128),
    alcoholic_content double precision,
    volume double precision NOT NULL,
    product_item character varying(30) NOT NULL,
    count integer DEFAULT 1 NOT NULL,
    alcoholic_type character varying(3),
    excise boolean DEFAULT true NOT NULL
);
ALTER TABLE public.cg_productspirits_bottle OWNER TO postgres;
COMMENT ON TABLE public.cg_productspirits_bottle IS 'Бутылки акцизного алкогольного товара, когда алкогольный товар является набором';---- Name: COLUMN cg_productspirits_bottle.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productspirits_bottle_alcocode (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    alco_code character varying(19) NOT NULL,
    bottle_id bigint,
    product_item character varying(30)
);
ALTER TABLE public.cg_productspirits_bottle_alcocode OWNER TO postgres;
COMMENT ON TABLE public.cg_productspirits_bottle_alcocode IS 'Таблица алкокодов для акцизных бутылок';---- Name: COLUMN cg_productspirits_bottle_alcocode.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productspirits_bottle_barcode (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    barcode character varying(255) NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    bottle_id bigint NOT NULL
);
ALTER TABLE public.cg_productspirits_bottle_barcode OWNER TO postgres;
COMMENT ON TABLE public.cg_productspirits_bottle_barcode IS 'Таблица штрих-кодов для акцизных бутылок';---- Name: COLUMN cg_productspirits_bottle_barcode.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_productspirits_bottle_price (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    price bigint NOT NULL,
    begin_date date,
    end_date date,
    bottle_id bigint NOT NULL
);
ALTER TABLE public.cg_productspirits_bottle_price OWNER TO postgres;
COMMENT ON TABLE public.cg_productspirits_bottle_price IS 'Таблица цен для акцизных бутылок';---- Name: COLUMN cg_productspirits_bottle_price.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.cg_salegroup (
    code character varying(255) NOT NULL,
    name character varying(255)
);
ALTER TABLE public.cg_salegroup OWNER TO postgres;
COMMENT ON TABLE public.cg_salegroup IS 'Группы продаж';---- Name: likond; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.likond (
    marking character varying(255) NOT NULL,
    tx_id character varying(255),
    begin_date timestamp without time zone,
    end_date timestamp without time zone
);
ALTER TABLE public.likond OWNER TO postgres;
COMMENT ON TABLE public.likond IS 'Функциональность только для клиента ЛЕНТА: Likond - правила разрешения продажи товара (LikondRestrictionEntity)';---- Name: COLUMN likond.marking; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.likond_files (
    file_id bigint NOT NULL,
    file_url character varying(255) NOT NULL,
    processed_at timestamp without time zone
);
ALTER TABLE public.likond_files OWNER TO postgres;
COMMENT ON TABLE public.likond_files IS 'Содержит информацию о расположении файла с ликондами, что еще предстоит скачать на эту кассу и отчитаться перед сервером по результатам обработки этого файла (LikondFilesEntity)';---- Name: COLUMN likond_files.file_id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_cg_sale_restrictions (
    code character varying(255) NOT NULL,
    deleted boolean,
    lastimporttime timestamp without time zone NOT NULL,
    sincedate timestamp without time zone,
    sincetime time without time zone,
    tilldate timestamp without time zone,
    tilltime time without time zone,
    group_code character varying(255),
    product_marking character varying(255),
    daysmask smallint,
    saledenied boolean,
    max_discount double precision,
    min_price bigint,
    CONSTRAINT valid_values CHECK ((((((saledenied IS NOT NULL) AND (max_discount IS NULL)) AND (min_price IS NULL)) OR (((saledenied IS NULL) AND (max_discount IS NOT NULL)) AND (min_price IS NULL))) OR (((saledenied IS NULL) AND (max_discount IS NULL)) AND (min_price IS NOT NULL))))
);
ALTER TABLE public.loy_cg_sale_restrictions OWNER TO postgres;
COMMENT ON TABLE public.loy_cg_sale_restrictions IS 'Таблица для РА - Ограничения - привязка id к определенному виду ограничения';---- Name: COLUMN loy_cg_sale_restrictions.saledenied; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_barcode (
    barcode character varying(255) NOT NULL,
    price_begin_date timestamp without time zone,
    count bigint,
    defaultcode boolean,
    deleted boolean,
    price_end_date timestamp without time zone,
    name character varying(255),
    price_number bigint,
    price bigint,
    type character varying(255),
    product_marking character varying(255) NOT NULL
);
ALTER TABLE public.loy_products_barcode OWNER TO postgres;
COMMENT ON TABLE public.loy_products_barcode IS 'Таблица для РА - Штрих-код товаров участвующих в условиях РА';---- Name: loy_products_country; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_country (
    code character varying(255) NOT NULL,
    name character varying(255)
);
ALTER TABLE public.loy_products_country OWNER TO postgres;
COMMENT ON TABLE public.loy_products_country IS 'Таблица для РА - список стран товаров участвующих в условиях РА';---- Name: loy_products_department; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_department (
    number bigint NOT NULL,
    name character varying(255)
);
ALTER TABLE public.loy_products_department OWNER TO postgres;
COMMENT ON TABLE public.loy_products_department IS 'Таблица для РА - список отделов участвующих в условиях РА';---- Name: loy_products_group; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_group (
    code character varying(255) NOT NULL,
    name character varying(255),
    parent_code character varying(255)
);
ALTER TABLE public.loy_products_group OWNER TO postgres;
COMMENT ON TABLE public.loy_products_group IS 'Таблица для РА - список групп товаров участвующих в условиях РА';---- Name: loy_products_manufacturer; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_manufacturer (
    code character varying(255) NOT NULL,
    name character varying(255)
);
ALTER TABLE public.loy_products_manufacturer OWNER TO postgres;
COMMENT ON TABLE public.loy_products_manufacturer IS 'Таблица для РА - список производителей участвующих в условиях РА';---- Name: loy_products_measure; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_measure (
    code character varying(255) NOT NULL,
    name character varying(255)
);
ALTER TABLE public.loy_products_measure OWNER TO postgres;
COMMENT ON TABLE public.loy_products_measure IS 'Таблица для РА - список едений измерений для товаров участвующих в условиях РА';---- Name: loy_products_price; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_price (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    begindate timestamp without time zone,
    enddate timestamp without time zone,
    price_number bigint,
    price bigint NOT NULL,
    department_number bigint NOT NULL,
    product_marking character varying(255) NOT NULL,
    discount_identifier character varying(32),
    pack_count integer
);
ALTER TABLE public.loy_products_price OWNER TO postgres;
COMMENT ON TABLE public.loy_products_price IS 'Таблица для РА - Вычисленные цены для товаров, участвующих в РА';---- Name: COLUMN loy_products_price.pack_count; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_product (
    markingofthegood character varying(255) NOT NULL,
    country_code_ligth character varying(255),
    deleted boolean NOT NULL,
    lastimporttime timestamp without time zone NOT NULL,
    manufacturer_code_ligth character varying(255),
    measure_code_ligth character varying(255),
    name character varying(255),
    plugin_class_name character varying(255),
    vat numeric(19,2),
    country_code character varying(255),
    group_code character varying(255),
    manufacturer_code character varying(255),
    measure_code character varying(255),
    "precision" double precision DEFAULT 1.0 NOT NULL
);
ALTER TABLE public.loy_products_product OWNER TO postgres;
COMMENT ON TABLE public.loy_products_product IS 'Таблица для РА - Представление товара для лояльности (LoyalProductEntity)';---- Name: COLUMN loy_products_product.markingofthegood; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_product_loy_products_salegroup (
    products_markingofthegood character varying(255) NOT NULL,
    sale_group_code character varying(255) NOT NULL
);
ALTER TABLE public.loy_products_product_loy_products_salegroup OWNER TO postgres;
COMMENT ON TABLE public.loy_products_product_loy_products_salegroup IS 'Таблица для РА - вычисленные цены для групп продаж, участвующих в РА';---- Name: loy_products_salegroup; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_salegroup (
    code character varying(255) NOT NULL,
    name character varying(255)
);
ALTER TABLE public.loy_products_salegroup OWNER TO postgres;
COMMENT ON TABLE public.loy_products_salegroup IS 'Таблица для РА - Cписок групп продаж участвующих в условиях РА';---- Name: loy_products_wholesale_levels; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_products_wholesale_levels (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    value bigint NOT NULL,
    value_type character varying(255) NOT NULL,
    activation_limit bigint NOT NULL,
    product_marking character varying(255) NOT NULL,
    date_from timestamp without time zone,
    date_to timestamp without time zone
);
ALTER TABLE public.loy_products_wholesale_levels OWNER TO postgres;
COMMENT ON TABLE public.loy_products_wholesale_levels IS 'Таблица для РА - Оптовые скидки';---- Name: sales_management_properties; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.sales_management_properties (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    module_name text DEFAULT 'ALL'::text NOT NULL,
    plugin_name text,
    property_key text NOT NULL,
    property_value text,
    description text,
    transport_level integer,
    priority integer,
    send_status integer
);
ALTER TABLE public.sales_management_properties OWNER TO postgres;
COMMENT ON TABLE public.sales_management_properties IS 'Настройки Группы Модулей "Управление Продажами"';---- Name: COLUMN sales_management_properties.module_name; Type: COMMENT; Schema: public; Owner: postgres--
ALTER TABLE ONLY public.cg_barcode
    ADD CONSTRAINT cg_barcode_pkey PRIMARY KEY (barcode);
ALTER TABLE ONLY public.cg_clothing_cis
    ADD CONSTRAINT cg_clothing_cis_pkey PRIMARY KEY (cis);
ALTER TABLE ONLY public.cg_currency
    ADD CONSTRAINT cg_currency_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_currencybanknote
    ADD CONSTRAINT cg_currencybanknote_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_currencycourse
    ADD CONSTRAINT cg_currencycourse_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_lastproductsid
    ADD CONSTRAINT cg_lastproductsid_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_limits_age
    ADD CONSTRAINT cg_limits_age_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_limits_alcohol
    ADD CONSTRAINT cg_limits_alcohol_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_limits_base
    ADD CONSTRAINT cg_limits_base_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_measure
    ADD CONSTRAINT cg_measure_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.cg_notsendproductitems
    ADD CONSTRAINT cg_notsendproductitems_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_price
    ADD CONSTRAINT cg_price_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_product_cg_salegroup
    ADD CONSTRAINT cg_product_cg_salegroup_pkey PRIMARY KEY (cg_product_item, salegroups_code);
ALTER TABLE ONLY public.cg_product_discount_card
    ADD CONSTRAINT cg_product_discount_card_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_product_license_key
    ADD CONSTRAINT cg_product_license_key_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_product
    ADD CONSTRAINT cg_product_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_productspirits_bottle
    ADD CONSTRAINT cg_product_spiritsbottle_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_productciggy
    ADD CONSTRAINT cg_productciggy_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_productciggy_prices
    ADD CONSTRAINT cg_productciggy_prices_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_productclothing
    ADD CONSTRAINT cg_productclothing_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_productgiftcard
    ADD CONSTRAINT cg_productgiftcard_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_productjewel
    ADD CONSTRAINT cg_productjewel_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_productmetric
    ADD CONSTRAINT cg_productmetric_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_productspirits_bottle_alcocode
    ADD CONSTRAINT cg_productspirits_bottle_alcocode_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_productspirits_bottle_barcode
    ADD CONSTRAINT cg_productspirits_bottle_barcodes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_productspirits_bottle_price
    ADD CONSTRAINT cg_productspirits_bottle_price_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.cg_productspirits
    ADD CONSTRAINT cg_productspirits_pkey PRIMARY KEY (item);
ALTER TABLE ONLY public.cg_salegroup
    ADD CONSTRAINT cg_salegroup_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.likond_files
    ADD CONSTRAINT likond_files_pkey PRIMARY KEY (file_id);
ALTER TABLE ONLY public.likond
    ADD CONSTRAINT likond_pkey PRIMARY KEY (marking);
ALTER TABLE ONLY public.loy_cg_sale_restrictions
    ADD CONSTRAINT loy_cg_sale_restrictions_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.loy_products_barcode
    ADD CONSTRAINT loy_products_barcode_pkey PRIMARY KEY (barcode);
ALTER TABLE ONLY public.loy_products_country
    ADD CONSTRAINT loy_products_country_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.loy_products_department
    ADD CONSTRAINT loy_products_department_pkey PRIMARY KEY (number);
ALTER TABLE ONLY public.loy_products_group
    ADD CONSTRAINT loy_products_group_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.loy_products_manufacturer
    ADD CONSTRAINT loy_products_manufacturer_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.loy_products_measure
    ADD CONSTRAINT loy_products_measure_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.loy_products_price
    ADD CONSTRAINT loy_products_price_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_products_product_loy_products_salegroup
    ADD CONSTRAINT loy_products_product_loy_products_salegroup_pkey PRIMARY KEY (products_markingofthegood, sale_group_code);
ALTER TABLE ONLY public.loy_products_product
    ADD CONSTRAINT loy_products_product_pkey PRIMARY KEY (markingofthegood);
ALTER TABLE ONLY public.loy_products_salegroup
    ADD CONSTRAINT loy_products_salegroup_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.loy_products_wholesale_levels
    ADD CONSTRAINT loy_products_wholesale_levels_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sales_management_properties
    ADD CONSTRAINT sales_management_properties_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sales_management_properties
    ADD CONSTRAINT uniq_sales_management_properties UNIQUE (module_name, plugin_name, property_key);
CREATE INDEX cg_barcode_product_idx ON public.cg_barcode USING btree (product_item);
CREATE UNIQUE INDEX cg_limits_base__guid_idx ON public.cg_limits_base USING btree (guid);
CREATE INDEX cg_limits_base__update_date_idx ON public.cg_limits_base USING btree (update_date);
CREATE INDEX cg_price_product_idx ON public.cg_price USING btree (product_item);
CREATE INDEX cg_productciggy_prices_idx ON public.cg_productciggy_prices USING btree (product_item);
CREATE INDEX cg_productspirits_bottle_product_item ON public.cg_productspirits_bottle USING btree (product_item);
CREATE INDEX ix_cg_product_item ON public.cg_product USING btree (item);
CREATE INDEX ix_loy_cg_sale_restrictions_group_code ON public.loy_cg_sale_restrictions USING btree (group_code);
CREATE INDEX ix_loy_cg_sale_restrictions_product_item ON public.loy_cg_sale_restrictions USING btree (product_marking);
CREATE INDEX ix_loy_products_wholesale_levels_product_item ON public.loy_products_wholesale_levels USING btree (product_marking);
CREATE INDEX loy_products_group_parent_idx ON public.loy_products_group USING btree (parent_code);
CREATE INDEX loy_products_price_department_idx ON public.loy_products_price USING btree (department_number);
CREATE INDEX loy_products_price_product_idx ON public.loy_products_price USING btree (product_marking);
CREATE INDEX loy_products_product_group_idx ON public.loy_products_product USING btree (group_code);
ALTER TABLE ONLY public.cg_productspirits_bottle
    ADD CONSTRAINT cg_product_spiritsbottle_fkey FOREIGN KEY (product_item) REFERENCES public.cg_productspirits(item) ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productclothing
    ADD CONSTRAINT cg_productclothing_item FOREIGN KEY (item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productjewel
    ADD CONSTRAINT cg_productjewel_item FOREIGN KEY (item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productmetric
    ADD CONSTRAINT cg_productmetric_item FOREIGN KEY (item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productspirits_bottle_alcocode
    ADD CONSTRAINT cg_productspirits_bottle_alcocode_fkey FOREIGN KEY (bottle_id) REFERENCES public.cg_productspirits_bottle(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productspirits_bottle_alcocode
    ADD CONSTRAINT cg_productspirits_bottle_alcocode_fkey_product FOREIGN KEY (product_item) REFERENCES public.cg_productspirits(item) ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productspirits_bottle_barcode
    ADD CONSTRAINT cg_productspirits_bottle_barcodes_fkey FOREIGN KEY (bottle_id) REFERENCES public.cg_productspirits_bottle(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productspirits_bottle_price
    ADD CONSTRAINT cg_productspirits_bottle_price_fkey FOREIGN KEY (bottle_id) REFERENCES public.cg_productspirits_bottle(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productspirits
    ADD CONSTRAINT fk492b800e425ea050 FOREIGN KEY (item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_currencybanknote
    ADD CONSTRAINT fk51d8ddfae5660bde FOREIGN KEY (id_currency) REFERENCES public.cg_currency(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_product_cg_salegroup
    ADD CONSTRAINT fk5e0ef2c8a156e99b FOREIGN KEY (cg_product_item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_product_cg_salegroup
    ADD CONSTRAINT fk5e0ef2c8f115a017 FOREIGN KEY (salegroups_code) REFERENCES public.cg_salegroup(code) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_products_barcode
    ADD CONSTRAINT fk6857d26e2e26f548 FOREIGN KEY (product_marking) REFERENCES public.loy_products_product(markingofthegood) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_products_product
    ADD CONSTRAINT fk69c7b6dd21dded00 FOREIGN KEY (country_code) REFERENCES public.loy_products_country(code);
ALTER TABLE ONLY public.loy_products_product
    ADD CONSTRAINT fk69c7b6dd4d3fd400 FOREIGN KEY (measure_code) REFERENCES public.loy_products_measure(code);
ALTER TABLE ONLY public.loy_products_product
    ADD CONSTRAINT fk69c7b6dd4ee20e5e FOREIGN KEY (manufacturer_code) REFERENCES public.loy_products_manufacturer(code);
ALTER TABLE ONLY public.loy_products_product
    ADD CONSTRAINT fk69c7b6dd6f60cc20 FOREIGN KEY (group_code) REFERENCES public.loy_products_group(code);
ALTER TABLE ONLY public.loy_products_product_loy_products_salegroup
    ADD CONSTRAINT fk77e30a818e4e8c0 FOREIGN KEY (products_markingofthegood) REFERENCES public.loy_products_product(markingofthegood) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_products_product_loy_products_salegroup
    ADD CONSTRAINT fk77e30a81f6503d1 FOREIGN KEY (sale_group_code) REFERENCES public.loy_products_salegroup(code);
ALTER TABLE ONLY public.cg_price
    ADD CONSTRAINT fk8282518e7ea149a0 FOREIGN KEY (product_item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productgiftcard
    ADD CONSTRAINT fk8656e074425ea050 FOREIGN KEY (item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_currencycourse
    ADD CONSTRAINT fk9a2688e7e5660bde FOREIGN KEY (id_currency) REFERENCES public.cg_currency(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_limits_age
    ADD CONSTRAINT fk_cg_limits_age__id FOREIGN KEY (id) REFERENCES public.cg_limits_base(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_limits_alcohol
    ADD CONSTRAINT fk_cg_limits_alcohol__id FOREIGN KEY (id) REFERENCES public.cg_limits_base(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_product
    ADD CONSTRAINT fk_cg_product_cg_measure_code FOREIGN KEY (measure_code) REFERENCES public.cg_measure(code);
ALTER TABLE ONLY public.cg_product_discount_card
    ADD CONSTRAINT fk_cg_product_discount_card__cg_product FOREIGN KEY (item) REFERENCES public.cg_product(item) ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_product_license_key
    ADD CONSTRAINT fk_cg_product_license_key_item FOREIGN KEY (item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productciggy_prices
    ADD CONSTRAINT fk_cg_productciggy FOREIGN KEY (product_item) REFERENCES public.cg_productciggy(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_productciggy
    ADD CONSTRAINT fk_cg_productciggy_item FOREIGN KEY (item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_products_group
    ADD CONSTRAINT fkddc883ed5f725cd5 FOREIGN KEY (parent_code) REFERENCES public.loy_products_group(code);
ALTER TABLE ONLY public.loy_products_price
    ADD CONSTRAINT fkde473eb72e26f548 FOREIGN KEY (product_marking) REFERENCES public.loy_products_product(markingofthegood) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_products_price
    ADD CONSTRAINT fkde473eb73e4692bc FOREIGN KEY (department_number) REFERENCES public.loy_products_department(number) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.cg_barcode
    ADD CONSTRAINT fkea198b857ea149a0 FOREIGN KEY (product_item) REFERENCES public.cg_product(item) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_products_wholesale_levels
    ADD CONSTRAINT loy_products_wholesale_levels_markingofthegood FOREIGN KEY (product_marking) REFERENCES public.loy_products_product(markingofthegood) ON UPDATE CASCADE ON DELETE CASCADE;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
