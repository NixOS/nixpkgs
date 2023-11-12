{ lib, stdenv, fetchFromGitHub, python39, flex, bison }:

stdenv.mkDerivation rec {
  pname = "gnoll";
  version = "4.3.4";

  src = fetchFromGitHub {
    owner = "ianfhunter";
    repo = "GNOLL";
    rev = "v${version}";
    sha256 = "1s495qmakw2n50x11klf6wb2869b5v94wsihq4r19mqdbg1pxm1y";
  };

  nativeBuildInputs = [ python39 flex bison ];

  installPhase = "mkdir -p $out/bin ; mv build/dice $out/bin";

  meta = with lib; {
    homepage = "https://www.ianhunter.ie/GNOLL";
    description = "an efficient dice notation parser for multiple programming languages that supports a wide set of dice notation";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ _0x4d6165 ];
  };
}
