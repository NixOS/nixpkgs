{ stdenv, cmake, pkgconfig, SDL2, qtbase, qttools, xorg, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "antimicro-${version}";
  version = "2.23";

  src = fetchFromGitHub {
    owner = "AntiMicro";
    repo = "antimicro";
    rev = "${version}";
    sha256 = "1q40ayxwwyq85lc89cnj1cm2nar625h4vhh8dvmb2qcxczaggf4v";
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
