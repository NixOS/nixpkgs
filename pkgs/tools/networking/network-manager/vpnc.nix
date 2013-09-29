{ stdenv, fetchurl, vpnc, intltool, pkgconfig, networkmanager
, withGnome ? true, gtk2, libgnome_keyring, procps, module_init_tools }:

stdenv.mkDerivation rec {
  name = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname = "NetworkManager-vpnc";
  # TODO: version doesn't match due to bad release
  #version = networkmanager.version;
  version = "0.9.8.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/0.9/${pname}-${version}.tar.xz";
    sha256 = "1mmbm3q27b3dbbs4vs976cxif8jdcs92j3ajdbgykrnl2gbnqc20";
  };

  buildInputs = [ vpnc networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk2 libgnome_keyring ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=2" else "--without-gnome"}"
    "--disable-static"
  ];

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${procps}/sbin/sysctl"
     substituteInPlace "src/nm-vpnc-service.c" \
       --replace "/sbin/vpnc" "${vpnc}/sbin/vpnc" \
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
    description = "NetworkManager's VPNC plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

