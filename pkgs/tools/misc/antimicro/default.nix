{ stdenv, cmake, pkgconfig, SDL2, qtbase, qttools, xorg, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "antimicro-${version}";
  version = "2.18.2";

  src = fetchFromGitHub {
    owner = "7185";
    repo = "antimicro";
    rev = "${version}";
    sha256 = "1mqw5idn57yj6c1w8y0byzh0xafcpbhaa6czgljh206abwfixjmk";
  };

  buildInputs = [
    cmake pkgconfig SDL2 qtbase qttools xorg.libXtst
  ];

  meta = with stdenv.lib; {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    homepage = "https://github.com/Ryochan7/antimicro";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.gpl3;
  };
}
