{ stdenv, fetchurl, ffmpeg, ffmpegSupport ? true, makeWrapper, nixosTests }:

with stdenv.lib;

let
  version = "0.39.0";
  upstream-systemd-unit = fetchurl {
    url = "https://raw.githubusercontent.com/deluan/navidrome/v${version}/contrib/navidrome.service";
    sha256 = "065lcmv7carbi0vy08qh3q5rsii8hp8xrrnfk5dgqyvykpf97cz5";
  };
in stdenv.mkDerivation rec {
  pname = "navidrome";
  inherit version;

  src = fetchurl {
    url = "https://github.com/deluan/navidrome/releases/download/v${version}/navidrome_${version}_Linux_x86_64.tar.gz";
    sha256 = "0ngqlb9d8xml0vnjsn6vpi02sjqldsiirlrzfncrh3hlcrhk4fcn";
  };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
     tar xvf $src navidrome
  '';

  installPhase = ''
     mkdir -p $out/bin
     cp navidrome $out/bin
     mkdir -p $out/lib/systemd/system
     cp ${upstream-systemd-unit} $out/lib/systemd/system/navidrome.service
  '';

  postFixup = ''
    wrapProgram $out/bin/navidrome \
      --prefix PATH : ${makeBinPath (optional ffmpegSupport ffmpeg)}
  '';

  passthru.tests.navidrome = nixosTests.navidrome;

  meta = {
    description = "Navidrome Music Server and Streamer compatible with Subsonic/Airsonic";
    homepage = "https://www.navidrome.org/";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aciceri ];
  };
}
