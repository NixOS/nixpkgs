{ stdenv, fetchurl, vpnc, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, procps, kmod }:

stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-vpnc";
  version = networkmanager.version;

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${networkmanager.major}/${pname}-${version}.tar.xz";
    sha256 = "e900f6500026f8c3ee4feb92e1d0a0c0abbee9ba507dad915b47a8ab7df9e1f3";
  };

  buildInputs = [ vpnc networkmanager libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome_keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "${if withGnome then "--with-gnome --with-gtkver=3" else "--without-gnome"}"
    "--disable-static"
  ];

  preConfigure = ''
     substituteInPlace "configure" \
       --replace "/sbin/sysctl" "${procps}/bin/sysctl"
     substituteInPlace "src/nm-vpnc-service.c" \
       --replace "/sbin/vpnc" "${vpnc}/bin/vpnc" \
       --replace "/sbin/modprobe" "${kmod}/bin/modprobe"
  '';

  meta = {
    description = "NetworkManager's VPNC plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}

