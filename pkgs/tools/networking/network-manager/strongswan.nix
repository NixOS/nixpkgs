{ stdenv, fetchurl, intltool, pkgconfig, networkmanager, strongswanNM, sysctl
, gnome3, libgnome-keyring, libsecret }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "NetworkManager-strongswan";
  version = "1.4.3";

  src = fetchurl {
    url    = "https://download.strongswan.org/NetworkManager/${name}.tar.bz2";
    sha256 = "0jzl52wmh2q2djb1s546kxliy7s6akhi5bx6rp2ppjfk3wbi2a2l";
  };

  postPatch = ''
    sed -i "s,nm_plugindir=.*,nm_plugindir=$out/lib/NetworkManager," "configure"
    sed -i "s,nm_libexecdir=.*,nm_libexecdir=$out/libexec," "configure"
  '';

  buildInputs = [ networkmanager strongswanNM libsecret ]
      ++ (with gnome3; [ gtk libgnome-keyring networkmanagerapplet ]);

  nativeBuildInputs = [ intltool pkgconfig ];

  # Fixes deprecation errors with networkmanager 1.10.2
  NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${sysctl}/bin/sysctl"
  '';

  configureFlags = [ "--with-charon=${strongswanNM}/libexec/ipsec/charon-nm" ];

  meta = {
    description = "NetworkManager's strongswan plugin";
    inherit (networkmanager.meta) platforms;
  };
}
