{ stdenv, fetchurl, openvpn, intltool, pkgconfig, networkmanager
, withGnome ? true, gnome3, procps, module_init_tools }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-openvpn";
  version = "0.9.8.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "11v63s1f3bsa7pmkvr7x65rsigh48wfqzsnixrwc3wqslsv5535g";
  };

  buildInputs = [ openvpn networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome"}"
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
    description = "NetworkManager's OpenVPN plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}
