{ stdenv, fetchFromGitHub, autoconf, automake, libtool, which, gnome, glib,
  pkgconfig, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "playerctl-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "0b4pg5pwblgbf6kvvynzh9dshfikxy5c2ks7733n7wza5wkpgmng";
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
