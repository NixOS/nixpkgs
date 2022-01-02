{ stdenv, lib, fetchFromGitHub, nymphrpc, libnymphcast, ffmpeg, SDL2, SDL2_image, poco, freetype, freeimage, rapidjson, pkg-config, libvlc, curl, alsa-lib }:

stdenv.mkDerivation rec {
  pname = "NymphCast";
  version = "0.1-rc0";

  src = fetchFromGitHub {
    owner = "MayaPosch";
    repo = "NymphCast";
    rev = "v${version}";
    sha256 = "sha256-zvJXl4fHM9vHJWYFP97+7I30gOuKZPwNZVnJhQMhh14=";
  };

  sourceRoot = "source/src/server";

  installFlags = [ "CONFDIR=${placeholder "out"}/etc" "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    nymphrpc
    libnymphcast
    ffmpeg
    SDL2
    SDL2_image
    poco
    freetype
    freeimage
    rapidjson
    libvlc
    curl
  ];

  meta = with lib; {
    description = "A software solution which turns your choice of Linux-capable hardware into an audio and video source for a television or powered speakers";
    homepage = "http://nyanko.ws/nymphcast.php";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ aanderse ];
    platforms = platforms.unix;
  };
}
