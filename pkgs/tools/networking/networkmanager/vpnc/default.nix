{ stdenv
, lib
, fetchurl
, substituteAll
, vpnc
, intltool
, pkg-config
, networkmanager
, libsecret
, gtk3
, gtk4
, withGnome ? true
, gnome
, glib
, kmod
, file
, libnma
, libnma-gtk4
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-vpnc";
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager-vpnc/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1l4xqlPI/cP95++EpNqpeaYFwj/THO/2R79+qqma+8w=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit vpnc kmod;
    })
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
    file
  ];

  buildInputs = [
    vpnc
    networkmanager
    glib
  ] ++ lib.optionals withGnome [
    gtk3
    gtk4
    libsecret
    libnma
    libnma-gtk4
  ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--with-gtk4=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-vpnc";
      versionPolicy = "odd-unstable";
    };
    networkManagerPlugin = "VPN/nm-vpnc-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's VPNC plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
