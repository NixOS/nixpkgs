{ stdenv, fetchurl, openfortivpn, automake, autoconf, libtool, intltool, pkgconfig,
networkmanager, ppp, lib, libsecret, withGnome ? true, gnome3, procps, kmod }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-fortisslvpn";
  major   = "1.2";
  version = "${major}.4";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${major}/${pname}-${version}.tar.xz";
    sha256 = "0wsbj5lvf9l1w8k5nmaqnzmldilh482bn4z4k8a3wnm62xfxgscr";
  };

  buildInputs = [ openfortivpn networkmanager ppp libtool libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome-keyring gnome3.gconf gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ automake autoconf intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome" else "--without-gnome"}"
    "--disable-static"
    "--localstatedir=/tmp"
  ];

  preConfigure = ''
     substituteInPlace "src/nm-fortisslvpn-service.c" \
       --replace "/bin/openfortivpn" "${openfortivpn}/bin/openfortivpn"
  '';

  meta = {
    description = "NetworkManager's FortiSSL plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

