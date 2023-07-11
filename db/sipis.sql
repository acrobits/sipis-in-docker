--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: format_incoming_call_pn(text, text, text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.format_incoming_call_pn(p_appid text, p_selector text, p_userdisplayname text, p_username text, p_domain text, p_timestamp integer, p_callcount integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN '';
END
$$;


--
-- Name: format_instance_off_pn(text, text, text, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.format_instance_off_pn(p_appid text, p_selector text, p_username text, p_domain text, p_callcount integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
pn text := '';
BEGIN
IF p_appid = 'cz.acrobits.softphone.invoice' 
OR p_appid = 'cz.acrobits.softphone.fone2'
OR p_appid = 'cz.acrobits.softphone.sim2dial'
OR p_appid = 'cz.acrobits.softphone.megamobile' THEN
pn := '{"aps":{"alert":{"loc-key":"Your account has expired on the Push server. Start the app, register with the SIP server to refresh.","loc-args":null,"action-loc-key":null},"badge":$COUNT$,"sound":"unreg.wav"},"s":"$SELECTOR$"}';
SELECT replace(pn, '$SELECTOR$', p_selector) INTO pn;
SELECT replace(pn, '$COUNT$', '' || p_callcount) INTO pn;
ELSIF p_appid = 'cz.acrobits.softphone.peoplefone' THEN
pn := '{"aps":{"alert":{"loc-key":"Just as info: Your activated push-function has not been used for the last 3 days.","loc-args":null,"action-loc-key":null},"badge":$COUNT$,"sound":"unreg.wav"},"s":"$SELECTOR$"}';
SELECT replace(pn, '$SELECTOR$', p_selector) INTO pn;
SELECT replace(pn, '$COUNT$', '' || p_callcount) INTO pn;
END IF;
RETURN pn;
END
$_$;


--
-- Name: format_text_message_pn(text, text, text, text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.format_text_message_pn(p_appid text, p_selector text, p_userdisplayname text, p_username text, p_domain text, p_timestamp integer, p_callcount integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN '';
END
$$;


--
-- Name: log_registered_instance(character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.log_registered_instance(p_selector character varying, p_appid character varying) RETURNS void
    LANGUAGE sql
    AS $$$$;


--
-- Name: FUNCTION log_registered_instance(p_selector character varying, p_appid character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.log_registered_instance(p_selector character varying, p_appid character varying) IS 'empty body';


--
-- Name: mytable_data_trunc_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.mytable_data_trunc_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  NEW.data = substring(NEW.data for 2);
  return NEW;
end;
$$;


--
-- Name: truncate_value_trigger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.truncate_value_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
begin
NEW.value = substring(NEW.value for 255);
return NEW;
end;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data (
    name character varying(64),
    value character varying(255),
    rowid bigint NOT NULL,
    id integer,
    longvalue text
);


--
-- Name: data_rowid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_rowid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_rowid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_rowid_seq OWNED BY public.data.rowid;


--
-- Name: mytable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mytable (
    data character varying(2)
);


--
-- Name: pushtests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pushtests (
    id integer NOT NULL,
    pushid character varying(64) NOT NULL,
    platform character varying(255) NOT NULL,
    started timestamp without time zone NOT NULL,
    concluded timestamp without time zone
);


--
-- Name: remoteagents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.remoteagents (
    id integer NOT NULL,
    remoteagentname text NOT NULL,
    remoteagenttype text NOT NULL,
    lastseen timestamp with time zone NOT NULL
);


--
-- Name: restart; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.restart (
    rowid integer NOT NULL,
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    value character varying(255),
    seq integer DEFAULT 0 NOT NULL,
    server character varying(100),
    longvalue text
);


--
-- Name: restart_rowid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.restart_rowid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: restart_rowid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.restart_rowid_seq OWNED BY public.restart.rowid;


--
-- Name: selectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.selectors (
    id integer NOT NULL,
    selector character varying(64),
    lastseen timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: selectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.selectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: selectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.selectors_id_seq OWNED BY public.selectors.id;


--
-- Name: sipcalls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sipcalls (
    rowid integer NOT NULL,
    id integer NOT NULL,
    scheme character varying(6),
    userdisplayname character varying(255),
    username character varying(255),
    domain character varying(255),
    domainport integer,
    callid character varying(255),
    "time" timestamp with time zone NOT NULL
);


--
-- Name: sipcalls_rowid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sipcalls_rowid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sipcalls_rowid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sipcalls_rowid_seq OWNED BY public.sipcalls.rowid;


--
-- Name: siptextmessages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.siptextmessages (
    rowid integer NOT NULL,
    id integer NOT NULL,
    scheme character varying(6),
    userdisplayname character varying(255),
    username character varying(255),
    domain character varying(255),
    domainport integer,
    msgid character varying(255),
    contenttype character varying(255),
    body text,
    "time" timestamp with time zone NOT NULL,
    headers text
);


--
-- Name: sipmessages_rowid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sipmessages_rowid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sipmessages_rowid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sipmessages_rowid_seq OWNED BY public.siptextmessages.rowid;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tokens (
    rowid integer NOT NULL,
    id integer NOT NULL,
    token text NOT NULL,
    appid character varying(200) NOT NULL,
    lastseen timestamp with time zone
);


--
-- Name: tokens_rowid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tokens_rowid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tokens_rowid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tokens_rowid_seq OWNED BY public.tokens.rowid;


--
-- Name: data rowid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data ALTER COLUMN rowid SET DEFAULT nextval('public.data_rowid_seq'::regclass);


--
-- Name: restart rowid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.restart ALTER COLUMN rowid SET DEFAULT nextval('public.restart_rowid_seq'::regclass);


--
-- Name: selectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selectors ALTER COLUMN id SET DEFAULT nextval('public.selectors_id_seq'::regclass);


--
-- Name: sipcalls rowid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sipcalls ALTER COLUMN rowid SET DEFAULT nextval('public.sipcalls_rowid_seq'::regclass);


--
-- Name: siptextmessages rowid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.siptextmessages ALTER COLUMN rowid SET DEFAULT nextval('public.sipmessages_rowid_seq'::regclass);


--
-- Name: tokens rowid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens ALTER COLUMN rowid SET DEFAULT nextval('public.tokens_rowid_seq'::regclass);


--
-- Name: data data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data
    ADD CONSTRAINT data_pkey PRIMARY KEY (rowid);


--
-- Name: remoteagents remoteagents_id_remoteagentname_remoteagenttype_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.remoteagents
    ADD CONSTRAINT remoteagents_id_remoteagentname_remoteagenttype_key UNIQUE (id, remoteagentname, remoteagenttype);


--
-- Name: restart restart_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.restart
    ADD CONSTRAINT restart_id_key UNIQUE (id, name, seq);


--
-- Name: restart restart_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.restart
    ADD CONSTRAINT restart_pkey PRIMARY KEY (rowid);


--
-- Name: selectors selectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selectors
    ADD CONSTRAINT selectors_pkey PRIMARY KEY (id);


--
-- Name: selectors selectors_selector_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.selectors
    ADD CONSTRAINT selectors_selector_key UNIQUE (selector);


--
-- Name: tokens tokens_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_id_key UNIQUE (id, token, appid);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (rowid);


--
-- Name: fki_; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_ ON public.restart USING btree (id);


--
-- Name: fki_sel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_sel_id ON public.data USING btree (id);


--
-- Name: id_server_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX id_server_idx ON public.restart USING btree (id, server);


--
-- Name: id_sipcalls_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX id_sipcalls_idx ON public.sipcalls USING btree (id);


--
-- Name: id_siptextmessages_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX id_siptextmessages_idx ON public.siptextmessages USING btree (id);


--
-- Name: pushtestsunq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX pushtestsunq ON public.pushtests USING btree (id, pushid);


--
-- Name: selectorsuffixindex; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX selectorsuffixindex ON public.selectors USING btree ("substring"((selector)::text, 41));


--
-- Name: server_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX server_idx ON public.restart USING btree (server);


--
-- Name: time_sipcalls_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX time_sipcalls_idx ON public.sipcalls USING btree ("time");


--
-- Name: time_sipmessages_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX time_sipmessages_idx ON public.siptextmessages USING btree ("time");


--
-- Name: restart restart_replace_rule; Type: RULE; Schema: public; Owner: -
--

CREATE RULE restart_replace_rule AS
    ON INSERT TO public.restart
   WHERE (EXISTS ( SELECT 1
           FROM public.restart restart_1
          WHERE ((restart_1.id = new.id) AND ((restart_1.name)::text = (new.name)::text) AND (restart_1.seq = new.seq)))) DO INSTEAD  UPDATE public.restart SET value = new.value
  WHERE ((restart.id = new.id) AND ((restart.name)::text = (new.name)::text) AND (restart.seq = new.seq));


--
-- Name: tokens update_token; Type: RULE; Schema: public; Owner: -
--

CREATE RULE update_token AS
    ON INSERT TO public.tokens
   WHERE (EXISTS ( SELECT 1
           FROM public.tokens tokens_1
          WHERE ((tokens_1.id = new.id) AND (tokens_1.token = new.token) AND ((tokens_1.appid)::text = (new.appid)::text)))) DO INSTEAD  UPDATE public.tokens SET lastseen = now()
  WHERE ((tokens.id = new.id) AND (tokens.token = new.token) AND ((tokens.appid)::text = (new.appid)::text));


--
-- Name: remoteagents updateremoteagents; Type: RULE; Schema: public; Owner: -
--

CREATE RULE updateremoteagents AS
    ON INSERT TO public.remoteagents
   WHERE (EXISTS ( SELECT 1
           FROM public.remoteagents remoteagents_1
          WHERE ((remoteagents_1.id = new.id) AND (remoteagents_1.remoteagentname = new.remoteagentname) AND (remoteagents_1.remoteagenttype = new.remoteagenttype)))) DO INSTEAD  UPDATE public.remoteagents SET lastseen = new.lastseen
  WHERE ((remoteagents.id = new.id) AND (remoteagents.remoteagentname = new.remoteagentname) AND (remoteagents.remoteagenttype = new.remoteagenttype));


--
-- Name: mytable mytable_data_truncate_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER mytable_data_truncate_trigger BEFORE INSERT OR UPDATE ON public.mytable FOR EACH ROW EXECUTE PROCEDURE public.mytable_data_trunc_trigger();


--
-- Name: remoteagents remoteagents_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.remoteagents
    ADD CONSTRAINT remoteagents_id_fkey FOREIGN KEY (id) REFERENCES public.selectors(id) ON DELETE CASCADE;


--
-- Name: restart restart_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.restart
    ADD CONSTRAINT restart_id_fkey FOREIGN KEY (id) REFERENCES public.selectors(id) ON DELETE CASCADE;


--
-- Name: data sel_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data
    ADD CONSTRAINT sel_id FOREIGN KEY (id) REFERENCES public.selectors(id) ON DELETE CASCADE;


--
-- Name: sipcalls sipcalls_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sipcalls
    ADD CONSTRAINT sipcalls_id_fkey FOREIGN KEY (id) REFERENCES public.selectors(id) ON DELETE CASCADE;


--
-- Name: siptextmessages sipmessages_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.siptextmessages
    ADD CONSTRAINT sipmessages_id_fkey FOREIGN KEY (id) REFERENCES public.selectors(id) ON DELETE CASCADE;


--
-- Name: tokens tokens_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_id_fkey FOREIGN KEY (id) REFERENCES public.selectors(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

