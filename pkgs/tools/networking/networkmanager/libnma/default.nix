{ stdenv
, fetchurl
, meson
, mesonEmulatorHook
, ninja
, gettext
, gtk-doc
, pkg-config
, vala
, networkmanager
, gnome
, isocodes
, libxml2
, docbook_xsl
, docbook_xml_dtd_43
, mobile-broadband-provider-info
, gobject-introspection
, gtk3
, withGtk4 ? false
, gtk4
, withGnome ? true
, gcr_4
, glib
, substituteAll
, lib
}:

stdenv.mkDerivation rec {
  pname = "libnma";
  version = "1.10.4";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "eecw3aGfmzSIb0BkqhcPGiMmsIMp1lXYC2fpBsf3i3w=";
  };

  patches = [
    # Needed for wingpanel-indicator-network and switchboard-plug-network
    ./hardcode-gsettings.patch
    # Removing path from eap schema to fix bug when creating new VPN connection
    # https://gitlab.gnome.org/GNOME/libnma/-/issues/18
    ./remove-path-from-eap.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    libxml2
    vala
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gtk3
    networkmanager
    isocodes
    mobile-broadband-provider-info
  ] ++ lib.optionals withGtk4 [
    gtk4
  ] ++ lib.optionals withGnome [
    # advanced certificate chooser
    gcr_4
  ];

  mesonFlags = [
    "-Dgcr=${lib.boolToString withGnome}"
    "-Dlibnma_gtk4=${lib.boolToString withGtk4}"
  ];

  postPatch = ''
    substituteInPlace src/nma-ws/nma-eap.c --subst-var-by \
      NM_APPLET_GSETTINGS ${glib.makeSchemaPath "$out" "$name"}
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libnma";
    description = "NetworkManager UI utilities (libnm version)";
    license = licenses.gpl2Plus; # Mix of GPL and LPGL 2+
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
