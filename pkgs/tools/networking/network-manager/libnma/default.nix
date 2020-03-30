{ stdenv
, fetchurl
, meson
, ninja
, gettext
, gtk-doc
, pkg-config
, vala
, networkmanager
, gnome3
, isocodes
, libxml2
, docbook_xsl
, docbook_xml_dtd_43
, mobile-broadband-provider-info
, gobject-introspection
, gtk3
, withGnome ? true
, gcr
, glib
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "libnma";
  version = "1.8.28";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "09mp6k0hfam1vyyv9kcd8j4gb2r58i05ipx2nswb58ris599bxja";
  };

  patches = [
    # Needed for wingpanel-indicator-network and switchboard-plug-network
    ./hardcode-gsettings.patch
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
  ];

  buildInputs = [
    gtk3
    networkmanager
    isocodes
    mobile-broadband-provider-info
  ] ++ stdenv.lib.optionals withGnome [
    # advanced certificate chooser
    gcr
  ];

  mesonFlags = [
    "-Dgcr=${if withGnome then "true" else "false"}"
  ];

  postPatch = ''
    substituteInPlace src/nma-ws/nma-eap.c --subst-var-by \
      NM_APPLET_GSETTINGS ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libnma";
    description = "NetworkManager UI utilities (libnm version)";
    license = licenses.gpl2Plus; # Mix of GPL and LPGL 2+
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
