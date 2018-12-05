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
CREATE TABLE public.discounts_action_plugin (
    id bigint NOT NULL,
    action_id bigint,
    class_name character varying(255) NOT NULL,
    type character varying(32) NOT NULL
);
ALTER TABLE public.discounts_action_plugin OWNER TO postgres;
COMMENT ON TABLE public.discounts_action_plugin IS 'Плагины, задействованные в РА (ActionPluginEntity)';---- Name: COLUMN discounts_action_plugin.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.discounts_action_plugin_property IS 'Свойства плагина РА (ActionPluginPropertyEntity)';---- Name: COLUMN discounts_action_plugin_property.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.discounts_advertisingactions IS 'Рекламные акции (AdvertisingActionEntity)';---- Name: COLUMN discounts_advertisingactions.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.discounts_advertisingactions_masteractionguids (
    discounts_advertisingactions_id bigint NOT NULL,
    element bigint
);
ALTER TABLE public.discounts_advertisingactions_masteractionguids OWNER TO postgres;
COMMENT ON TABLE public.discounts_advertisingactions_masteractionguids IS 'Рекламные акции с мастер-GUID';---- Name: discounts_advertisingactions_pricetags; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.discounts_advertisingactions_pricetags (
    action_id bigint NOT NULL,
    pricetag_ext_code character varying(255) NOT NULL,
    count smallint DEFAULT 1 NOT NULL
);
ALTER TABLE public.discounts_advertisingactions_pricetags OWNER TO postgres;
COMMENT ON TABLE public.discounts_advertisingactions_pricetags IS 'Привязки РА к шаблонам ценников, на которых содержимое этой РА можно распечатать по умолчанию (AdvertisingActionEntity#pricetagTemplateCodes)';---- Name: COLUMN discounts_advertisingactions_pricetags.action_id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.discounts_advertisingactions_resulttypes (
    discounts_advertisingactions_id bigint NOT NULL,
    element integer
);
ALTER TABLE public.discounts_advertisingactions_resulttypes OWNER TO postgres;
COMMENT ON TABLE public.discounts_advertisingactions_resulttypes IS 'Тип результата рекламной акции';---- Name: discounts_topology_condition; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.discounts_topology_condition (
    id bigint NOT NULL,
    action_id bigint NOT NULL,
    location_type character varying(20),
    location_code bigint
);
ALTER TABLE public.discounts_topology_condition OWNER TO postgres;
COMMENT ON TABLE public.discounts_topology_condition IS 'Список правил, накладывающих ограничения на область применения рекламной акции (CoverageAreaEntity)';---- Name: COLUMN discounts_topology_condition.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.discounts_topology_condition_formats (
    discounts_topology_condition_id bigint NOT NULL,
    element bigint NOT NULL
);
ALTER TABLE public.discounts_topology_condition_formats OWNER TO postgres;
COMMENT ON TABLE public.discounts_topology_condition_formats IS 'Список кодов форматов магазинов, на которые распространяется родительское правило';---- Name: COLUMN discounts_topology_condition_formats.discounts_topology_condition_id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.formats_advertisingactions (
    action_id bigint NOT NULL,
    format_ext_code character varying(255) NOT NULL
);
ALTER TABLE public.formats_advertisingactions OWNER TO postgres;
COMMENT ON TABLE public.formats_advertisingactions IS 'Таблица привязки форматов к акциям';---- Name: COLUMN formats_advertisingactions.action_id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.hibernate_sequence OWNER TO postgres;
CREATE TABLE public.loy_adv_action_in_purchase (
    guid bigint NOT NULL,
    action_name character varying(512) NOT NULL,
    action_type character varying(128) NOT NULL,
    apply_mode character varying(128) NOT NULL,
    external_code character varying(255),
    discount_type character varying(255)
);
ALTER TABLE public.loy_adv_action_in_purchase OWNER TO postgres;
COMMENT ON TABLE public.loy_adv_action_in_purchase IS 'Примененные в чеках Рекламные акции (LoyAdvActionInPurchaseEntity)';---- Name: COLUMN loy_adv_action_in_purchase.guid; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_bonus_plastek_transaction IS 'Списания и начисления бонусов Plas Tek (LoyBonusPlastekTransactionEntity)';---- Name: COLUMN loy_bonus_plastek_transaction.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_bonus_positions (
    id bigint NOT NULL,
    bonus_amount bigint NOT NULL,
    good_code character varying(255) NOT NULL,
    position_order integer NOT NULL,
    advert_act_guid bigint NOT NULL,
    transaction_id bigint
);
ALTER TABLE public.loy_bonus_positions OWNER TO postgres;
COMMENT ON TABLE public.loy_bonus_positions IS 'Детализация начисления/списания бонусов по позициям в чеке (LoyBonusPositionEntity)';---- Name: COLUMN loy_bonus_positions.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_bonus_sberbank_transaction IS 'Транзакция начисления/списания/возврат по списанию/возврат по начислению бонусов через процессинг ЦФТ: "Спасибо от Сбербанка", бонусы ЦФТ, и проч.';---- Name: COLUMN loy_bonus_sberbank_transaction.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_bonus_transactions IS 'Транзакции: начисления/списания бонусов (LoyBonusTransactionEntity)';---- Name: COLUMN loy_bonus_transactions.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_bonusdiscount_transactions (
    id bigint NOT NULL,
    bonus_transaction_id bytea NOT NULL,
    bonus_transaction_id_as_string character varying(255),
    transaction_id bigint
);
ALTER TABLE public.loy_bonusdiscount_transactions OWNER TO postgres;
COMMENT ON TABLE public.loy_bonusdiscount_transactions IS 'Идентификатор (полученный от внешней системы) транзакции списания бонусов как скидки (LoyBonusDiscountTransactionEntity)';---- Name: COLUMN loy_bonusdiscount_transactions.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_cheque_coupons IS 'Напечатанные на чеке купоны (LoyChequeCouponEntity)';---- Name: COLUMN loy_cheque_coupons.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_discount_cards (
    id bigint NOT NULL,
    card_number character varying(256) NOT NULL,
    card_type character varying(100) NOT NULL,
    transaction_id bigint,
    advert_act_guid bigint NOT NULL
);
ALTER TABLE public.loy_discount_cards OWNER TO postgres;
COMMENT ON TABLE public.loy_discount_cards IS 'Примененные карты и купоны (при покупке) (LoyDiscountCardEntity)';---- Name: COLUMN loy_discount_cards.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_discount_positions IS 'Скидки на позицию (LoyDiscountPositionEntity)';---- Name: COLUMN loy_discount_positions.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_feedback (
    receipt_id bigint NOT NULL,
    payload text,
    provider_id character varying(30) NOT NULL,
    feedback_time character varying(30) DEFAULT 'AFTER_FISCALIZE'::character varying NOT NULL,
    processing_name character varying(128),
    resend_count integer
);
ALTER TABLE public.loy_feedback OWNER TO postgres;
COMMENT ON TABLE public.loy_feedback IS 'Фидбэк(ответ) для сторонних поставщиков услуг лояльности по результатам расчета преференций на чек (LoyExtProviderFeedback)';---- Name: COLUMN loy_feedback.receipt_id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_gift_note (
    id bigint NOT NULL,
    advert_act_guid bigint,
    total_count integer DEFAULT 0 NOT NULL,
    loy_transaction_id bigint
);
ALTER TABLE public.loy_gift_note OWNER TO postgres;
COMMENT ON TABLE public.loy_gift_note IS 'Информация о начисленных подарках ("смурфиках") по РА (LoyGiftNoteEnity)';---- Name: COLUMN loy_gift_note.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_gift_note_by_cond (
    id bigint NOT NULL,
    parent bigint,
    cond_id character varying(255),
    calculated_qnty integer DEFAULT 0 NOT NULL
);
ALTER TABLE public.loy_gift_note_by_cond OWNER TO postgres;
COMMENT ON TABLE public.loy_gift_note_by_cond IS 'Детализация информация о начисленных подарках ("смурфиках") по РА - в разрезе условий/калькуляторов количества подарков (LoyGiftNoteByConditionEnity)';---- Name: COLUMN loy_gift_note_by_cond.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_lastdiscountsid IS 'Идентификатор последней загруженной РА';---- Name: loy_notsenddiscountsguid; Type: TABLE; Schema: public; Owner: postgres--
CREATE TABLE public.loy_notsenddiscountsguid (
    id bigint NOT NULL,
    deleted boolean NOT NULL,
    guid bigint NOT NULL,
    version smallint NOT NULL,
    discountguid bigint
);
ALTER TABLE public.loy_notsenddiscountsguid OWNER TO postgres;
COMMENT ON TABLE public.loy_notsenddiscountsguid IS 'Не присланные РА по GUID';---- Name: loy_processing_coupons; Type: TABLE; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_processing_coupons IS 'Обработанные купоны';---- Name: COLUMN loy_processing_coupons.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_purchase_cards (
    id bigint NOT NULL,
    card_number character varying(256) NOT NULL,
    card_type character varying(100) NOT NULL,
    transaction_id bigint
);
ALTER TABLE public.loy_purchase_cards OWNER TO postgres;
COMMENT ON TABLE public.loy_purchase_cards IS 'Примененные карты и купоны (при покупке) (LoyDiscountCardEntity)';---- Name: COLUMN loy_purchase_cards.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_questionary (
    id bigint NOT NULL,
    answer_boolean_type boolean,
    answer_number_type integer,
    question_number integer NOT NULL,
    advert_act_guid bigint NOT NULL,
    transaction_id bigint
);
ALTER TABLE public.loy_questionary OWNER TO postgres;
COMMENT ON TABLE public.loy_questionary IS 'Ответы на вопросы анкеты (LoyQuestionaryEntity)';---- Name: COLUMN loy_questionary.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_set_api_loyalty_transaction (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    bonus_transaction_id character varying(255) NOT NULL,
    processing_name character varying(255) NOT NULL
);
ALTER TABLE public.loy_set_api_loyalty_transaction OWNER TO postgres;
CREATE TABLE public.loy_tokens_siebel_transaction (
    id bigint NOT NULL,
    payment_option_id integer NOT NULL,
    ean character varying(255) NOT NULL,
    transaction_id bigint NOT NULL
);
ALTER TABLE public.loy_tokens_siebel_transaction OWNER TO postgres;
COMMENT ON TABLE public.loy_tokens_siebel_transaction IS 'Списания марок Siebel (LoyTokenSiebelTransactionEntity)';---- Name: COLUMN loy_tokens_siebel_transaction.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_transaction IS 'Транзакции/Проводки/Продажи (LoyTransactionEntity)';---- Name: COLUMN loy_transaction.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_transaction_purchase IS 'Описывает покупку, на которую была создана транзакция лояльности (вычисление скидок) (LoyPurchaseEntity)';---- Name: COLUMN loy_transaction_purchase.id; Type: COMMENT; Schema: public; Owner: postgres--
CREATE TABLE public.loy_transaction_purchase_payment (
    id bigint NOT NULL,
    amount bigint,
    typeclass character varying(255),
    purchase bigint NOT NULL
);
ALTER TABLE public.loy_transaction_purchase_payment OWNER TO postgres;
COMMENT ON TABLE public.loy_transaction_purchase_payment IS 'Описывает оплату, что была использована при покупке (LoyPurchasePaymentEntity)';---- Name: COLUMN loy_transaction_purchase_payment.id; Type: COMMENT; Schema: public; Owner: postgres--
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
COMMENT ON TABLE public.loy_transaction_purchase_position IS 'Описывает позицию в покупке (LoyPurchasePositionEntity)';---- Name: COLUMN loy_transaction_purchase_position.id; Type: COMMENT; Schema: public; Owner: postgres--
ALTER TABLE ONLY public.discounts_action_plugin
    ADD CONSTRAINT discounts_action_plugin_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.discounts_action_plugin_property
    ADD CONSTRAINT discounts_action_plugin_property_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.discounts_advertisingactions
    ADD CONSTRAINT discounts_advertisingactions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.discounts_topology_condition
    ADD CONSTRAINT discounts_topology_condition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_adv_action_in_purchase
    ADD CONSTRAINT loy_adv_action_in_purchase_pkey PRIMARY KEY (guid);
ALTER TABLE ONLY public.loy_bonus_plastek_transaction
    ADD CONSTRAINT loy_bonus_plastek_transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_bonus_positions
    ADD CONSTRAINT loy_bonus_positions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_bonus_sberbank_transaction
    ADD CONSTRAINT loy_bonus_sberbank_transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_bonus_transactions
    ADD CONSTRAINT loy_bonus_transactions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_bonusdiscount_transactions
    ADD CONSTRAINT loy_bonusdiscount_transactions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_cheque_coupons
    ADD CONSTRAINT loy_cheque_coupons_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_discount_cards
    ADD CONSTRAINT loy_discount_cards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_discount_positions
    ADD CONSTRAINT loy_discount_positions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_feedback
    ADD CONSTRAINT loy_feedback_pkey PRIMARY KEY (receipt_id, provider_id, feedback_time);
ALTER TABLE ONLY public.loy_gift_note_by_cond
    ADD CONSTRAINT loy_gift_note_by_cond_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_gift_note
    ADD CONSTRAINT loy_gift_note_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_lastdiscountsid
    ADD CONSTRAINT loy_lastdiscountsid_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_notsenddiscountsguid
    ADD CONSTRAINT loy_notsenddiscountsguid_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_processing_coupons
    ADD CONSTRAINT loy_processing_coupons_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_purchase_cards
    ADD CONSTRAINT loy_purchase_cards_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_questionary
    ADD CONSTRAINT loy_questionary_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_set_api_loyalty_transaction
    ADD CONSTRAINT loy_set_api_loyalty_transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_tokens_siebel_transaction
    ADD CONSTRAINT loy_tokens_siebel_transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_transaction
    ADD CONSTRAINT loy_transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_transaction_purchase_payment
    ADD CONSTRAINT loy_transaction_purchase_payment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_transaction_purchase
    ADD CONSTRAINT loy_transaction_purchase_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.loy_transaction_purchase_position
    ADD CONSTRAINT loy_transaction_purchase_position_pkey PRIMARY KEY (id);
CREATE INDEX action_pricetags_fk_idx ON public.discounts_advertisingactions_pricetags USING btree (action_id);
CREATE INDEX discounts_action_plugin_action_id_idx ON public.discounts_action_plugin USING btree (action_id);
CREATE INDEX discounts_action_plugin_property_action_id_idx ON public.discounts_action_plugin_property USING btree (action_id);
CREATE INDEX discounts_action_plugin_property_parent_id_idx ON public.discounts_action_plugin_property USING btree (parent_id);
CREATE INDEX discounts_action_plugin_property_plugin_id_idx ON public.discounts_action_plugin_property USING btree (plugin_id);
CREATE INDEX discounts_formats_action_fk_idx ON public.formats_advertisingactions USING btree (action_id);
CREATE INDEX discounts_formats_format_fk_idx ON public.formats_advertisingactions USING btree (format_ext_code);
CREATE INDEX idx_loy_bonusdiscount_transactions__loy_tx ON public.loy_bonusdiscount_transactions USING btree (transaction_id);
CREATE INDEX idx_loy_gift_note__action ON public.loy_gift_note USING btree (advert_act_guid);
CREATE INDEX idx_loy_gift_note__loy_tx ON public.loy_gift_note USING btree (loy_transaction_id);
CREATE INDEX idx_loy_gift_note_by_cond__parent ON public.loy_gift_note_by_cond USING btree (parent);
CREATE INDEX ix_bonus_positions_id_trans ON public.loy_bonus_positions USING btree (transaction_id);
CREATE INDEX ix_bonus_transactions_id_trans ON public.loy_bonus_transactions USING btree (transaction_id);
CREATE INDEX ix_disc_cards_id_trans ON public.loy_discount_cards USING btree (transaction_id);
CREATE INDEX ix_disc_positions_id_trans ON public.loy_discount_positions USING btree (transaction_id);
CREATE INDEX ix_loy_bpt_tx_to_tx_fkey ON public.loy_bonus_plastek_transaction USING btree (loy_transaction_id);
CREATE INDEX ix_loy_bsb_tx_to_tx_fkey ON public.loy_bonus_sberbank_transaction USING btree (loy_transaction_id);
CREATE INDEX ix_loy_cheque_coupons_id_trans ON public.loy_cheque_coupons USING btree (transaction_id);
CREATE INDEX ix_loy_questionary_id_trans ON public.loy_questionary USING btree (transaction_id);
CREATE INDEX ix_loy_transaction_sale_time ON public.loy_transaction USING btree (sale_time);
CREATE INDEX ix_process_coupons_id_trans ON public.loy_processing_coupons USING btree (transaction_id);
CREATE INDEX ix_purch_cards_id_trans ON public.loy_purchase_cards USING btree (transaction_id);
CREATE INDEX loy_api_tst_tx_to_tx_fkey ON public.loy_set_api_loyalty_transaction USING btree (transaction_id);
CREATE INDEX loy_tst_tx_to_tx_fkey ON public.loy_tokens_siebel_transaction USING btree (transaction_id);
ALTER TABLE ONLY public.loy_bonus_positions
    ADD CONSTRAINT fk19f1d961e31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);
ALTER TABLE ONLY public.loy_bonus_positions
    ADD CONSTRAINT fk__loy_bonus_positions__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_bonus_transactions
    ADD CONSTRAINT fk__loy_bonus_transactions__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_bonusdiscount_transactions
    ADD CONSTRAINT fk__loy_bonusdiscount_transactions__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_cheque_coupons
    ADD CONSTRAINT fk__loy_cheque_coupons__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_discount_cards
    ADD CONSTRAINT fk__loy_discount_cards__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_discount_positions
    ADD CONSTRAINT fk__loy_discount_positions__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_processing_coupons
    ADD CONSTRAINT fk__loy_processing_coupons__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_purchase_cards
    ADD CONSTRAINT fk__loy_purchase_cards__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_questionary
    ADD CONSTRAINT fk__loy_questionary__loy_transaction FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.discounts_action_plugin
    ADD CONSTRAINT fk_discounts_action_plugin_discounts_advertisingactions_id FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.discounts_action_plugin_property
    ADD CONSTRAINT fk_discounts_action_plugin_property_discounts_action_id FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.discounts_action_plugin_property
    ADD CONSTRAINT fk_discounts_action_plugin_property_discounts_action_plugin_id FOREIGN KEY (plugin_id) REFERENCES public.discounts_action_plugin(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.discounts_action_plugin_property
    ADD CONSTRAINT fk_discounts_action_plugin_property_discounts_action_plugin_pro FOREIGN KEY (parent_id) REFERENCES public.discounts_action_plugin_property(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.discounts_advertisingactions_masteractionguids
    ADD CONSTRAINT fk_discounts_advertisingactions_masteractionguids_discounts_adv FOREIGN KEY (discounts_advertisingactions_id) REFERENCES public.discounts_advertisingactions(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.discounts_advertisingactions_pricetags
    ADD CONSTRAINT fk_discounts_advertisingactions_pricetags_action_id FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.discounts_topology_condition
    ADD CONSTRAINT fk_discounts_topology_condition_discounts_advertisingactions FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.discounts_topology_condition_formats
    ADD CONSTRAINT fk_discounts_topology_condition_formats_discounts_topology_cond FOREIGN KEY (discounts_topology_condition_id) REFERENCES public.discounts_topology_condition(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_gift_note
    ADD CONSTRAINT fk_loy_gift_note__action FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid) ON DELETE SET NULL;
ALTER TABLE ONLY public.loy_gift_note
    ADD CONSTRAINT fk_loy_gift_note__loy_tx FOREIGN KEY (loy_transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_gift_note_by_cond
    ADD CONSTRAINT fk_loy_gift_note_by_cond__loy_gift_note FOREIGN KEY (parent) REFERENCES public.loy_gift_note(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_transaction
    ADD CONSTRAINT fk_loy_transaction_loy_transaction_purchase_id FOREIGN KEY (purchase) REFERENCES public.loy_transaction_purchase(id);
ALTER TABLE ONLY public.loy_transaction_purchase_payment
    ADD CONSTRAINT fk_loy_transaction_purchase_payment_loy_transaction_purchase_id FOREIGN KEY (purchase) REFERENCES public.loy_transaction_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_transaction_purchase_position
    ADD CONSTRAINT fk_loy_transaction_purchase_position_loy_transaction_purchase_i FOREIGN KEY (purchase) REFERENCES public.loy_transaction_purchase(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_questionary
    ADD CONSTRAINT fka80f9d59e31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);
ALTER TABLE ONLY public.loy_bonus_transactions
    ADD CONSTRAINT fka9a504fee31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);
ALTER TABLE ONLY public.loy_processing_coupons
    ADD CONSTRAINT fkaabd076ae31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);
ALTER TABLE ONLY public.loy_discount_positions
    ADD CONSTRAINT fkbb82e675e31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid) ON DELETE SET NULL;
ALTER TABLE ONLY public.loy_discount_cards
    ADD CONSTRAINT fkbb987654321cbcf4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);
ALTER TABLE ONLY public.loy_cheque_coupons
    ADD CONSTRAINT fkc7d208f8e31da7b4 FOREIGN KEY (advert_act_guid) REFERENCES public.loy_adv_action_in_purchase(guid);
ALTER TABLE ONLY public.discounts_advertisingactions_resulttypes
    ADD CONSTRAINT fkd9099723c6383af FOREIGN KEY (discounts_advertisingactions_id) REFERENCES public.discounts_advertisingactions(id);
ALTER TABLE ONLY public.formats_advertisingactions
    ADD CONSTRAINT formats_advertisingactions_action_id_fkey FOREIGN KEY (action_id) REFERENCES public.discounts_advertisingactions(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_set_api_loyalty_transaction
    ADD CONSTRAINT loy_api_tst_tx_to_tx_fkey FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_bonus_plastek_transaction
    ADD CONSTRAINT loy_bpt_tx_to_tx_fkey FOREIGN KEY (loy_transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_bonus_sberbank_transaction
    ADD CONSTRAINT loy_bsb_tx_to_tx_fkey FOREIGN KEY (loy_transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.loy_tokens_siebel_transaction
    ADD CONSTRAINT loy_tst_tx_to_tx_fkey FOREIGN KEY (transaction_id) REFERENCES public.loy_transaction(id) ON DELETE CASCADE;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
