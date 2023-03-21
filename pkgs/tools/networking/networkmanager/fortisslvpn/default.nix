{ stdenv
, lib
, fetchurl
, substituteAll
, openfortivpn
, gettext
, pkg-config
, file
, glib
, gtk3
, gtk4
, networkmanager
, ppp
, libsecret
, withGnome ? true
, gnome
, libnma
, libnma-gtk4
}:

stdenv.mkDerivation rec {
  pname = "NetworkManager-fortisslvpn";
  version = "1.4.0";
  name = "${pname}${lib.optionalString withGnome "-gnome"}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sFXiY0m1FrI1hXmKs+9XtDawFIAOkqiscyz8jnbF2vo=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit openfortivpn;
    })
  ];

  nativeBuildInputs = [
    gettext
    pkg-config
    file
  ];

  buildInputs = [
    openfortivpn
    networkmanager
    ppp
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
    "--localstatedir=/var"
    "--enable-absolute-paths"
  ];

  installFlags = [
    # the installer only creates an empty directory in localstatedir, so
    # we can drop it
    "localstatedir=."
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "networkmanager-fortisslvpn";
      versionPolicy = "odd-unstable";
    };
    networkManagerPlugin = "VPN/nm-fortisslvpn-service.name";
  };

  meta = with lib; {
    description = "NetworkManager’s FortiSSL plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2;
  };
}
