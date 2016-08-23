{ stdenv, fetchurl, openconnect, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, procps, kmod }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-openconnect";
  version = networkmanager.version;

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${networkmanager.major}/${pname}-${version}.tar.xz";
    sha256 = "522979593e21b4e884112816708db9eb66148b3491580dacfad53472b94aafec";
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

