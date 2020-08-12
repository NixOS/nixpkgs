{ stdenv, meson, ninja, fetchFromGitHub, glib, pkgconfig, gtk-doc, docbook_xsl, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "playerctl";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "17hi33sw3663qz5v54bqqil31sgkrlxkb2l5bgqk87pac6x2wnbz";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gtk-doc docbook_xsl gobject-introspection ];
  buildInputs = [ glib ];

  mesonFlags = [ "-Dbash-completions=true" ];

  meta = with stdenv.lib; {
    description = "Command-line utility and library for controlling media players that implement MPRIS";
    homepage = "https://github.com/acrisci/playerctl";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
