{ stdenv, fetchurl, openvpn, intltool, pkgconfig, networkmanager
, withGnome ? true, gtk2, libgnome_keyring, procps, module_init_tools }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-openvpn";
  version = "0.9.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "18w7mlgnm7y5kg3s2jfm8biymh33ggw97bz27m5mg69kg42qgf4g";
  };

  buildInputs = [ openvpn networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk2 libgnome_keyring ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=2" else "--without-gnome"}"
    "--disable-static"
  ];

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${procps}/sbin/sysctl"
     substituteInPlace "src/nm-openvpn-service.c" \
       --replace "/sbin/openvpn" "${openvpn}/sbin/openvpn" \
       --replace "/sbin/modprobe" "${module_init_tools}/sbin/modprobe"
     substituteInPlace "properties/auth-helpers.c" \
       --replace "/sbin/openvpn" "${openvpn}/sbin/openvpn"
  '';

  postConfigure = ''
     substituteInPlace "./auth-dialog/Makefile" \
       --replace "-Wstrict-prototypes" "" \
       --replace "-Werror" ""
     substituteInPlace "properties/Makefile" \
       --replace "-Wstrict-prototypes" "" \
       --replace "-Werror" ""
  '';

  meta = {
    description = "TODO";
    inherit (networkmanager.meta) maintainers platforms;
  };
}
