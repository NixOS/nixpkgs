{ stdenv, fetchurl, intltool, pkgconfig, networkmanager, procps
, gnome3, libgnome_keyring, libsecret }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "NetworkManager-strongswan";
  version = "1.4.1";

  src = fetchurl {
    url    = "https://download.strongswan.org/NetworkManager/${name}.tar.bz2";
    sha256 = "0r5j8cr4x01d2cdy970990292n7p9v617cw103kdczw646xwcxs8";
  };

  postPatch = ''
    sed -i "s,nm_plugindir=.*,nm_plugindir=$out/lib/NetworkManager," "configure"
    sed -i "s,nm_libexecdir=.*,nm_libexecdir=$out/libexec," "configure"
  '';

  buildInputs = [ networkmanager libsecret ]
      ++ (with gnome3; [ gtk libgnome_keyring networkmanagerapplet ]);

  nativeBuildInputs = [ intltool pkgconfig ];

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${procps}/bin/sysctl"
  '';

  meta = {
    description = "NetworkManager's strongswan plugin";
    inherit (networkmanager.meta) platforms;
  };
}

