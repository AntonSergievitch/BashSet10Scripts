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
COMMENT ON TABLE public.ch_bankcardpayment IS 'Чек - Оплаты - Банковская карта';---- Name: COLUMN ch_bankcardpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_bankcardpayment_transaction IS 'Чек - Оплаты - Банковская карта - Транзакции';---- Name: COLUMN ch_bankcardpayment_transaction.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_bonuscardpayment (
    id bigint NOT NULL,
    accountid bigint,
    accounttype integer,
    cancelbonuses integer,
    cardnumber character varying(255),
    authcode character varying(255)
);
ALTER TABLE public.ch_bonuscardpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_bonuscardpayment IS 'Чек - Оплаты - Бонусы';---- Name: COLUMN ch_bonuscardpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_bonussberbankpayment IS 'Оплаты типа "Спасибо от Сбербанка" (ODBonusSberbankPaymentEntity)';---- Name: COLUMN ch_bonussberbankpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_cashpayment (
    id bigint NOT NULL,
    changecash bigint
);
ALTER TABLE public.ch_cashpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_cashpayment IS 'Чек - Оплаты - Наличные';---- Name: COLUMN ch_cashpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_cft_giftcardpayment IS 'Тип оплаты: подарочная карта ЦФТ';---- Name: COLUMN ch_cft_giftcardpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_cft_giftegcpayment IS 'Сущность, описывающая оплату по ЭПС ЦФТ';---- Name: COLUMN ch_cft_giftegcpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_childrencardpayment (
    id bigint NOT NULL
);
ALTER TABLE public.ch_childrencardpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_childrencardpayment IS 'Чек - Оплаты - Детская карта';---- Name: COLUMN ch_childrencardpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_correctionreceipt IS 'Чек коррекции';---- Name: COLUMN ch_correctionreceipt.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_correctionreceipt_payments (
    id_correction bigint NOT NULL,
    paymentname text NOT NULL,
    paymentsum bigint NOT NULL
);
ALTER TABLE public.ch_correctionreceipt_payments OWNER TO postgres;
COMMENT ON TABLE public.ch_correctionreceipt_payments IS 'Чек коррекции - Оплаты';---- Name: COLUMN ch_correctionreceipt_payments.id_correction; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_correctionreceipt_taxes (
    id_correction bigint NOT NULL,
    tax text NOT NULL,
    taxsum bigint NOT NULL
);
ALTER TABLE public.ch_correctionreceipt_taxes OWNER TO postgres;
COMMENT ON TABLE public.ch_correctionreceipt_taxes IS 'Чек коррекции - Налоги';---- Name: COLUMN ch_correctionreceipt_taxes.id_correction; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_egais_undispatched_data (
    id bigint NOT NULL,
    date date,
    data character varying(5000)
);
ALTER TABLE public.ch_egais_undispatched_data OWNER TO postgres;
COMMENT ON TABLE public.ch_egais_undispatched_data IS 'Неотправленные данные в УТМ ЕГАИС';---- Name: ch_externalbankterminalpayment; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.ch_externalbankterminalpayment (
    id bigint NOT NULL,
    authcode character varying(100),
    cardnum character varying(20),
    checknumber bigint
);
ALTER TABLE public.ch_externalbankterminalpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_externalbankterminalpayment IS 'Чек - Оплаты - Банковская карта - Внешний банковский терминал';---- Name: COLUMN ch_externalbankterminalpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_fictivecashinout (
    cashout_date timestamp without time zone NOT NULL,
    casher text NOT NULL,
    summ bigint,
    id bigint NOT NULL
);
ALTER TABLE public.ch_fictivecashinout OWNER TO postgres;
COMMENT ON TABLE public.ch_fictivecashinout IS 'Информация по фиктивным изъятиям из ФР и внесениям в него для выравнивания счётчиков наличных у кешмашины и ФР(для округления по ФЗ 54)';---- Name: COLUMN ch_fictivecashinout.cashout_date; Type: COMMENT; Schema: public; Owner: postgres--
CREATE SEQUENCE public.ch_fictivecashinout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.ch_fictivecashinout_id_seq OWNER TO postgres;
ALTER SEQUENCE public.ch_fictivecashinout_id_seq OWNED BY public.ch_fictivecashinout.id;
CREATE TABLE public.ch_giftcardpayment (
    id bigint NOT NULL,
    amountcard bigint,
    cardnumber character varying(255)
);
ALTER TABLE public.ch_giftcardpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_giftcardpayment IS 'Чек - Оплаты - Подарочная карта';---- Name: COLUMN ch_giftcardpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_internalcreditcardpayment (
    id bigint NOT NULL,
    cardnumber character varying(255)
);
ALTER TABLE public.ch_internalcreditcardpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_internalcreditcardpayment IS 'Оплата кредитной картой';---- Name: COLUMN ch_internalcreditcardpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_introduction IS 'Внесение денег';---- Name: COLUMN ch_introduction.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_inventory (
    id bigint NOT NULL,
    banknotevalue bigint,
    count bigint,
    id_withdrawal bigint
);
ALTER TABLE public.ch_inventory OWNER TO postgres;
COMMENT ON TABLE public.ch_inventory IS 'Изъятие денег - покупюрная опись';---- Name: COLUMN ch_inventory.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_kopilkabonuscardpayment (
    id bigint NOT NULL,
    authcode text,
    cardnumber text,
    cardnumberhash text
);
ALTER TABLE public.ch_kopilkabonuscardpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_kopilkabonuscardpayment IS 'Чек - Оплаты - Бонусы Копилка';---- Name: COLUMN ch_kopilkabonuscardpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_manual_position_adv_action (
    id bigint NOT NULL,
    actionguid bigint NOT NULL,
    actionname character varying(255),
    qnty bigint NOT NULL,
    id_position bigint NOT NULL
);
ALTER TABLE public.ch_manual_position_adv_action OWNER TO postgres;
COMMENT ON TABLE public.ch_manual_position_adv_action IS 'Чек - Ручные рекламные акции';---- Name: COLUMN ch_manual_position_adv_action.actionguid; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_message (
    id bigint NOT NULL,
    data text
);
ALTER TABLE public.ch_message OWNER TO postgres;
COMMENT ON TABLE public.ch_message IS 'Технические сообщения кассы в формате JSON';---- Name: COLUMN ch_message.data; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_payment IS 'Чек - Оплаты';---- Name: COLUMN ch_payment.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE SEQUENCE public.payment_property_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.payment_property_sequence OWNER TO postgres;
CREATE TABLE public.ch_payment_property (
    id bigint DEFAULT nextval('public.payment_property_sequence'::regclass) NOT NULL,
    payment_id bigint NOT NULL,
    name_id bigint,
    prop_value text
);
ALTER TABLE public.ch_payment_property OWNER TO postgres;
COMMENT ON TABLE public.ch_payment_property IS 'Дополнительные параметры оплат';---- Name: COLUMN ch_payment_property.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_payment_property_name (
    id bigint DEFAULT nextval('public.payment_property_sequence'::regclass) NOT NULL,
    prop_name text NOT NULL
);
ALTER TABLE public.ch_payment_property_name OWNER TO postgres;
COMMENT ON TABLE public.ch_payment_property_name IS 'Справочник имен дополнительных параметров оплат';---- Name: COLUMN ch_payment_property_name.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_payment_transaction IS 'Транзакия оплаты по банковскому терминалу';---- Name: COLUMN ch_payment_transaction.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_payment_transaction_slip (
    payment_transaction_id bigint NOT NULL,
    number integer NOT NULL,
    text_data text NOT NULL
);
ALTER TABLE public.ch_payment_transaction_slip OWNER TO postgres;
COMMENT ON TABLE public.ch_payment_transaction_slip IS 'Копия слипа банковского теримнала';---- Name: COLUMN ch_payment_transaction_slip.payment_transaction_id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_position IS 'Чек - Товарные позиции';---- Name: COLUMN ch_position.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_position_cft_giftcard IS 'Чек - Позиция - Подарочная карта ЦФТ';---- Name: COLUMN ch_position_cft_giftcard.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_position_clothing (
    id bigint NOT NULL,
    cis character varying(255)
);
ALTER TABLE public.ch_position_clothing OWNER TO postgres;
COMMENT ON TABLE public.ch_position_clothing IS 'Разновидность товара: "Одежда".';---- Name: COLUMN ch_position_clothing.cis; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_position_discount_card (
    id bigint NOT NULL,
    card_number character varying(50),
    holder_id character varying(255),
    instant_applicable boolean DEFAULT true NOT NULL
);
ALTER TABLE public.ch_position_discount_card OWNER TO postgres;
COMMENT ON TABLE public.ch_position_discount_card IS 'Чек - Товары - Дисконтная карта (PositionDiscountCardEntity)';---- Name: COLUMN ch_position_discount_card.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_position_exist_balance (
    id bigint NOT NULL,
    uid character varying(36),
    processed boolean,
    cashtransactionid character varying(40),
    transactionid character varying(40),
    available_payments character varying(500)
);
ALTER TABLE public.ch_position_exist_balance OWNER TO postgres;
COMMENT ON TABLE public.ch_position_exist_balance IS 'Разновидность товара: "Баланс IsNext" (ProductExistBalanceEntity)';---- Name: COLUMN ch_position_exist_balance.uid; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_position_license_key IS 'Разновидность товара: "Электронный ключ ПО".';---- Name: COLUMN ch_position_license_key.client_last_name; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_position_measure (
    code character varying(255) NOT NULL,
    name character varying(255)
);
ALTER TABLE public.ch_position_measure OWNER TO postgres;
COMMENT ON TABLE public.ch_position_measure IS 'Единицы измерения (MeasurePositionEntity)';---- Name: COLUMN ch_position_measure.code; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_position_production_date (
    position_id bigint NOT NULL,
    production_date timestamp without time zone NOT NULL,
    quantity bigint NOT NULL
);
ALTER TABLE public.ch_position_production_date OWNER TO postgres;
COMMENT ON TABLE public.ch_position_production_date IS 'Информация о датах производства в позиции';---- Name: COLUMN ch_position_production_date.position_id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.hibernate_sequence OWNER TO postgres;
CREATE TABLE public.ch_position_seller (
    id bigint DEFAULT nextval('public.hibernate_sequence'::regclass) NOT NULL,
    codenum character varying(40) NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    middlename character varying(100)
);
ALTER TABLE public.ch_position_seller OWNER TO postgres;
COMMENT ON TABLE public.ch_position_seller IS 'Продавцы в позициях';---- Name: COLUMN ch_position_seller.codenum; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_position_siebel_giftcard (
    id bigint NOT NULL,
    cardnumber character varying(128)
);
ALTER TABLE public.ch_position_siebel_giftcard OWNER TO postgres;
COMMENT ON TABLE public.ch_position_siebel_giftcard IS 'Разновидность товара: "Подарочная карта Siebel".';---- Name: ch_positiongiftcard; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.ch_positiongiftcard (
    id bigint NOT NULL,
    cardnumber character varying(30),
    amount bigint,
    expirationdate timestamp without time zone
);
ALTER TABLE public.ch_positiongiftcard OWNER TO postgres;
COMMENT ON TABLE public.ch_positiongiftcard IS 'Чек - Товары - Подарочная карта';---- Name: COLUMN ch_positiongiftcard.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_positionmobilepay (
    id bigint NOT NULL
);
ALTER TABLE public.ch_positionmobilepay OWNER TO postgres;
COMMENT ON TABLE public.ch_positionmobilepay IS 'Разновидность товара: "Мобильная оплата".';---- Name: COLUMN ch_positionmobilepay.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_positionservice (
    id bigint NOT NULL,
    accountnumber character varying(255)
);
ALTER TABLE public.ch_positionservice OWNER TO postgres;
COMMENT ON TABLE public.ch_positionservice IS 'Товарная позиция "Услуга"';---- Name: COLUMN ch_positionservice.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_positionspirits (
    id bigint NOT NULL,
    alcoholic_content double precision,
    volume double precision,
    kit boolean,
    alcoholic_type character varying(3)
);
ALTER TABLE public.ch_positionspirits OWNER TO postgres;
COMMENT ON TABLE public.ch_positionspirits IS 'Разновидность товара: "Крепкий алкоголь" (ProductSpiritsEntity)';---- Name: COLUMN ch_positionspirits.alcoholic_content; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_prepayment (
    id bigint NOT NULL
);
ALTER TABLE public.ch_prepayment OWNER TO postgres;
COMMENT ON TABLE public.ch_prepayment IS 'Чек - Оплаты - Зачет предоплаты';---- Name: COLUMN ch_prepayment.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE SEQUENCE public.message_id_msg_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.message_id_msg_seq OWNER TO postgres;
CREATE TABLE public.ch_prisma_events (
    id bigint DEFAULT nextval('public.message_id_msg_seq'::regclass) NOT NULL,
    eventdate timestamp without time zone NOT NULL,
    message character varying(2000) NOT NULL
);
ALTER TABLE public.ch_prisma_events OWNER TO postgres;
COMMENT ON TABLE public.ch_prisma_events IS 'Сообщения призме, которые не удалось передать';---- Name: COLUMN ch_prisma_events.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_property (
    keyprop character varying(255) NOT NULL,
    valueprop character varying(255)
);
ALTER TABLE public.ch_property OWNER TO postgres;
COMMENT ON TABLE public.ch_property IS 'Свойство оплаты';---- Name: ch_purchase; Type: TABLE; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_purchase IS 'Чеки (заголовки чеков)';---- Name: COLUMN ch_purchase.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_purchase_cards IS 'Чек - Товарные позиции';---- Name: COLUMN ch_purchase_cards.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_purchase_excise_bottle IS 'Бутылка акцизного алкогольного товара, когда алкогольный товар является набором';---- Name: COLUMN ch_purchase_excise_bottle.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_purchase_ext_data (
    id_purchase bigint NOT NULL,
    key character varying(100) NOT NULL,
    value text
);
ALTER TABLE public.ch_purchase_ext_data OWNER TO postgres;
COMMENT ON TABLE public.ch_purchase_ext_data IS 'Дополнительные данные чека, параметр=значение';---- Name: COLUMN ch_purchase_ext_data.id_purchase; Type: COMMENT; Schema: public; Owner: postgres--
CREATE SEQUENCE public.storno_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.storno_sequence OWNER TO postgres;
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
COMMENT ON TABLE public.ch_purchase_storno IS 'Информация по сторно (отмене) и изменении позиций в чеке';---- Name: COLUMN ch_purchase_storno.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_purchase_taxes (
    id_purchase bigint NOT NULL,
    ndsclass character varying(3) NOT NULL,
    nds numeric(5,2) NOT NULL,
    ndssum bigint,
    paymentsum bigint
);
ALTER TABLE public.ch_purchase_taxes OWNER TO postgres;
COMMENT ON TABLE public.ch_purchase_taxes IS 'Чек - налоги';---- Name: COLUMN ch_purchase_taxes.id_purchase; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_reportshift IS 'Z/X-отчет';---- Name: COLUMN ch_reportshift.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_reportshift_taxes IS 'Z/X-отчет - Налоги';---- Name: COLUMN ch_reportshift_taxes.id_report; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_reportsshift_payments (
    id_report bigint NOT NULL,
    payment_type character varying(40) NOT NULL,
    operation_type character(1) NOT NULL,
    p_summ bigint NOT NULL
);
ALTER TABLE public.ch_reportsshift_payments OWNER TO postgres;
COMMENT ON TABLE public.ch_reportsshift_payments IS 'Типы оплат для отчетов операционного дня';---- Name: COLUMN ch_reportsshift_payments.id_report; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_reportsshift_products (
    id_report bigint NOT NULL,
    product_type character varying(40) NOT NULL,
    operation_type character(1) NOT NULL,
    p_summ bigint NOT NULL
);
ALTER TABLE public.ch_reportsshift_products OWNER TO postgres;
COMMENT ON TABLE public.ch_reportsshift_products IS 'Типы товаров для отчетов операционного дня';---- Name: COLUMN ch_reportsshift_products.id_report; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_session (
    id bigint NOT NULL,
    datebegin timestamp without time zone NOT NULL,
    dateend timestamp without time zone,
    user_tabnum character varying(40),
    senttoserverstatus integer
);
ALTER TABLE public.ch_session OWNER TO postgres;
COMMENT ON TABLE public.ch_session IS 'Сессии пользователей в документах';---- Name: COLUMN ch_session.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_shift IS 'Смены';---- Name: COLUMN ch_shift.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_shiftstatusdata IS 'Статус смены';---- Name: ch_siebelbonuscardpayment; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.ch_siebelbonuscardpayment (
    id bigint NOT NULL,
    accountid bigint,
    cancelbonuses integer,
    cardnumber character varying(255)
);
ALTER TABLE public.ch_siebelbonuscardpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_siebelbonuscardpayment IS 'Чек - Оплаты - Бонусы Siebel';---- Name: COLUMN ch_siebelbonuscardpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_siebelbonusesasgiftpayment (
    id bigint NOT NULL,
    cardnumber character varying(255)
);
ALTER TABLE public.ch_siebelbonusesasgiftpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_siebelbonusesasgiftpayment IS 'Информация по оплате подарков в процессинге лояльности Siebel';---- Name: ch_siebelgiftcardpayment; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.ch_siebelgiftcardpayment (
    id bigint NOT NULL,
    card_number character varying(255)
);
ALTER TABLE public.ch_siebelgiftcardpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_siebelgiftcardpayment IS 'Оплаты по подарочной карте Siebel';---- Name: ch_suprapayment; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.ch_suprapayment (
    id bigint NOT NULL,
    card_number character varying(50),
    verification_number character varying(5),
    auth_code character varying(50),
    amount bigint
);
ALTER TABLE public.ch_suprapayment OWNER TO postgres;
COMMENT ON TABLE public.ch_suprapayment IS 'Сущность, описывающая оплату по карте СУПРА';---- Name: COLUMN ch_suprapayment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_transaction IS 'Транзакции';---- Name: ch_user; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.ch_user (
    tabnum character varying(40) NOT NULL,
    firstname character varying(100),
    lastname character varying(100),
    middlename character varying(100),
    inn character varying(255)
);
ALTER TABLE public.ch_user OWNER TO postgres;
COMMENT ON TABLE public.ch_user IS 'Пользователи в документах смены';---- Name: COLUMN ch_user.tabnum; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.ch_voucherpayment (
    id bigint NOT NULL,
    vouchernumber character varying(255)
);
ALTER TABLE public.ch_voucherpayment OWNER TO postgres;
COMMENT ON TABLE public.ch_voucherpayment IS 'Оплата ваучером';---- Name: COLUMN ch_voucherpayment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.ch_withdrawal IS 'Изъятия наличных';---- Name: COLUMN ch_withdrawal.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.egais_interactions IS 'Таблица для логов взаимодействия с ЕГАИС (запросы, ответы, ошибки связи по таймауту)';---- Name: COLUMN egais_interactions.shop_number; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.message IS 'Лог активностей кассы';---- Name: ch_fictivecashinout id; Type: DEFAULT; Schema: public; Owner: postgres--
ALTER TABLE ONLY public.ch_fictivecashinout ALTER COLUMN id SET DEFAULT nextval('public.ch_fictivecashinout_id_seq'::regclass);
ALTER TABLE ONLY public.ch_position_measure
    ADD CONSTRAINT cg_measure_pkey PRIMARY KEY (code);
ALTER TABLE ONLY public.ch_bankcardpayment_transaction
    ADD CONSTRAINT ch_bankcardpayment_transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_bonussberbankpayment
    ADD CONSTRAINT ch_bonussberbankpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_cashpayment
    ADD CONSTRAINT ch_cashpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_cft_giftcardpayment
    ADD CONSTRAINT ch_cft_giftcardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_cft_giftegcpayment
    ADD CONSTRAINT ch_cft_giftegcpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_childrencardpayment
    ADD CONSTRAINT ch_childrencardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_position_clothing
    ADD CONSTRAINT ch_clothing_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_correctionreceipt_payments
    ADD CONSTRAINT ch_correctionreceipt_payments_pkey PRIMARY KEY (id_correction, paymentname);
ALTER TABLE ONLY public.ch_correctionreceipt
    ADD CONSTRAINT ch_correctionreceipt_pk PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_correctionreceipt_taxes
    ADD CONSTRAINT ch_correctionreceipt_taxes_pkey PRIMARY KEY (id_correction, tax);
ALTER TABLE ONLY public.ch_externalbankterminalpayment
    ADD CONSTRAINT ch_externalbankterminalpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_fictivecashinout
    ADD CONSTRAINT ch_fictivecashinout_pk PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_giftcardpayment
    ADD CONSTRAINT ch_giftcardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_introduction
    ADD CONSTRAINT ch_introduction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_inventory
    ADD CONSTRAINT ch_inventory_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_position_license_key
    ADD CONSTRAINT ch_license_key_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_manual_position_adv_action
    ADD CONSTRAINT ch_manual_position_adv_action_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_message
    ADD CONSTRAINT ch_message_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_payment
    ADD CONSTRAINT ch_payment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_payment_property_name
    ADD CONSTRAINT ch_payment_property_name_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_payment_property
    ADD CONSTRAINT ch_payment_property_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_payment_transaction
    ADD CONSTRAINT ch_payment_transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_payment_transaction_slip
    ADD CONSTRAINT ch_payment_transaction_slip_pk PRIMARY KEY (payment_transaction_id, number);
ALTER TABLE ONLY public.ch_position_cft_giftcard
    ADD CONSTRAINT ch_position_cft_giftcard_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_position_discount_card
    ADD CONSTRAINT ch_position_discount_card_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_position_exist_balance
    ADD CONSTRAINT ch_position_exist_balance_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_position
    ADD CONSTRAINT ch_position_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_position_production_date
    ADD CONSTRAINT ch_position_production_date_key PRIMARY KEY (position_id, production_date);
ALTER TABLE ONLY public.ch_position_seller
    ADD CONSTRAINT ch_position_seller_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_position_siebel_giftcard
    ADD CONSTRAINT ch_position_siebel_giftcard_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_positiongiftcard
    ADD CONSTRAINT ch_positiongiftcard_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_positionmobilepay
    ADD CONSTRAINT ch_positionmobilepay_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_positionservice
    ADD CONSTRAINT ch_positionservice_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_positionspirits
    ADD CONSTRAINT ch_positionspirits_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_prepayment
    ADD CONSTRAINT ch_prepayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_prisma_events
    ADD CONSTRAINT ch_prisma_events_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_property
    ADD CONSTRAINT ch_property_pkey PRIMARY KEY (keyprop);
ALTER TABLE ONLY public.ch_purchase_cards
    ADD CONSTRAINT ch_purchase_cards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_purchase_excise_bottle
    ADD CONSTRAINT ch_purchase_excise_bottle_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_purchase_ext_data
    ADD CONSTRAINT ch_purchase_ext_data_pkey PRIMARY KEY (id_purchase, key);
ALTER TABLE ONLY public.ch_purchase
    ADD CONSTRAINT ch_purchase_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_purchase_storno
    ADD CONSTRAINT ch_purchase_storno_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_purchase_taxes
    ADD CONSTRAINT ch_purchase_taxes_pkey PRIMARY KEY (id_purchase, ndsclass, nds);
ALTER TABLE ONLY public.ch_reportshift
    ADD CONSTRAINT ch_reportshift_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_reportshift_taxes
    ADD CONSTRAINT ch_reportshift_taxes_pkey PRIMARY KEY (id_report, ndsclass, nds);
ALTER TABLE ONLY public.ch_reportsshift_payments
    ADD CONSTRAINT ch_reportsshift_payments_pkey PRIMARY KEY (id_report, payment_type, operation_type);
ALTER TABLE ONLY public.ch_reportsshift_products
    ADD CONSTRAINT ch_reportsshift_products_pkey PRIMARY KEY (id_report, product_type, operation_type);
ALTER TABLE ONLY public.ch_session
    ADD CONSTRAINT ch_session_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_shift
    ADD CONSTRAINT ch_shift_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_shiftstatusdata
    ADD CONSTRAINT ch_shiftstatusdata_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_suprapayment
    ADD CONSTRAINT ch_suprapayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_user
    ADD CONSTRAINT ch_user_pkey PRIMARY KEY (tabnum);
ALTER TABLE ONLY public.ch_withdrawal
    ADD CONSTRAINT ch_withdrawal_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.egais_interactions
    ADD CONSTRAINT egais_interactions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id_msg);
ALTER TABLE ONLY public.ch_bankcardpayment
    ADD CONSTRAINT pa_bankcardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_bonuscardpayment
    ADD CONSTRAINT pa_bonuscardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_internalcreditcardpayment
    ADD CONSTRAINT pa_internalcreditcardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_kopilkabonuscardpayment
    ADD CONSTRAINT pa_kopilkabonuscardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_siebelbonuscardpayment
    ADD CONSTRAINT pa_siebelbonuscardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_siebelbonusesasgiftpayment
    ADD CONSTRAINT pa_siebelbonusesasgiftpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_siebelgiftcardpayment
    ADD CONSTRAINT pa_siebelgiftcardpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_voucherpayment
    ADD CONSTRAINT pa_voucherpayment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_transaction
    ADD CONSTRAINT ps_transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.ch_payment_property_name
    ADD CONSTRAINT uniq_us_user__tab_num UNIQUE (prop_name);
CREATE INDEX ch_payment_transaction_id_payment_idx ON public.ch_payment_transaction USING btree (id_payment);
CREATE INDEX ch_payment_transaction_id_purchase_idx ON public.ch_payment_transaction USING btree (id_purchase);
CREATE INDEX ch_purchase_cards_id_position_idx ON public.ch_purchase_cards USING btree (id_position);
CREATE INDEX ch_purchase_excise_bottle_id_position_spirits ON public.ch_purchase_excise_bottle USING btree (id_position_spirits);
CREATE INDEX ch_purchase_ext_data_id_purchase_idx ON public.ch_purchase_ext_data USING btree (id_purchase);
CREATE INDEX ch_purchase_storno_id_purchase_idx ON public.ch_purchase_storno USING btree (id_purchase);
CREATE INDEX idx_ch_introduction__id_session ON public.ch_introduction USING btree (id_session);
CREATE INDEX idx_ch_introduction__id_shift ON public.ch_introduction USING btree (id_shift);
CREATE INDEX idx_ch_inventory__id_withdrawal ON public.ch_inventory USING btree (id_withdrawal);
CREATE INDEX idx_ch_manual_position_adv_action__id_position ON public.ch_manual_position_adv_action USING btree (id_position);
CREATE INDEX idx_ch_payment__id_purchase ON public.ch_payment USING btree (id_purchase);
CREATE INDEX idx_ch_position__id_purchase ON public.ch_position USING btree (id_purchase);
CREATE INDEX idx_ch_position_measure_code ON public.ch_position USING btree (measure_code);
CREATE INDEX idx_ch_prisma_events_eventdate ON public.ch_prisma_events USING btree (eventdate);
CREATE INDEX idx_ch_purchase__id_purchaseref ON public.ch_purchase USING btree (id_purchaseref);
CREATE INDEX idx_ch_purchase__id_session ON public.ch_purchase USING btree (id_session);
CREATE INDEX idx_ch_purchase__id_shift ON public.ch_purchase USING btree (id_shift);
CREATE INDEX idx_ch_purchase_cards__id_purchase ON public.ch_purchase_cards USING btree (id_purchase);
CREATE INDEX idx_ch_purchase_excise_bottle__id_purchase ON public.ch_purchase_excise_bottle USING btree (id_purchase);
CREATE INDEX idx_ch_purchase_taxes_id_purchase ON public.ch_purchase_taxes USING btree (id_purchase);
CREATE INDEX idx_ch_reportshift__id_session ON public.ch_reportshift USING btree (id_session);
CREATE INDEX idx_ch_reportshift__id_shift ON public.ch_reportshift USING btree (id_shift);
CREATE INDEX idx_ch_reportshift_taxes__id_report ON public.ch_reportshift_taxes USING btree (id_report);
CREATE INDEX idx_ch_reportsshift_payments__id_report ON public.ch_reportsshift_payments USING btree (id_report);
CREATE INDEX idx_ch_reportsshift_products__id_report ON public.ch_reportsshift_products USING btree (id_report);
CREATE INDEX idx_ch_session__user_tabnum ON public.ch_session USING btree (user_tabnum);
CREATE INDEX idx_ch_shift__id_sessionstart ON public.ch_shift USING btree (id_sessionstart);
CREATE INDEX idx_ch_withdrawal__id_session ON public.ch_withdrawal USING btree (id_session);
CREATE INDEX idx_ch_withdrawal__id_shift ON public.ch_withdrawal USING btree (id_shift);
CREATE INDEX idx_ps_transaction__id_position ON public.ch_transaction USING btree (id_position);
CREATE INDEX ix_ch_payment_property_payment_id ON public.ch_payment_property USING btree (payment_id);
ALTER TABLE ONLY public.ch_reportsshift_payments
    ADD CONSTRAINT "FK_ch_reportshift_payment_types_ch_reportshift" FOREIGN KEY (id_report) REFERENCES public.ch_reportshift(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_reportsshift_products
    ADD CONSTRAINT "FK_ch_reportshift_product_types_ch_reportshift" FOREIGN KEY (id_report) REFERENCES public.ch_reportshift(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_bankcardpayment_transaction
    ADD CONSTRAINT fk_ch_bankcardpayment_transaction__payment_trans FOREIGN KEY (id) REFERENCES public.ch_payment_transaction(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_bonussberbankpayment
    ADD CONSTRAINT fk_ch_bonussberbankpayment_ch_payment_id FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_bankcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_bankcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_bonuscardpayment
    ADD CONSTRAINT fk_ch_payment__ch_bonuscardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_cashpayment
    ADD CONSTRAINT fk_ch_payment__ch_cashpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_cft_giftcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_cft_giftcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_cft_giftegcpayment
    ADD CONSTRAINT fk_ch_payment__ch_cft_giftegcpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_childrencardpayment
    ADD CONSTRAINT fk_ch_payment__ch_childrencardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_externalbankterminalpayment
    ADD CONSTRAINT fk_ch_payment__ch_externalbankterminalpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_giftcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_giftcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_internalcreditcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_internalcreditcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_kopilkabonuscardpayment
    ADD CONSTRAINT fk_ch_payment__ch_kopilkabonuscardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_prepayment
    ADD CONSTRAINT fk_ch_payment__ch_prepayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_siebelbonuscardpayment
    ADD CONSTRAINT fk_ch_payment__ch_siebelbonuscardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_siebelbonusesasgiftpayment
    ADD CONSTRAINT fk_ch_payment__ch_siebelbonusesasgiftpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_siebelgiftcardpayment
    ADD CONSTRAINT fk_ch_payment__ch_siebelgiftcardpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_suprapayment
    ADD CONSTRAINT fk_ch_payment__ch_suprapayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_voucherpayment
    ADD CONSTRAINT fk_ch_payment__ch_voucherpayment FOREIGN KEY (id) REFERENCES public.ch_payment(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_payment_property
    ADD CONSTRAINT fk_ch_payment_property__ch_payment FOREIGN KEY (payment_id) REFERENCES public.ch_payment(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_payment_property
    ADD CONSTRAINT fk_ch_payment_property__ch_payment_property_name FOREIGN KEY (name_id) REFERENCES public.ch_payment_property_name(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY public.ch_payment_transaction
    ADD CONSTRAINT fk_ch_payment_transaction__ch_payment FOREIGN KEY (id_payment) REFERENCES public.ch_payment(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY public.ch_payment_transaction
    ADD CONSTRAINT fk_ch_payment_transaction__ch_purchase FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE ONLY public.ch_payment_transaction_slip
    ADD CONSTRAINT fk_ch_payment_transaction_slip__payment_trans FOREIGN KEY (payment_transaction_id) REFERENCES public.ch_payment_transaction(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position_clothing
    ADD CONSTRAINT fk_ch_position__ch_clothing FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position_license_key
    ADD CONSTRAINT fk_ch_position__ch_license_key FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_manual_position_adv_action
    ADD CONSTRAINT fk_ch_position__ch_manual_position_adv_action FOREIGN KEY (id_position) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position_cft_giftcard
    ADD CONSTRAINT fk_ch_position__ch_position_cft_giftcard FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position_exist_balance
    ADD CONSTRAINT fk_ch_position__ch_position_exist_balance FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position_siebel_giftcard
    ADD CONSTRAINT fk_ch_position__ch_position_siebel_giftcard FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_positiongiftcard
    ADD CONSTRAINT fk_ch_position__ch_positiongiftcard FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_positionservice
    ADD CONSTRAINT fk_ch_position__ch_positionservice FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_positionspirits
    ADD CONSTRAINT fk_ch_position__ch_positionspirits FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase_cards
    ADD CONSTRAINT fk_ch_position__ch_purchase_cards FOREIGN KEY (id_position) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position
    ADD CONSTRAINT fk_ch_position_ch_position_measure_code FOREIGN KEY (measure_code) REFERENCES public.ch_position_measure(code);
ALTER TABLE ONLY public.ch_position_discount_card
    ADD CONSTRAINT fk_ch_position_discount_card__ch_position FOREIGN KEY (id) REFERENCES public.ch_position(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_positionmobilepay
    ADD CONSTRAINT fk_ch_positionservice__ch_positionmobilepay FOREIGN KEY (id) REFERENCES public.ch_positionservice(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_transaction
    ADD CONSTRAINT fk_ch_positionservice__ch_transaction FOREIGN KEY (id_position) REFERENCES public.ch_positionservice(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_payment
    ADD CONSTRAINT fk_ch_purchase__ch_payment FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position
    ADD CONSTRAINT fk_ch_purchase__ch_position FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase
    ADD CONSTRAINT fk_ch_purchase__ch_purchase FOREIGN KEY (id_purchaseref) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase_cards
    ADD CONSTRAINT fk_ch_purchase__ch_purchase_cards FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase_taxes
    ADD CONSTRAINT fk_ch_purchase__ch_purchase_taxes FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase_excise_bottle
    ADD CONSTRAINT fk_ch_purchase_excise_bottle__ch_position FOREIGN KEY (id_position_spirits) REFERENCES public.ch_positionspirits(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase_excise_bottle
    ADD CONSTRAINT fk_ch_purchase_excise_bottle__ch_purchase FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase_ext_data
    ADD CONSTRAINT fk_ch_purchase_ext_data_pkey__ch_purchase FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase_storno
    ADD CONSTRAINT fk_ch_purchase_storno__ch_purchase FOREIGN KEY (id_purchase) REFERENCES public.ch_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_reportshift_taxes
    ADD CONSTRAINT fk_ch_reportshift__ch_reportshift_taxes FOREIGN KEY (id_report) REFERENCES public.ch_reportshift(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_introduction
    ADD CONSTRAINT fk_ch_session__ch_introduction FOREIGN KEY (id_session) REFERENCES public.ch_session(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase
    ADD CONSTRAINT fk_ch_session__ch_purchase FOREIGN KEY (id_session) REFERENCES public.ch_session(id);
ALTER TABLE ONLY public.ch_reportshift
    ADD CONSTRAINT fk_ch_session__ch_reportshift FOREIGN KEY (id_session) REFERENCES public.ch_session(id);
ALTER TABLE ONLY public.ch_shift
    ADD CONSTRAINT fk_ch_session__ch_shift FOREIGN KEY (id_sessionstart) REFERENCES public.ch_session(id);
ALTER TABLE ONLY public.ch_withdrawal
    ADD CONSTRAINT fk_ch_session__ch_withdrawal FOREIGN KEY (id_session) REFERENCES public.ch_session(id);
ALTER TABLE ONLY public.ch_introduction
    ADD CONSTRAINT fk_ch_shift__ch_introduction FOREIGN KEY (id_shift) REFERENCES public.ch_shift(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_purchase
    ADD CONSTRAINT fk_ch_shift__ch_purchase FOREIGN KEY (id_shift) REFERENCES public.ch_shift(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_reportshift
    ADD CONSTRAINT fk_ch_shift__ch_reportshift FOREIGN KEY (id_shift) REFERENCES public.ch_shift(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_withdrawal
    ADD CONSTRAINT fk_ch_shift__ch_withdrawal FOREIGN KEY (id_shift) REFERENCES public.ch_shift(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_session
    ADD CONSTRAINT fk_ch_user__ch_session FOREIGN KEY (user_tabnum) REFERENCES public.ch_user(tabnum);
ALTER TABLE ONLY public.ch_inventory
    ADD CONSTRAINT fk_ch_withdrawal__ch_inventory FOREIGN KEY (id_withdrawal) REFERENCES public.ch_withdrawal(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position_production_date
    ADD CONSTRAINT position_fkey FOREIGN KEY (position_id) REFERENCES public.ch_position(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.ch_position
    ADD CONSTRAINT seller_position_fkey FOREIGN KEY (seller) REFERENCES public.ch_position_seller(id);
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
