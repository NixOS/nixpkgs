{ stdenv, cmake, pkgconfig, SDL2, qtbase, qttools, xorg, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "antimicro-${version}";
  version = "2.22";

  src = fetchFromGitHub {
    owner = "AntiMicro";
    repo = "antimicro";
    rev = "${version}";
    sha256 = "102fh9ysd2dmfc6b73bj88m064jhlglqrz2gd7k9jccadxpbp3mq";
  };

  buildInputs = [
    cmake pkgconfig SDL2 qtbase qttools xorg.libXtst
  ];

  meta = with stdenv.lib; {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl3;
    platforms = with platforms; linux;
  };
}
