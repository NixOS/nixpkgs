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
}:
stdenv.mkDerivation rec {
  version = "5.5.1";
  name = "collectd-${version}";

  src = fetchurl {
    url = "http://collectd.org/files/${name}.tar.bz2";
    sha256 = "0gxwq3jl20wgvb7qawivshpkm4i3kvghpnfcn5yrlhphw4kdbigr";
  };

  buildInputs = [
    pkgconfig curl iptables libpcap libtool python
  ] ++ stdenv.lib.optionals minimal [ libatasmart libcredis libdbi libgcrypt libmemcached
    cyrus_sasl libmodbus libnotify gdk_pixbuf liboping libsigrok libvirt
    lm_sensors libxml2 lvm2 libmysql postgresql protobufc rabbitmq-c rrdtool
    varnish yajl jdk udev
  ];

  # for some reason libsigrok isn't auto-detected
  configureFlags =
    stdenv.lib.optional (libsigrok != null) "--with-libsigrok" ++
    stdenv.lib.optional (python != null) "--with-python=${python}/bin/python";

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  meta = with stdenv.lib; {
    description = "Daemon which collects system performance statistics periodically";
    homepage = http://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
