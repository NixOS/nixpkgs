{ stdenv, fetchurl, fetchpatch, darwin
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
, mysql ? null
, postgresql ? null
, protobufc ? null
, python ? null
, rabbitmq-c ? null
, riemann_c_client ? null
, rrdtool ? null
, udev ? null
, varnish ? null
, yajl ? null
, net_snmp ? null
, hiredis ? null
, libmnl ? null
, mosquitto ? null
, rdkafka ? null
, mongoc ? null
}:
stdenv.mkDerivation rec {
  version = "5.8.1";
  name = "collectd-${version}";

  src = fetchurl {
    url = "https://collectd.org/files/${name}.tar.bz2";
    sha256 = "1njk8hh56gb755xafsh7ahmqr9k2d4lam4ddj7s7fqz0gjigv5p7";
  };

  # on 5.8.0: lvm2app.h:21:2: error: #warning "liblvm2app is deprecated, use D-Bus API instead." [-Werror=cpp]
  NIX_CFLAGS_COMPILE = [ "-Wno-error=cpp" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    curl libdbi libgcrypt libmemcached
    cyrus_sasl libnotify gdk_pixbuf liboping libpcap libvirt
    libxml2 postgresql protobufc rrdtool
    varnish yajl jdk libtool python hiredis libmicrohttpd
    riemann_c_client mosquitto rdkafka mongoc
  ] ++ stdenv.lib.optionals (mysql != null) [ mysql.connector-c
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    iptables libatasmart libcredis libmodbus libsigrok
    lm_sensors lvm2 rabbitmq-c udev net_snmp libmnl
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.ApplicationServices
  ];

  configureFlags = [ "--localstatedir=/var" ];

  # do not create directories in /var during installPhase
  postConfigure = ''
     substituteInPlace Makefile --replace '$(mkinstalldirs) $(DESTDIR)$(localstatedir)/' '#'
  '';

  postInstall = ''
    if [ -d $out/share/collectd/java ]; then
      mv $out/share/collectd/java $out/share/
    fi
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Daemon which collects system performance statistics periodically";
    homepage = https://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
