{ stdenv, fetchurl, minimal ? false
# optional:
, pkgconfig ? null  # most of the extra deps need pkgconfig to be found
, curl ? null
, iptables ? null
, jdk ? null
, libatasmart ? null
, libcredis ? null
, libdbi ? null
, libgcrypt ? null
, libmemcached ? null, cyrus_sasl ? null
, libmicrohttpd ? null
, libmodbus ? null
, libnotify ? null, gdk_pixbuf ? null
, liboping ? null
, libpcap ? null
, libsigrok ? null
, libvirt ? null
, libxml2 ? null
, libtool ? null
, lm_sensors ? null
, lvm2 ? null
, libmysql ? null
, postgresql ? null
, protobufc ? null
, python ? null
, rabbitmq-c ? null
, riemann ? null
, rrdtool ? null
, udev ? null
, varnish ? null
, yajl ? null
, net_snmp ? null
, hiredis ? null
, libmnl ? null
}:
stdenv.mkDerivation rec {
  version = "5.7.2";
  name = "collectd-${version}";

  src = fetchurl {
    url = "http://collectd.org/files/${name}.tar.bz2";
    sha256 = "14p5cc3ys3qfg71xzxfvmxdmz5l4brpbhlmw1fwdda392lia084x";
  };

  buildInputs = [
    pkgconfig curl iptables libpcap libtool python libmicrohttpd protobufc
  ] ++ stdenv.lib.optionals (!minimal) [
    libatasmart libcredis libdbi libgcrypt libmemcached cyrus_sasl libmodbus
    libnotify gdk_pixbuf liboping libsigrok libvirt lm_sensors libxml2 lvm2
    libmysql postgresql rabbitmq-c rrdtool varnish yajl jdk python udev
    net_snmp hiredis libmnl
  ];

  # for some reason libsigrok isn't auto-detected
  configureFlags =
    stdenv.lib.optional (libsigrok != null) "--with-libsigrok" ++
    stdenv.lib.optional (python != null) "--with-python=${python}/bin/python";

  meta = with stdenv.lib; {
    description = "Daemon which collects system performance statistics periodically";
    homepage = https://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
