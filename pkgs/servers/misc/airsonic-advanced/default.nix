{ lib, stdenvNoCC, fetchurl, nixosTests }:

stdenvNoCC.mkDerivation rec {
  pname = "airsonic-advanced";
  version = "11.0.0-SNAPSHOT.20211116202136";

  src = fetchurl {
    url = "https://github.com/airsonic-advanced/airsonic-advanced/releases/download/${version}/airsonic.war";
    sha256 = "sha256-soLnjltoATjqNHRpcVcqiTSQGJwSSzxwKEMk/cr42YU=";
  };

  installPhase = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/airsonic.war"
  '';

  passthru.tests = {
    airsonic-starts = nixosTests.airsonic-advanced;
  };

  meta = with lib; {
    description = "Personal media streamer";
    homepage = "https://github.com/airsonic-advanced/airsonic-advanced";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ disassembler pinpox ];
  };
}
