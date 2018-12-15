{ stdenv, meson, ninja, fetchFromGitHub, glib, pkgconfig, gobject-introspection }:

stdenv.mkDerivation rec {
  name = "playerctl-${version}";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "0j1fvcc80307ybl1z9l752sr4bcza2fmb8qdivpnm4xmm82faigb";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gobject-introspection ];
  buildInputs = [ glib ];

  # docs somehow crashes the install phase:
  # https://github.com/acrisci/playerctl/issues/85
  mesonFlags = [ "-Dgtk-doc=false" ];

  meta = with stdenv.lib; {
    description = "Command-line utility and library for controlling media players that implement MPRIS";
    homepage = https://github.com/acrisci/playerctl;
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
