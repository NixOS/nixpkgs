{ lib, stdenv, meson, ninja, fetchFromGitHub, glib, pkg-config, gtk-doc, docbook_xsl, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "playerctl";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "00z5c6amlxd3q42l7x8i0ngl627dxglgg5vikbbhjp9ms34xbxdn";
  };

  nativeBuildInputs = [ meson ninja pkg-config gtk-doc docbook_xsl gobject-introspection ];
  buildInputs = [ glib ];

  mesonFlags = [ "-Dbash-completions=true" ];

  meta = with lib; {
    description = "Command-line utility and library for controlling media players that implement MPRIS";
    homepage = "https://github.com/acrisci/playerctl";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
