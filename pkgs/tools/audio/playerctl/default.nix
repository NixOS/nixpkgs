{ stdenv, fetchFromGitHub, autoconf, automake, libtool, which, gnome, glib,
  pkgconfig, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "playerctl";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "0dy6wc7qr00p53hlhpbg9x40w4ag95r2i7r1nsyb4ym3wzrvskzh";
  };

  buildInputs = [
    which autoconf automake libtool gnome.gtkdoc glib pkgconfig
    gobjectIntrospection
  ];

  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "Command-line utility and library for controlling media players that implement MPRIS";
    homepage = https://github.com/acrisci/playerctl;
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
