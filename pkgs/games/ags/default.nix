{ lib
, stdenv
, cmake
, fetchurl
, fetchFromGitHub
, alsaLib
, dumb
, libjack2
, libogg
, libtheora
, libvorbis
, libXext
, libXxf86vm
, libX11
, pkg-config
, SDL2
}:

stdenv.mkDerivation rec {
  name = "ags";
  version = "3.5.0.30";

  src = fetchurl {
    url = "https://github.com/adventuregamestudio/ags/releases/download/v.${version}/ags_${version}_source.tar.gz";
    sha256 = "1d74ajw8p2g8rbklr73hm9di6az71vlw7m8r8jxiw0lfbk0iv2i9";
  };

  # prevent the original builder from trying to download
  patches = [ ./no-download.patch ];

  # download the deps manually for subsequent unpacking
  libAllegro = fetchFromGitHub {
    owner = "adventuregamestudio";
    repo = "lib-allegro";
    rev = "allegro-4.4.3.1-agspatch";
    sha256 = "0vg8fkqqy78f46sl6xagja7g91n9xck8z0z22q5xvlcz41lf3cb5";
  };

  libOgg = fetchFromGitHub {
    owner = "xiph";
    repo = "ogg";
    rev = "f7dadaaf75634289f7ead64ed1802b627d761ee3";
    sha256 = "1whvkq4x4hx61zbbc912qzv1hfqk64b6c02ab5m8y0xk24ghlfgq";
  };

  libTheora = fetchFromGitHub {
    owner = "xiph";
    repo = "theora";
    rev = "e5d205bfe849f1b41f45b91a0b71a3bdc6cd458f";
    sha256 = "1qpy7c6f7wc8f8zph0cvy6z8ag9r7vszpkxhy7z3x523d1lcrmsd";
  };

  libVorbis = fetchFromGitHub {
    owner = "xiph";
    repo = "vorbis";
    rev = "9eadeccdc4247127d91ac70555074239f5ce3529";
    sha256 = "1phdcr6mfv85g6qabq811bw9p87kdfnrvjvapsq2b8yfwdddgi0s";
  };

  # default behavior breaks the build
  dontUseCmakeBuildDir = true;
  dontFixCmake = true;

  cmakeFlags = [
    "-Wno-dev" # kill dev warnings that are useless for packaging
  ];

  # copy files that are typically fetched by git
  preConfigure = ''
    mkdir -p _deps
    cp -a $libAllegro _deps/allegro_content-src
    cp -a $libOgg _deps/ogg_content-src
    cp -a $libVorbis _deps/vorbis_content-src
    cp -a $libTheora _deps/theora_content-src
    chmod -R +w _deps/allegro_content-src
    chmod -R +w _deps/ogg_content-src
    chmod -R +w _deps/vorbis_content-src
    chmod -R +w _deps/theora_content-src
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ alsaLib dumb libjack2 libogg SDL2 libtheora libvorbis libXext libXxf86vm libX11 ];

  installPhase = "install -Dm755 ags -t $out/bin";

  meta = with lib; {
    description = "Adventure Game Studio runtime engine";
    homepage = "https://www.adventuregamestudio.co.uk/";
    license = licenses.artistic2;
    platforms = platforms.linux;
  };
}
