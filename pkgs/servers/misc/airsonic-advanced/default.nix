{ lib, stdenv, fetchurl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "airsonic-advanced";
  version = "11.0.0-SNAPSHOT.20211116202136";

  src = fetchurl {
    url = "https://github.com/airsonic/airsonic-advanced/releases/tag/${version}/airsonic.war";
    sha256 = "0la7px07gw1s4hfbw4x22nd31x2ddqbpr3kfkg6f4i2grh3218mh";
  };

  buildCommand = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/airsonic.war"
  '';

  passthru.tests = {
    airsonic-starts = nixosTests.airsonic-advanced;
  };

  meta = with lib; {
    description = "Personal media streamer";
    homepage = "https://github.com/airsonic-advanced/airsonic-advanced";
    license = lib.licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ disassembler pinpox ];
  };
}
