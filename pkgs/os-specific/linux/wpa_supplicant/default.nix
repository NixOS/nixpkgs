{ stdenv, fetchurl, openssl, dbus_libs, pkgconfig, libnl }:

stdenv.mkDerivation rec {
  version = "1.1";

  name = "wpa_supplicant-${version}";

  src = fetchurl {
    url = "http://hostap.epitest.fi/releases/${name}.tar.gz";
    sha256 = "00lyifj8cz7qyal6dy1dxbpk3g3bywvdarik8gbj9ds7zmfbwkd5";
  };

  preBuild = ''
    cd wpa_supplicant
    cp -v defconfig .config
    echo CONFIG_DEBUG_SYSLOG=y | tee -a .config
    echo CONFIG_CTRL_IFACE_DBUS=y | tee -a .config
    echo CONFIG_CTRL_IFACE_DBUS_NEW=y | tee -a .config
    echo CONFIG_CTRL_IFACE_DBUS_INTRO=y | tee -a .config
    echo CONFIG_DRIVER_NL80211=y | tee -a .config
    echo CONFIG_LIBNL32=y | tee -a .config
    substituteInPlace Makefile --replace /usr/local $out
  '';

  buildInputs = [ openssl dbus_libs libnl ];

  nativeBuildInputs = [ pkgconfig ];

  patches =
    [ (fetchurl {
        url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/hostap_allow-linking-with-libnl-3.2.patch?h=packages/wpa_supplicant";
        name = "hostap_allow-linking-with-libnl-3.2.patch";
        sha256 = "0iwvjq0apc6mv1r03k5pnyjgda3q47yx36c4lqvv8i8q1vn7kbf2";
      })
    ];

  postInstall = ''
    mkdir -p $out/share/man/man5 $out/share/man/man8
    cp -v doc/docbook/*.5 $out/share/man/man5/
    cp -v doc/docbook/*.8 $out/share/man/man8/
    mkdir -p $out/etc/dbus-1/system.d $out/share/dbus-1/system-services $out/etc/systemd/system
    cp -v dbus/*service $out/share/dbus-1/system-services
    sed -e "s@/sbin/wpa_supplicant@$out&@" -i $out/share/dbus-1/system-services/*
    cp -v dbus/dbus-wpa_supplicant.conf $out/etc/dbus-1/system.d
    cp -v systemd/*.service $out/etc/systemd/system
  ''; # */

  meta = {
    homepage = http://hostap.epitest.fi/wpa_supplicant/;
    description = "A tool for connecting to WPA and WPA2-protected wireless networks";
    maintainers = with stdenv.lib.maintainers; [marcweber urkud];
    platforms = stdenv.lib.platforms.linux;
  };
}
