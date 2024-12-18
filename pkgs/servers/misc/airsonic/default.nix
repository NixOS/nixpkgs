{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "airsonic";
  version = "10.6.2";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic/releases/download/v${version}/airsonic.war";
    sha256 = "0q3qnqymj3gaa6n79pvbyidn1ga99lpngp5wvhlw1aarg1m7vccl";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/airsonic.war"
  '';

  passthru.tests = {
    airsonic-starts = nixosTests.airsonic;
  };

  meta = with lib; {
    description = "Personal media streamer";
    homepage = "https://airsonic.github.io";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ disassembler ];
  };
}
