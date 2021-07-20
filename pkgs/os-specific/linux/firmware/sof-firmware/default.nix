{ lib, stdenv, fetchFromGitHub }:

with lib;
stdenv.mkDerivation rec {
  pname = "sof-firmware";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof-bin";
    rev = "v${version}";
    sha256 = "sha256-NPbzDXZoZVWriV3klemX59ACnAlb357A5V/GbmzshyA=";
  };

  dontFixup = true; # binaries must not be stripped or patchelfed

  installPhase = ''
    cd v${version}.x
    mkdir -p $out/lib/firmware/intel/
    cp -a sof-v${version} $out/lib/firmware/intel/sof
    cp -a sof-tplg-v${version} $out/lib/firmware/intel/sof-tplg
  '';

  meta = with lib; {
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc evenbrenden hmenke ];
    platforms = with platforms; linux;
  };
}
