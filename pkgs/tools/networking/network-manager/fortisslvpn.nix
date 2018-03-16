{ stdenv, fetchurl, openfortivpn, automake, autoconf, libtool, intltool, pkgconfig,
networkmanager, ppp, lib, libsecret, withGnome ? true, gnome3, procps, kmod }:

let
  pname   = "NetworkManager-fortisslvpn";
  version = "1.2.4";
in stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
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

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-fortisslvpn";
    };
  };

  meta = {
    description = "NetworkManager's FortiSSL plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

