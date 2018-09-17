{ stdenv, meson, ninja, fetchFromGitHub, glib, pkgconfig, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "playerctl-${version}";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "0jnylj5d6i29c5y6yjxg1a88r2qfbac5pj95f2aljjkfh9428jbb";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gobjectIntrospection ];
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
