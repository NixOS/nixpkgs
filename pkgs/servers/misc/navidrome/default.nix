{ lib, stdenv, fetchurl, ffmpeg, ffmpegSupport ? true, makeWrapper, nixosTests }:

with lib;

stdenv.mkDerivation rec {
  pname = "navidrome";
  version = "0.47.5";


  src = fetchurl (if stdenv.hostPlatform.system == "x86_64-linux"
  then {
    url = "https://github.com/deluan/navidrome/releases/download/v${version}/navidrome_${version}_Linux_x86_64.tar.gz";
    sha256 = "sha256-AkSjtln53HDdIcQgnA8Wj010RXnOlOsFm2wfVgbvwtc=";
  }
  else {
    url = "https://github.com/deluan/navidrome/releases/download/v${version}/navidrome_${version}_Linux_arm64.tar.gz";
    sha256 = "sha256-+VBRiV2zKa6PwamWj/jmE4iuoohAD6oeGnlFi4/01HM=";
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
