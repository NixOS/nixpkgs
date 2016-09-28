{ stdenv, fetchurl, openvpn, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, procps, kmod }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-openvpn";
  version = networkmanager.version;

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${networkmanager.major}/${pname}-${version}.tar.xz";
    sha256 = "47a6d219a781eff8491c7876b7fb95b12dcfb8f8a05f916f95afc65c7babddef";
  };

  buildInputs = [ openvpn networkmanager libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome"}"
    "--disable-static"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
  ];

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${procps}/sbin/sysctl"
     substituteInPlace "src/nm-openvpn-service.c" \
       --replace "/sbin/openvpn" "${openvpn}/bin/openvpn" \
       --replace "/sbin/modprobe" "${kmod}/bin/modprobe"
     substituteInPlace "properties/auth-helpers.c" \
       --replace "/sbin/openvpn" "${openvpn}/bin/openvpn"
  '';

  meta = {
    description = "NetworkManager's OpenVPN plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}
