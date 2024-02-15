{ lib, stdenv, fetchFromGitHub, libpcap, pixiewps, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "reaver-wps-t6x";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "t6x";
    repo = "reaver-wps-fork-t6x";
    rev = "v${version}";
    sha256 = "sha256-7g4ZRkyu0TIOUw68dSPP4RyIRyeq1GgUMYFVSQB8/1I=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libpcap pixiewps ];

  sourceRoot = "${src.name}/src";

  meta = with lib; {
    description = "Online and offline brute force attack against WPS";
    homepage = "https://github.com/t6x/reaver-wps-fork-t6x";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nico202 ];
  };
}
