{ stdenv
, lib
, fetchurl
, substituteAll
, openvpn
, intltool
, libxml2
, pkg-config
, file
, networkmanager
, libsecret
, glib
, gtk3
, gtk4
, withGnome ? true
, gnome
, kmod
, libnma
, libnma-gtk4
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-openvpn";
  version = "1.8.18";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager-openvpn/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "U9+wrPZEeK3HKAdPFi9i5gv/YqYFvYl+uIsmfnBXkno=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openvpn;
    })
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
    file
    libxml2
  ];

  buildInputs = [
    openvpn
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
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openvpn";
      versionPolicy = "odd-unstable";
    };
    networkManagerPlugin = "VPN/nm-openvpn-service.name";
  };

  meta = with lib; {
    description = "NetworkManager's OpenVPN plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
