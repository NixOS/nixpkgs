{ lib, stdenv, fetchurl, pkg-config, python3, xmlbird,
cairo, gdk-pixbuf, libgee, glib, gtk3, webkitgtk, libnotify, sqlite, vala,
gobject-introspection, gsettings-desktop-schemas, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "birdfont";
  version = "2.30.0";

  src = fetchurl {
    url = "https://birdfont.org/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-aIhJXmzLY2Sw9mFe2AmLkXb+YRnFu1pMnFeDF+zfHRE=";
  };

  nativeBuildInputs = [ python3 pkg-config vala gobject-introspection wrapGAppsHook ];
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
