{ stdenv, fetchurl
# optional:
, pkgconfig ? null  # most of the extra deps need pkgconfig to be found
, curl ? null
, iptables ? null
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
, lm_sensors ? null
, lvm2 ? null
, mysql ? null
, postgresql ? null
, protobufc ? null
, rabbitmq-c ? null
, rrdtool ? null
, varnish ? null
, yajl ? null
}:

stdenv.mkDerivation rec {
  name = "collectd-5.4.1";

  src = fetchurl {
    url = "http://collectd.org/files/${name}.tar.bz2";
    sha256 = "1q365zx6d1wyhv7n97bagfxqnqbhj2j14zz552nhmjviy8lj2ibm";
  };

  NIX_LDFLAGS = "-lgcc_s"; # for pthread_cancel

  buildInputs = [
    pkgconfig curl iptables libcredis libdbi libgcrypt libmemcached cyrus_sasl
    libmodbus libnotify gdk_pixbuf liboping libpcap libsigrok libvirt
    lm_sensors libxml2 lvm2 mysql postgresql protobufc rabbitmq-c rrdtool
    varnish yajl
  ];

  # for some reason libsigrok isn't auto-detected
  configureFlags = stdenv.lib.optional (libsigrok != null) "--with-libsigrok";

  meta = with stdenv.lib; {
    description = "Daemon which collects system performance statistics periodically";
    homepage = http://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
