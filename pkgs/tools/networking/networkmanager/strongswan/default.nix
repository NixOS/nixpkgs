{ stdenv
, lib
, fetchurl
, intltool
, pkg-config
, networkmanager
, strongswanNM
, gtk3
, gnome
, libsecret
, libnma
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-strongswan";
  version = "1.5.2";

  src = fetchurl {
    url = "https://download.strongswan.org/NetworkManager/${pname}-${version}.tar.bz2";
    sha256 = "0sc1yzlxjfvl58hjjw99bchqc4061i3apw254z61v22k4sajnif8";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
  ];

  buildInputs = [
    networkmanager
    strongswanNM
    libsecret
    gtk3
    libnma
  ];

  configureFlags = [
    "--without-libnm-glib"
    "--with-charon=${strongswanNM}/libexec/ipsec/charon-nm"
    "--with-nm-libexecdir=${placeholder "out"}/libexec"
    "--with-nm-plugindir=${placeholder "out"}/lib/NetworkManager"
  ];

  PKG_CONFIG_LIBNM_VPNSERVICEDIR = "${placeholder "out"}/lib/NetworkManager/VPN";

  # glib-2.62 deprecations
  NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  passthru = {
    networkManagerPlugin = "VPN/nm-strongswan-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's strongswan plugin";
    inherit (networkmanager.meta) platforms;
    license = licenses.gpl2Plus;
  };
}
