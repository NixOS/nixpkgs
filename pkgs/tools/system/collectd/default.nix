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
  version = "5.8.0";
  name = "collectd-${version}";

  src = fetchurl {
    url = "http://collectd.org/files/${name}.tar.bz2";
    sha256 = "1j8mxgfq8039js2bscphd6cnriy35hk4jrxfjz5k6mghpdvg8vxh";
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

  # Patch fixes broken build on 18.03
  # Should be included in the next release of this package
  patches = fetchpatch {
    name = "collectd_kafka_fix";
    url = "https://github.com/collectd/collectd/commit/6c2eb3ad28f08f7e774b6eaea5ae01b0857cf884.patch";
    sha256 = "14wsyj5xghij9lz7c61bzdyh45zg8pv5xn490cvbqiaci948zzv6";
  };
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
