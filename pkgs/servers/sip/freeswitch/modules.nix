{ libopus
, opusfile
, libopusenc
, libogg
, libctb
, gsmlib
, lua
, curl
, ffmpeg
, libmysqlclient
, postgresql
, spandsp3
, sofia_sip
, libks
}:

let

mk = path: inputs: { inherit path inputs; };

in

# TODO: many of these are untested and missing required inputs
{
  applications = {
    abstraction = mk "applications/mod_abstraction" [];
    av = mk "applications/mod_av" [ ffmpeg ];
    avmd = mk "applications/mod_avmd" [];
    bert = mk "applications/mod_bert" [];
    blacklist = mk "applications/mod_blacklist" [];
    callcenter = mk "applications/mod_callcenter" [];
    cidlookup = mk "applications/mod_cidlookup" [];
    cluechoo = mk "applications/mod_cluechoo" [];
    commands = mk "applications/mod_commands" [];
    conference = mk "applications/mod_conference" [];
    curl = mk "applications/mod_curl" [ curl ];
    cv = mk "applications/mod_cv" [];
    db = mk "applications/mod_db" [];
    directory = mk "applications/mod_directory" [];
    distributor = mk "applications/mod_distributor" [];
    dptools = mk "applications/mod_dptools" [];
    easyroute = mk "applications/mod_easyroute" [];
    enum = mk "applications/mod_enum" [];
    esf = mk "applications/mod_esf" [];
    esl = mk "applications/mod_esl" [];
    expr = mk "applications/mod_expr" [];
    fifo = mk "applications/mod_fifo" [];
    fsk = mk "applications/mod_fsk" [];
    fsv = mk "applications/mod_fsv" [];
    hash = mk "applications/mod_hash" [];
    hiredis = mk "applications/mod_hiredis" [];
    httapi = mk "applications/mod_httapi" [];
    http_cache = mk "applications/mod_http_cache" [];
    ladspa = mk "applications/mod_ladspa" [];
    lcr = mk "applications/mod_lcr" [];
    memcache = mk "applications/mod_memcache" [];
    mongo = mk "applications/mod_mongo" [];
    mp4 = mk "applications/mod_mp4" [];
    mp4v2 = mk "applications/mod_mp4v2" [];
    nibblebill = mk "applications/mod_nibblebill" [];
    oreka = mk "applications/mod_oreka" [];
    osp = mk "applications/mod_osp" [];
    prefix = mk "applications/mod_prefix" [];
    rad_auth = mk "applications/mod_rad_auth" [];
    redis = mk "applications/mod_redis" [];
    rss = mk "applications/mod_rss" [];
    signalwire = mk "applications/mod_signalwire" [];
    sms = mk "applications/mod_sms" [];
    sms_flowroute = mk "applications/mod_sms_flowroute" [];
    snapshot = mk "applications/mod_snapshot" [];
    snom = mk "applications/mod_snom" [];
    sonar = mk "applications/mod_sonar" [];
    soundtouch = mk "applications/mod_soundtouch" [];
    spandsp = mk "applications/mod_spandsp" [ spandsp3 ];
    spy = mk "applications/mod_spy" [];
    stress = mk "applications/mod_stress" [];
    translate = mk "applications/mod_translate" [];
    valet_parking = mk "applications/mod_valet_parking" [];
    video_filter = mk "applications/mod_video_filter" [];
    vmd = mk "applications/mod_vmd" [];
    voicemail = mk "applications/mod_voicemail" [];
    voicemail_ivr = mk "applications/mod_voicemail_ivr" [];
  };

  ast_tts = {
    cepstral = mk "ast_tts/mod_cepstral" [];
    flite = mk "ast_tts/mod_flite" [];
    pocketsphinx = mk "ast_tts/mod_pocketsphinx" [];
    tts_commandline = mk "ast_tts/mod_tts_commandline" [];
    unimrcp = mk "ast_tts/mod_unimrcp" [];
  };

  codecs = {
    amr = mk "codecs/mod_amr" [];
    amrwb = mk "codecs/mod_amrwb" [];
    b64 = mk "codecs/mod_b64" [];
    bv = mk "codecs/mod_bv" [];
    clearmode = mk "codecs/mod_clearmode" [];
    codec2 = mk "codecs/mod_codec2" [];
    com_g729 = mk "codecs/mod_com_g729" [];
    dahdi_codec = mk "codecs/mod_dahdi_codec" [];
    g723_1 = mk "codecs/mod_g723_1" [];
    g729 = mk "codecs/mod_g729" [];
    h26x = mk "codecs/mod_h26x" [];
    ilbc = mk "codecs/mod_ilbc" [];
    isac = mk "codecs/mod_isac" [];
    mp4v = mk "codecs/mod_mp4v" [];
    opus = mk "codecs/mod_opus" [ libopus ];
    sangoma_codec = mk "codecs/mod_sangoma_codec" [];
    silk = mk "codecs/mod_silk" [];
    siren = mk "codecs/mod_siren" [];
    theora = mk "codecs/mod_theora" [];
  };

  databases = {
    mariadb = mk "databases/mod_mariadb" [ libmysqlclient ];
    pgsql = mk "databases/mod_pgsql" [ postgresql ];
  };

  dialplans = {
    asterisk = mk "dialplans/mod_dialplan_asterisk" [];
    directory = mk "dialplans/mod_dialplan_directory" [];
    xml = mk "dialplans/mod_dialplan_xml" [];
  };

  directories = {
    ldap = mk "directories/mod_ldap" [];
  };

  endpoints = {
    alsa = mk "endpoints/mod_alsa" [];
    dingaling = mk "endpoints/mod_dingaling" [];
    gsmopen = mk "endpoints/mod_gsmopen" [ gsmlib libctb ];
    h323 = mk "endpoints/mod_h323" [];
    khomp = mk "endpoints/mod_khomp" [];
    loopback = mk "endpoints/mod_loopback" [];
    opal = mk "endpoints/mod_opal" [];
    portaudio = mk "endpoints/mod_portaudio" [];
    rtc = mk "endpoints/mod_rtc" [];
    rtmp = mk "endpoints/mod_rtmp" [];
    skinny = mk "endpoints/mod_skinny" [];
    sofia = mk "endpoints/mod_sofia" [ sofia_sip ];
    verto = mk "endpoints/mod_verto" [ libks ];
  };

  event_handlers = {
    amqp = mk "event_handlers/mod_amqp" [];
    cdr_csv = mk "event_handlers/mod_cdr_csv" [];
    cdr_mongodb = mk "event_handlers/mod_cdr_mongodb" [];
    cdr_pg_csv = mk "event_handlers/mod_cdr_pg_csv" [];
    cdr_sqlite = mk "event_handlers/mod_cdr_sqlite" [];
    erlang_event = mk "event_handlers/mod_erlang_event" [];
    event_multicast = mk "event_handlers/mod_event_multicast" [];
    event_socket = mk "event_handlers/mod_event_socket" [];
    fail2ban = mk "event_handlers/mod_fail2ban" [];
    format_cdr = mk "event_handlers/mod_format_cdr" [];
    json_cdr = mk "event_handlers/mod_json_cdr" [];
    radius_cdr = mk "event_handlers/mod_radius_cdr" [];
    odbc_cdr = mk "event_handlers/mod_odbc_cdr" [];
    kazoo = mk "event_handlers/mod_kazoo" [];
    rayo = mk "event_handlers/mod_rayo" [];
    smpp = mk "event_handlers/mod_smpp" [];
    snmp = mk "event_handlers/mod_snmp" [];
    event_zmq = mk "event_handlers/mod_event_zmq" [];
  };

  formats = {
    imagick = mk "formats/mod_imagick" [];
    local_stream = mk "formats/mod_local_stream" [];
    native_file = mk "formats/mod_native_file" [];
    opusfile = mk "formats/mod_opusfile" [ libopus opusfile libopusenc libogg ];
    png = mk "formats/mod_png" [];
    portaudio_stream = mk "formats/mod_portaudio_stream" [];
    shell_stream = mk "formats/mod_shell_stream" [];
    shout = mk "formats/mod_shout" [];
    sndfile = mk "formats/mod_sndfile" [];
    ssml = mk "formats/mod_ssml" [];
    tone_stream = mk "formats/mod_tone_stream" [];
    vlc = mk "formats/mod_vlc" [];
    webm = mk "formats/mod_webm" [];
  };

  languages = {
    basic = mk "languages/mod_basic" [];
    java = mk "languages/mod_java" [];
    lua = mk "languages/mod_lua" [ lua ];
    managed = mk "languages/mod_managed" [];
    perl = mk "languages/mod_perl" [];
    python = mk "languages/mod_python" [];
    v8 = mk "languages/mod_v8" [];
    yaml = mk "languages/mod_yaml" [];
  };

  loggers = {
    console = mk "loggers/mod_console" [];
    graylog2 = mk "loggers/mod_graylog2" [];
    logfile = mk "loggers/mod_logfile" [];
    syslog = mk "loggers/mod_syslog" [];
    raven = mk "loggers/mod_raven" [];
  };

  say = {
    de = mk "say/mod_say_de" [];
    en = mk "say/mod_say_en" [];
    es = mk "say/mod_say_es" [];
    es_ar = mk "say/mod_say_es_ar" [];
    fa = mk "say/mod_say_fa" [];
    fr = mk "say/mod_say_fr" [];
    he = mk "say/mod_say_he" [];
    hr = mk "say/mod_say_hr" [];
    hu = mk "say/mod_say_hu" [];
    it = mk "say/mod_say_it" [];
    ja = mk "say/mod_say_ja" [];
    nl = mk "say/mod_say_nl" [];
    pl = mk "say/mod_say_pl" [];
    pt = mk "say/mod_say_pt" [];
    ru = mk "say/mod_say_ru" [];
    sv = mk "say/mod_say_sv" [];
    th = mk "say/mod_say_th" [];
    zh = mk "say/mod_say_zh" [];
  };

  timers = {
    posix_timer = mk "timers/mod_posix_timer" [];
    timerfd = mk "timers/mod_timerfd" [];
  };

  xml_int = {
    cdr = mk "xml_int/mod_xml_cdr" [];
    curl = mk "xml_int/mod_xml_curl" [ curl ];
    ldap = mk "xml_int/mod_xml_ldap" [];
    radius = mk "xml_int/mod_xml_radius" [];
    rpc = mk "xml_int/mod_xml_rpc" [];
    scgi = mk "xml_int/mod_xml_scgi" [];

    # experimental
    odbc = mk "../../contrib/mod/xml_int/mod_xml_odbc" [];
  };

  freetdm = mk "../../libs/freetdm/mod_freetdm" [];
}
