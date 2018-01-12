{ stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "deepin-gtk-theme-${version}";
  version = "17.10.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-gtk-theme";
    rev = version;
    sha256 = "0ff1yg4gz4p7nd0qg3dcbsiw8yqlvqccm55kxi998w8j1wrg6pq3";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Deepin GTK Theme";
    homepage = https://github.com/linuxdeepin/deepin-gtk-theme;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
