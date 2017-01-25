{ stdenv, fetchurl, intltool, pkgconfig, networkmanager, procps
, gnome3, libgnome_keyring, libsecret }:

stdenv.mkDerivation rec {
  name    = "${pname}-${version}";
  pname   = "NetworkManager-strongswan";
  version = "1.4.0";

  src = fetchurl {
    url    = "https://download.strongswan.org/NetworkManager/${name}.tar.bz2";
    sha256 = "0qfnylg949lkyw1nmyggz2ipgmy154ic5q5ljjcwcgi14r90ys02";
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

