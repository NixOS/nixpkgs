{ lib, stdenv, fetchurl, ffmpeg, ffmpegSupport ? true, makeWrapper }:

with lib;

stdenv.mkDerivation rec {
  pname = "navidrome";
  version = "0.40.0";

  src = fetchurl {
    url = "https://github.com/deluan/navidrome/releases/download/v${version}/navidrome_${version}_Linux_x86_64.tar.gz";
    sha256 = "sha256-sBITCHyji55OnopNlDCNypSf/j8LKtarSGPYz5fQZys=";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
     tar xvf $src navidrome
  '';

  installPhase = ''
     mkdir -p $out/bin
     cp navidrome $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${makeBinPath (optional ffmpegSupport ffmpeg)}
  '';

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    homepage = "https://www.navidrome.org/";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aciceri ];
  };
}
