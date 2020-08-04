{ stdenv, fetchurl, ffmpeg, ffmpegSupport ? true, makeWrapper }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "navidrome";
  version = "0.27.0";

  src = fetchurl {
    url = "https://github.com/deluan/navidrome/releases/download/v${version}/navidrome_${version}_Linux_x86_64.tar.gz";
    sha256 = "0givv23dx6hwzg0axwifrha17qafs19ag34vjz29xrj3smsl8zh3";
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
