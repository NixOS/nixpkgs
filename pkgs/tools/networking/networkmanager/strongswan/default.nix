{ lib, stdenv, fetchurl, intltool, pkg-config, networkmanager, strongswanNM
, gtk3, gnome, libsecret, libnma }:

stdenv.mkDerivation rec {
  pname = "NetworkManager-strongswan";
  version = "1.5.2";

  src = fetchurl {
    url = "https://download.strongswan.org/NetworkManager/${pname}-${version}.tar.bz2";
    sha256 = "0sc1yzlxjfvl58hjjw99bchqc4061i3apw254z61v22k4sajnif8";
  };

  buildInputs = [ networkmanager strongswanNM libsecret gtk3 libnma ];

  nativeBuildInputs = [ intltool pkg-config ];

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  configureFlags = [
    "--without-libnm-glib"
    "--with-charon=${strongswanNM}/libexec/ipsec/charon-nm"
    "--with-nm-libexecdir=$(out)/libexec"
    "--with-nm-plugindir=$(out)/lib/NetworkManager"
  ];

  passthru = {
    networkManagerPlugin = "VPN/nm-strongswan-service.name";
  };

  PKG_CONFIG_LIBNM_VPNSERVICEDIR = "$(out)/lib/NetworkManager/VPN";

  meta = with lib; {
    description = "NetworkManager's strongswan plugin";
    inherit (networkmanager.meta) platforms;
    license = licenses.gpl2Plus;
  };
}
