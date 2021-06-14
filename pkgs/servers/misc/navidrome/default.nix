{ lib, stdenv, fetchurl, ffmpeg, ffmpegSupport ? true, makeWrapper }:

with lib;

stdenv.mkDerivation rec {
  pname = "navidrome";
  version = "0.43.0";

  src = fetchurl {
    url = "https://github.com/deluan/navidrome/releases/download/v${version}/navidrome_${version}_Linux_x86_64.tar.gz";
    sha256 = "0y7a5n8phffxga1bjkaf7x5ijripqg1nfjljkrrj26778550vqb5";
  };

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

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    homepage = "https://www.navidrome.org/";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aciceri ];
  };
}
