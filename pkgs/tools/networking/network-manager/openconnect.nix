{ stdenv, fetchurl, openconnect, intltool, pkgconfig, networkmanager
, withGnome ? true, gnome3, procps, module_init_tools }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-openconnect";
  version = "0.9.8.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "1dl7wcmibrzf9qnpchgk9fxfhw0j2hzzzqmylkm2c41iv81xrd4r";
  };

  buildInputs = [ openconnect networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring gnome3.gconf ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome"}"
    "--disable-static"
  ];

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${procps}/sbin/sysctl"
     substituteInPlace "src/nm-openconnect-service.c" \
       --replace "/usr/sbin/openconnect" "${openconnect}/sbin/openconnect" \
       --replace "/sbin/modprobe" "${module_init_tools}/sbin/modprobe"
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
    description = "NetworkManager's OpenConnect plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

