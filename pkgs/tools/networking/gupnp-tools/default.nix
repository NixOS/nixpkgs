{ stdenv
, lib
, fetchurl
, meson
, ninja
, gupnp_1_6
, libsoup_3
, gssdp_1_6
, pkg-config
, gtk3
, gettext
, gupnp-av
, gtksourceview4
, gnome
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gupnp-tools";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "XqdgfuNlZCxVWSf+3FteH+COdPBh0MPrCL2QG16yAII=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gupnp_1_6
    libsoup_3
    gssdp_1_6
    gtk3
    gupnp-av
    gtksourceview4
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Set of utilities and demos to work with UPnP";
    homepage = "https://wiki.gnome.org/Projects/GUPnP";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
