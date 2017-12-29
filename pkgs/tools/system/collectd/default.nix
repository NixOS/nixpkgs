{ stdenv, fetchurl, darwin
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

  # on 5.7.2: lvm2app.h:21:2: error: #warning "liblvm2app is deprecated, use D-Bus API instead." [-Werror=cpp]
  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    curl libdbi libgcrypt libmemcached
    cyrus_sasl libnotify gdk_pixbuf liboping libpcap libvirt
    libxml2 libmysql postgresql protobufc rrdtool
    varnish yajl jdk libtool python hiredis libmicrohttpd
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    iptables libatasmart libcredis libmodbus libsigrok
    lm_sensors lvm2 rabbitmq-c udev net_snmp libmnl
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.ApplicationServices
  ];

  # for some reason libsigrok isn't auto-detected
  configureFlags =
    [ "--localstatedir=/var" ] ++
    stdenv.lib.optional (stdenv.isLinux && libsigrok != null) "--with-libsigrok" ++
    stdenv.lib.optional (python != null) "--with-python=${python}/bin/python";

  # do not create directories in /var during installPhase
  postConfigure = ''
     substituteInPlace Makefile --replace '$(mkinstalldirs) $(DESTDIR)$(localstatedir)/' '#'
  '';

  postInstall = ''
    if [ -d $out/share/collectd/java ]; then
      mv $out/share/collectd/java $out/share/
    fi
  '';

  meta = with stdenv.lib; {
    description = "Daemon which collects system performance statistics periodically";
    homepage = https://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
