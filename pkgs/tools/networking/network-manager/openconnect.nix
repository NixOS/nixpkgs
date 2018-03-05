{ stdenv, fetchurl, openconnect, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, procps, kmod }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-openconnect";
  major   = "1.2";
  version = "${major}.4";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${major}/${pname}-${version}.tar.xz";
    sha256 = "15j98wwspv6mcmy91w30as5qc1bzsnhlk060xhjy4qrvd37y0xx1";
  };

  buildInputs = [ openconnect networkmanager libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome-keyring gnome3.gconf ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome"}"
    "--disable-static"
  ];

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${procps}/bin/sysctl"
     substituteInPlace "src/nm-openconnect-service.c" \
       --replace "/usr/sbin/openconnect" "${openconnect}/bin/openconnect" \
       --replace "/sbin/modprobe" "${kmod}/bin/modprobe"
  '';

  meta = {
    description = "NetworkManager's OpenConnect plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

