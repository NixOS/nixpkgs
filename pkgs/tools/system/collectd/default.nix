{ stdenv, fetchurl, fetchpatch, darwin
, autoreconfHook
, pkgconfig
, curl
, iptables
, jdk
, libapparmor
, libatasmart
, libcap_ng
, libcredis
, libdbi
, libgcrypt
, libmemcached, cyrus_sasl
, libmicrohttpd
, libmodbus
, libnotify, gdk_pixbuf
, liboping
, libpcap
, libsigrok
, libvirt
, libxml2
, libtool
, lm_sensors
, lvm2
, mysql
, numactl
, postgresql
, protobufc
, python
, rabbitmq-c
, riemann_c_client
, rrdtool
, udev
, varnish
, yajl
, net_snmp
, hiredis
, libmnl
, mosquitto
, rdkafka
, mongoc
}:
stdenv.mkDerivation rec {
  version = "5.8.1";
  name = "collectd-${version}";

  src = fetchurl {
    url = "https://collectd.org/files/${name}.tar.bz2";
    sha256 = "1njk8hh56gb755xafsh7ahmqr9k2d4lam4ddj7s7fqz0gjigv5p7";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/rpv-tomsk/collectd/commit/d5a3c020d33cc33ee8049f54c7b4dffcd123bf83.patch";
      sha256 = "1n65zw4d2k2bxapayaaw51ym7hy72a0cwi2abd8jgxcw3d0m5g15";
    })
  ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
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
    # those might be no longer required when https://github.com/NixOS/nixpkgs/pull/51767
    # is merged
    libapparmor numactl libcap_ng
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.ApplicationServices
  ];

  configureFlags = [
    "--localstatedir=/var"
    "--disable-werror"
  ];

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
