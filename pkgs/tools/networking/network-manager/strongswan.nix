{ stdenv, fetchurl, intltool, pkgconfig, networkmanager, strongswanNM
, gnome3, libsecret }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "NetworkManager-strongswan";
  version = "1.4.4";

  src = fetchurl {
    url = "https://download.strongswan.org/NetworkManager/${name}.tar.bz2";
    sha256 = "1xhj5cipwbihf0cna8lpicpz7cd8fgkagpmg0xvj6pshymm5jbcd";
  };

  buildInputs = [ networkmanager strongswanNM libsecret ]
    ++ (with gnome3; [ gtk networkmanagerapplet ]);

  nativeBuildInputs = [ intltool pkgconfig ];

  # Fixes deprecation errors with networkmanager 1.10.2
  NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  configureFlags = [
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
