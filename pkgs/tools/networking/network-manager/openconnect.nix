{ stdenv, fetchurl, openconnect, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, procps, module_init_tools }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-openconnect";
  version = networkmanager.version;

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/1.0/${pname}-${version}.tar.xz";
    sha256 = "03k05s3aaxcwrip3g3r13bx80wbg7vh5sssc7mvg27c4cdc0a2hj";
  };

  buildInputs = [ openconnect networkmanager libsecret ]
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

