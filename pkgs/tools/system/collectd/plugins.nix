{
  lib,
  stdenv,
  curl,
  hiredis,
  iptables,
  jdk,
  libatasmart,
  libdbi,
  libesmtp,
  libgcrypt,
  libmemcached,
  cyrus_sasl,
  libmodbus,
  libmicrohttpd,
  libmnl,
  libmysqlclient,
  libnotify,
  gdk-pixbuf,
  liboping,
  libpcap,
  libpq,
  libsigrok,
  libvirt,
  libxml2,
  lua,
  lvm2,
  lm_sensors,
  mongoc,
  mosquitto,
  net-snmp,
  openldap,
  openipmi,
  perl,
  protobufc,
  python3,
  rabbitmq-c,
  rdkafka,
  riemann_c_client,
  rrdtool,
  udev,
  varnish,
  xen,
  yajl,
  # Defaults to `null` for all supported plugins (except xen, which is marked as
  # insecure), otherwise a list of plugin names for a custom build
  enabledPlugins ? null,
  ...
}:

let
  # Plugins that have dependencies.
  # Please help to extend these!
  plugins = {
    amqp.buildInputs = [
      yajl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ rabbitmq-c ];
    apache.buildInputs = [ curl ];
    ascent.buildInputs = [
      curl
      libxml2
    ];
    bind.buildInputs = [
      curl
      libxml2
    ];
    ceph.buildInputs = [ yajl ];
    curl.buildInputs = [ curl ];
    curl_json.buildInputs = [
      curl
      yajl
    ];
    curl_xml.buildInputs = [
      curl
      libxml2
    ];
    dbi.buildInputs = [ libdbi ];
    disk.buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      udev
    ];
    dns.buildInputs = [ libpcap ];
    ipmi.buildInputs = [ openipmi ];
    iptables.buildInputs = [
      libpcap
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      iptables
      libmnl
    ];
    java.buildInputs = [
      jdk
      libgcrypt
      libxml2
    ];
    log_logstash.buildInputs = [ yajl ];
    lua.buildInputs = [ lua ];
    memcachec.buildInputs = [
      libmemcached
      cyrus_sasl
    ];
    modbus.buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libmodbus ];
    mqtt.buildInputs = [ mosquitto ];
    mysql.buildInputs = lib.optionals (libmysqlclient != null) [
      libmysqlclient
    ];
    netlink.buildInputs = [
      libpcap
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libmnl
    ];
    network.buildInputs = [ libgcrypt ];
    nginx.buildInputs = [ curl ];
    notify_desktop.buildInputs = [
      libnotify
      gdk-pixbuf
    ];
    notify_email.buildInputs = [ libesmtp ];
    openldap.buildInputs = [ openldap ];
    ovs_events.buildInputs = [ yajl ];
    ovs_stats.buildInputs = [ yajl ];
    perl.buildInputs = [ perl ];
    pinba.buildInputs = [ protobufc ];
    ping.buildInputs = [ liboping ];
    postgresql.buildInputs = [ libpq ];
    python.buildInputs = [ python3 ];
    redis.buildInputs = [ hiredis ];
    rrdcached.buildInputs = [
      rrdtool
      libxml2
    ];
    rrdtool.buildInputs = [
      rrdtool
      libxml2
    ];
    sensors.buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ lm_sensors ];
    sigrok.buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      libsigrok
      udev
    ];
    smart.buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      libatasmart
      udev
    ];
    snmp.buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ net-snmp ];
    snmp_agent.buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ net-snmp ];
    varnish.buildInputs = [
      curl
      varnish
    ];
    virt.buildInputs = [
      libvirt
      libxml2
      yajl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      lvm2
      udev
    ];
    write_http.buildInputs = [
      curl
      yajl
    ];
    write_kafka.buildInputs = [
      yajl
      rdkafka
    ];
    write_log.buildInputs = [ yajl ];
    write_mongodb.buildInputs = [ mongoc ];
    write_prometheus.buildInputs = [
      protobufc
      libmicrohttpd
    ];
    write_redis.buildInputs = [ hiredis ];
    write_riemann.buildInputs = [
      protobufc
      riemann_c_client
    ];
    xencpu.buildInputs = [ xen ];
  };

  configureFlags = lib.optionals (enabledPlugins != null) (
    [ "--disable-all-plugins" ] ++ (map (plugin: "--enable-${plugin}") enabledPlugins)
  );

  pluginBuildInputs =
    plugin:
    lib.optionals (
      plugins ? ${plugin} && plugins.${plugin} ? buildInputs
    ) plugins.${plugin}.buildInputs;

  buildInputs =
    if enabledPlugins == null then
      builtins.concatMap pluginBuildInputs (
        builtins.attrNames (builtins.removeAttrs plugins [ "xencpu" ])
      )
    else
      builtins.concatMap pluginBuildInputs enabledPlugins;
in
{
  inherit configureFlags buildInputs;
}
