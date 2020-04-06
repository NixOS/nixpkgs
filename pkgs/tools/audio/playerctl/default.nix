{ stdenv, meson, ninja, fetchFromGitHub, glib, pkgconfig, gtk-doc, docbook_xsl, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "playerctl";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "03f3645ssqf8dpkyzj9rlglrzh0840sflalskx9s4i03bgq3v4r9";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gtk-doc docbook_xsl gobject-introspection ];
  buildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "Command-line utility and library for controlling media players that implement MPRIS";
    homepage = https://github.com/acrisci/playerctl;
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
