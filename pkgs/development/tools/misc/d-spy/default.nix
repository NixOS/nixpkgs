{ stdenv
, lib
, desktop-file-utils
, fetchurl
, glib
, gettext
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gnome
}:

stdenv.mkDerivation rec {
  pname = "d-spy";
  version = "1.2.1";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/dspy/${lib.versions.majorMinor version}/dspy-${version}.tar.xz";
    sha256 = "TjnA1to687eJASJd0VEjOFe+Ihtfs62CwdsVhyNrZlI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook4
    gettext
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "dspy";
      attrPath = "d-spy";
    };
  };

  meta = with lib; {
    description = "D-Bus exploration tool";
    homepage = "https://gitlab.gnome.org/GNOME/d-spy";
    license = with licenses; [
      lgpl3Plus # library
      gpl3Plus # app
    ];
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
