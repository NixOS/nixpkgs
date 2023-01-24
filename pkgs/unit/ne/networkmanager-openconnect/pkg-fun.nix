{ stdenv
, lib
, fetchurl
, substituteAll
, glib
, libxml2
, openconnect
, intltool
, pkg-config
, autoreconfHook
, networkmanager
, gcr
, libsecret
, file
, gtk3
, libnma
, libnma-gtk4
, gtk4
, withGnome ? true
, gnome
, kmod
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-openconnect";
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://gnome/sources/NetworkManager-openconnect/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "Xe2qeF2C2OI53dCCv6xSUMaR6WRGS+GAe2gnJjYzzcw=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openconnect;
    })
  ];

  buildInputs = [
    glib
    libxml2
    openconnect
    networkmanager
  ] ++ lib.optionals withGnome [
    gtk3
    libnma
    libnma-gtk4
    gtk4
    gcr
    libsecret
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
    file
  ];

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--with-gtk4=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openconnect";
      versionPolicy = "odd-unstable";
    };
    networkManagerPlugin = "VPN/nm-openconnect-service.name";
  };

  meta = with lib; {
    description = "NetworkManager’s OpenConnect plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
