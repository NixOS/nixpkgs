{ stdenv, meson, ninja, fetchFromGitHub, glib, pkgconfig, gtk-doc, docbook_xsl, gobject-introspection }:

stdenv.mkDerivation rec {
  name = "playerctl-${version}";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "1f3njnpd52djx3dmhh9a8p5a67f0jmr1gbk98icflr2q91149gjz";
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
