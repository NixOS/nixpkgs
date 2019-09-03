{ stdenv, fetchurl, intltool, pkgconfig, networkmanager, strongswanNM
, gtk3, gnome3, libsecret }:

stdenv.mkDerivation rec {
  pname = "NetworkManager-strongswan";
  version = "1.4.5";

  src = fetchurl {
    url = "https://download.strongswan.org/NetworkManager/${pname}-${version}.tar.bz2";
    sha256 = "015xcj42pd84apa0j0n9r3fhldp42mj72dqvl2xf4r9gwg5nhfrl";
  };

  buildInputs = [ networkmanager strongswanNM libsecret gtk3 gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  # Fixes deprecation errors with networkmanager 1.10.2
  NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  configureFlags = [
    "--without-libnm-glib"
    "--with-charon=${strongswanNM}/libexec/ipsec/charon-nm"
    "--with-nm-libexecdir=$(out)/libexec"
    "--with-nm-plugindir=$(out)/lib/NetworkManager"
  ];

  PKG_CONFIG_LIBNM_VPNSERVICEDIR = "$(out)/lib/NetworkManager/VPN";

  meta = with stdenv.lib; {
    description = "NetworkManager's strongswan plugin";
    inherit (networkmanager.meta) platforms;
    license = licenses.gpl2Plus;
  };
}
