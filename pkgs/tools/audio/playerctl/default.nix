{ lib, stdenv, meson, ninja, fetchFromGitHub, glib, pkg-config, gtk-doc, docbook_xsl, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "playerctl";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "sha256-OiGKUnsKX0ihDRceZoNkcZcEAnz17h2j2QUOSVcxQEY=";
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
