{ stdenv
, lib
, desktop-file-utils
, fetchpatch
, fetchurl
, glib
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
  version = "1.2.0";

  outputs = [ "out" "lib" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/dspy/${lib.versions.majorMinor version}/dspy-${version}.tar.xz";
    sha256 = "XKL0z00w0va9m1OfuVq5YJyE1jzeynBxb50jc+O99tQ=";
  };

  patches = [
    # Remove pointless dependencies
    # https://gitlab.gnome.org/GNOME/d-spy/-/merge_requests/6
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/d-spy/-/commit/5a0ec8d53d006e95e93c6d6e32a381eb248b12a1.patch";
      sha256 = "jalfdAXcH8GZ50qb2peG+2841cGan4EhwN88z5Ewf+k=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook4
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
