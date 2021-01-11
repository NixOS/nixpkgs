{ lib, stdenv, fetchFromGitHub }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "sof-firmware";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    rev = "cbdec6963b2c2d58b0080955d3c11b96ff4c92f0";
    sha256 = "0la2pw1zpv50cywiqcfb00cxqvjc73drxwjchyzi54l508817nxh";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib/firmware

    patchShebangs go.sh
    ROOT=$out SOF_VERSION=v${version} ./go.sh
  '';

  meta = with lib; {
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc evenbrenden ];
    platforms = with platforms; linux;
  };
}
