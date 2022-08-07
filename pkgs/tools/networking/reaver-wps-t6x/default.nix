{ lib, stdenv, fetchFromGitHub, libpcap, pixiewps, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "reaver-wps-t6x";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "t6x";
    repo = "reaver-wps-fork-t6x";
    rev = "v${version}";
    sha256 = "03v5jyb4if74rpg0mcd8700snb120b6w2gnsa3aqdgj5676ic5dn";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpcap pixiewps ];

  sourceRoot = "source/src";

  meta = with lib; {
    description = "Online and offline brute force attack against WPS";
    homepage = "https://github.com/t6x/reaver-wps-fork-t6x";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nico202 ];
  };
}
