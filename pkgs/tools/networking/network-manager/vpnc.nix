{ stdenv, fetchurl, vpnc, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3, procps, kmod, file }:
let
  pname   = "NetworkManager-vpnc";
  version = "1.2.6";
in stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";
  pname   = "NetworkManager-vpnc";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1js5lwcsqws4klgypfxl4ikmakv7v7xgddij1fj6b0y0qicx0kyy";
  };

  buildInputs = [ vpnc networkmanager libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome-keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig file ];

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

