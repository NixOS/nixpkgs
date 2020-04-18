{ stdenv
, curl
, darwin
, hiredis
, iptables
, jdk
, libatasmart
, libdbi
, libgcrypt
, libmemcached, cyrus_sasl
, libmodbus
, libmicrohttpd
, libmnl
, libmysqlclient
, libnotify, gdk-pixbuf
, liboping
, libpcap
, libsigrok
, libvirt
, libxml2
, libapparmor, libcap_ng, numactl
, lvm2
, lua
, lm_sensors
, mongoc
, mosquitto
, net-snmp
, perl
, postgresql
, protobufc
, python
, rabbitmq-c
, rdkafka
, riemann_c_client
, rrdtool
, udev
, varnish
, yajl
# Defaults to `null` for all supported plugins,
# list of plugin names for a custom build
, enabledPlugins ? null
, ...
}:

let
  # All plugins and their dependencies.
  # Please help complete this!
  plugins = {
    aggregation = {};
    amqp = {
      buildInputs = [ yajl ] ++
        stdenv.lib.optionals stdenv.isLinux [ rabbitmq-c ];
    };
    apache = {
      buildInputs = [ curl ];
    };
    apcups = {};
    apple_sensors = {};
    aquaero = {};
    ascent = {
      buildInputs = [ curl libxml2 ];
    };
    barometer = {};
    battery = {
      buildInputs = stdenv.lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.IOKit
      ];
    };
    bind = {
      buildInputs = [ curl libxml2 ];
    };
    ceph = {
      buildInputs = [ yajl ];
    };
    cgroups = {};
    chrony = {};
    conntrack = {};
    contextswitch = {};
    cpu = {};
    cpufreq = {};
    cpusleep = {};
    csv = {};
    curl = {
      buildInputs = [ curl ];
    };
    curl_json = {
      buildInputs = [ curl yajl ];
    };
    curl_xml = {
      buildInputs = [ curl libxml2 ];
    };
    dbi = {
      buildInputs = [ libdbi ];
    };
    df = {};
    disk = {
      buildInputs = stdenv.lib.optionals stdenv.isLinux [
        udev
      ] ++ stdenv.lib.optionals stdenv.isDarwin [
        darwin.apple_sdk.frameworks.IOKit
      ];
    };
    dns = {
      buildInputs = [ libpcap ];
    };
    dpdkevents = {};
    dpdkstat = {};
    drbd = {};
    email = {};
    entropy = {};
    ethstat = {};
    exec = {};
    fhcount = {};
    filecount = {};
    fscache = {};
    gmond = {};
    gps = {};
    grpc = {};
    hddtemp = {};
    hugepages = {};
    intel_pmu = {};
    intel_rdt = {};
    interface = {};
    ipc = {};
    ipmi = {};
    iptables = {
      buildInputs = [
        libpcap
      ] ++ stdenv.lib.optionals stdenv.isLinux [
        iptables libmnl
      ];
    };
    ipvs = {};
    irq = {};
    java = {
      buildInputs = [ jdk libgcrypt libxml2 ];
    };
    load = {};
    logfile = {};
    log_logstash = {
      buildInputs = [ yajl ];
    };
    lpar = {};
    lua = {
      buildInputs = [ lua ];
    };
    lvm = {};
    madwifi = {};
    match_empty_counter = {};
    match_hashed = {};
    match_regex = {};
    match_timediff = {};
    match_value = {};
    mbmon = {};
    mcelog = {};
    md = {};
    memcachec = {
      buildInputs = [ libmemcached cyrus_sasl ];
    };
    memcached = {};
    memory = {};
    mic = {};
    modbus = {
      buildInputs = stdenv.lib.optionals stdenv.isLinux [ libmodbus ];
    };
    mqtt = {
      buildInputs = [ mosquitto ];
    };
    multimeter = {};
    mysql = {
      buildInputs = stdenv.lib.optionals (libmysqlclient != null) [
        libmysqlclient
      ];
    };
    netapp = {};
    netlink = {
      buildInputs = [
        libpcap
      ] ++ stdenv.lib.optionals stdenv.isLinux [
        libmnl
      ];
    };
    network = {
      buildInputs = [ libgcrypt ];
    };
    nfs = {};
    nginx = {
      buildInputs = [ curl ];
    };
    notify_desktop = {
      buildInputs = [ libnotify gdk-pixbuf ];
    };
    notify_email = {};
    notify_nagios = {};
    ntpd = {};
    numa = {};
    nut = {};
    olsrd = {};
    onewire = {};
    openldap = {};
    openvpn = {};
    oracle = {};
    ovs_events = {
      buildInputs = [ yajl ];
    };
    ovs_stats = {
      buildInputs = [ yajl ];
    };
    perl = {
      buildInputs = [ perl ];
    };
    pf = {};
    pinba = {
      buildInputs = [ protobufc ];
    };
    ping = {
      buildInputs = [ liboping ];
    };
    postgresql = {
      buildInputs = [ postgresql ];
    };
    powerdns = {};
    processes = {};
    protocols = {};
    python = {
      buildInputs = [ python ];
    };
    redis = {
      buildInputs = [ hiredis ];
    };
    routeros = {};
    rrdcached = {
      buildInputs = [ rrdtool libxml2 ];
    };
    rrdtool = {
      buildInputs = [ rrdtool libxml2 ];
    };
    sensors = {
      buildInputs = stdenv.lib.optionals stdenv.isLinux [ lm_sensors ];
    };
    serial = {};
    sigrok = {
      buildInputs = stdenv.lib.optionals stdenv.isLinux [ libsigrok udev ];
    };
    smart = {
      buildInputs = stdenv.lib.optionals stdenv.isLinux [ libatasmart udev ];
    };
    snmp = {
      buildInputs = stdenv.lib.optionals stdenv.isLinux [ net-snmp ];
    };
    snmp_agent = {
      buildInputs = stdenv.lib.optionals stdenv.isLinux [ net-snmp ];
    };
    statsd = {};
    swap = {};
    synproxy = {};
    syslog = {};
    table = {};
    tail_csv = {};
    tail = {};
    tape = {};
    target_notification = {};
    target_replace = {};
    target_scale = {};
    target_set = {};
    target_v5upgrade = {};
    tcpconns = {};
    teamspeak2 = {};
    ted = {};
    thermal = {};
    threshold = {};
    tokyotyrant = {};
    turbostat = {};
    unixsock = {};
    uptime = {};
    users = {};
    uuid = {};
    varnish = {
      buildInputs = [ curl varnish ];
    };
    virt = {
      buildInputs = [ libvirt libxml2 yajl ] ++
        stdenv.lib.optionals stdenv.isLinux [ lvm2 udev
          # those might be no longer required when https://github.com/NixOS/nixpkgs/pull/51767
          # is merged
          libapparmor numactl libcap_ng
        ];
    };
    vmem = {};
    vserver = {};
    wireless = {};
    write_graphite = {};
    write_http = {
      buildInputs = [ curl yajl ];
    };
    write_kafka = {
      buildInputs = [ yajl rdkafka ];
    };
    write_log = {
      buildInputs = [ yajl ];
    };
    write_mongodb = {
      buildInputs = [ mongoc ];
    };
    write_prometheus = {
      buildInputs = [ protobufc libmicrohttpd ];
    };
    write_redis = {
      buildInputs = [ hiredis ];
    };
    write_riemann = {
      buildInputs = [ protobufc riemann_c_client ];
    };
    write_sensu = {};
    write_tsdb = {};
    xencpu = {};
    xmms = {};
    zfs_arc = {};
    zone = {};
    zookeeper = {};
  };

  configureFlags =
    if enabledPlugins == null
    then []
    else (map (plugin: "--enable-${plugin}") enabledPlugins) ++
    (map (plugin: "--disable-${plugin}")
      (builtins.filter (plugin: ! builtins.elem plugin enabledPlugins)
        (builtins.attrNames plugins))
    );

  pluginBuildInputs = plugin:
        if ! builtins.hasAttr plugin plugins
        then throw "Unknown collectd plugin: ${plugin}"
        else
          let
            pluginAttrs = builtins.getAttr plugin plugins;
          in
          if pluginAttrs ? "buildInputs"
          then pluginAttrs.buildInputs
          else [];

  buildInputs =
    if enabledPlugins == null
    then builtins.concatMap pluginBuildInputs
      (builtins.attrNames plugins)
    else builtins.concatMap pluginBuildInputs enabledPlugins;
in {
  inherit configureFlags buildInputs;
}
