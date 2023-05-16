{ lib, stdenv, fetchurl, pkg-config, python3, xmlbird,
cairo, gdk-pixbuf, libgee, glib, gtk3, webkitgtk, libnotify, sqlite, vala,
<<<<<<< HEAD
gobject-introspection, gsettings-desktop-schemas, wrapGAppsHook, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "birdfont";
  version = "2.33.1";

  src = fetchurl {
    url = "https://birdfont.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-vFXpZNvsXpz7saRp6ruhvsP50rmJ2Prr2M78+8oxQ9M=";
  };

  nativeBuildInputs = [ python3 pkg-config vala gobject-introspection wrapGAppsHook autoPatchelfHook ];
=======
gobject-introspection, gsettings-desktop-schemas, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "birdfont";
  version = "2.32.3";

  src = fetchurl {
    url = "https://birdfont.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-ZsYwDS7pgs635P3wPX/PCTuHLX3/Iu97HgVe+qFyjZw=";
  };

  nativeBuildInputs = [ python3 pkg-config vala gobject-introspection wrapGAppsHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ xmlbird libgee cairo gdk-pixbuf glib gtk3 webkitgtk libnotify sqlite gsettings-desktop-schemas ];

  postPatch = ''
    substituteInPlace install.py \
      --replace 'platform.version()' '"Nix"'

    patchShebangs .
  '';

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = with lib; {
    description = "Font editor which can generate fonts in TTF, EOT, SVG and BIRDFONT format";
    homepage = "https://birdfont.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
