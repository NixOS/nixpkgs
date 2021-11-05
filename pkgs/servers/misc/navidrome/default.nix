{ lib, stdenv, fetchurl, ffmpeg, ffmpegSupport ? true, makeWrapper, nixosTests }:

with lib;

stdenv.mkDerivation rec {
  pname = "navidrome";
  version = "0.45.1";


  src = fetchurl (if stdenv.hostPlatform.system == "x86_64-linux"
  then {
    url = "https://github.com/deluan/navidrome/releases/download/v${version}/navidrome_${version}_Linux_x86_64.tar.gz";
    sha256 = "sha256-TZcXq51sKoeLPmcRpv4VILDmS6dsS7lxlJzTDH0tEWM=";
  }
  else {
    url = "https://github.com/deluan/navidrome/releases/download/v${version}/navidrome_${version}_Linux_arm64.tar.gz";
    sha256 = "sha256-Va0DSmemj8hsaywoP6WKo/x+QQzSNwHCpU4VWs5lpbI=";
  });

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    tar xvf $src navidrome
  '';

  installPhase = ''
    runHook preInstall

     mkdir -p $out/bin
     cp navidrome $out/bin

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${makeBinPath (optional ffmpegSupport ffmpeg)}
  '';

  passthru.tests.navidrome = nixosTests.navidrome;

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    homepage = "https://www.navidrome.org/";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ aciceri ];
  };
}
