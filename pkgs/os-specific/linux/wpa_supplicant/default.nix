{ stdenv, fetchurl, lib, openssl, dbus_libs, pkgconfig, libnl
, readlineSupport ? true, readline
}:

assert readlineSupport -> readline != null;

stdenv.mkDerivation rec {
  version = "2.1";

  name = "wpa_supplicant-${version}";

  src = fetchurl {
    url = "http://hostap.epitest.fi/releases/${name}.tar.gz";
    sha256 = "0xxjw7lslvql1ykfbwmbhdrnjsjljf59fbwf837418s97dz2wqwi";
  };

  extraConfig =
    ''
      CONFIG_DEBUG_SYSLOG=y
      CONFIG_CTRL_IFACE_DBUS=y
      CONFIG_CTRL_IFACE_DBUS_NEW=y
      CONFIG_CTRL_IFACE_DBUS_INTRO=y
      CONFIG_DRIVER_NL80211=y
      CONFIG_LIBNL32=y
      ${stdenv.lib.optionalString readlineSupport "CONFIG_READLINE=y"}
    '';

  preBuild = ''
    cd wpa_supplicant
    cp -v defconfig .config
    echo "$extraConfig" >> .config
    cat .config
    substituteInPlace Makefile --replace /usr/local $out
  '';

  buildInputs = [ openssl dbus_libs libnl ]
    ++ lib.optional readlineSupport readline;

  nativeBuildInputs = [ pkgconfig ];

  patches = [ ./libnl.patch
    # remove this patch after wpa_supplicant 2.1
    (fetchurl {
      url ="http://projects.archlinux.org/svntogit/packages.git/plain/trunk/0001-Revert-OpenSSL-Do-not-accept-SSL-Client-certificate-.patch?h=packages/wpa_supplicant";
      sha256 = "0x1wl2nbl7v9kv80qvysfjhhg5a7lmgygv1y723flps6y8ngm19w";
    })
  ];

  postInstall = ''
    mkdir -p $out/share/man/man5 $out/share/man/man8
    cp -v "doc/docbook/"*.5 $out/share/man/man5/
    cp -v "doc/docbook/"*.8 $out/share/man/man8/
    mkdir -p $out/etc/dbus-1/system.d $out/share/dbus-1/system-services $out/etc/systemd/system
    cp -v "dbus/"*service $out/share/dbus-1/system-services
    sed -e "s@/sbin/wpa_supplicant@$out&@" -i "$out/share/dbus-1/system-services/"*
    cp -v dbus/dbus-wpa_supplicant.conf $out/etc/dbus-1/system.d
    cp -v "systemd/"*.service $out/etc/systemd/system
  '';

  meta = {
    homepage = http://hostap.epitest.fi/wpa_supplicant/;
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    maintainers = with stdenv.lib.maintainers; [marcweber urkud];
    platforms = stdenv.lib.platforms.linux;
  };
}
