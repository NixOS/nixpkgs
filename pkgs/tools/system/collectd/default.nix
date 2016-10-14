{ stdenv, fetchurl
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
  version = "5.6.0";
  name = "collectd-${version}";

  src = fetchurl {
    url = "http://collectd.org/files/${name}.tar.bz2";
    sha256 = "08w6fjzczi2psk7va0xkjh9pigpar6sbjx2a6ayq4dmc3zcvpzzh";
  };

  buildInputs = [
    pkgconfig curl iptables libatasmart libcredis libdbi libgcrypt libmemcached
    cyrus_sasl libmodbus libnotify gdk_pixbuf liboping libpcap libsigrok libvirt
    lm_sensors libxml2 lvm2 libmysql postgresql protobufc rabbitmq-c rrdtool
    varnish yajl jdk libtool python udev net_snmp hiredis libmnl
  ];

  patches = [
    # Replace deprecated readdir_r() with readdir() to avoid a fatal warning.
    ./readdir-fix.patch
  ];

  # for some reason libsigrok isn't auto-detected
  configureFlags =
    stdenv.lib.optional (libsigrok != null) "--with-libsigrok" ++
    stdenv.lib.optional (python != null) "--with-python=${python}/bin/python";

  meta = with stdenv.lib; {
    description = "Daemon which collects system performance statistics periodically";
    homepage = http://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
