{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, srt
, bc
, pkg-config
, perl
, openssl
, zlib
, ffmpeg_4
, libvpx
, libopus
, libuuid
, srtp
, jemalloc
, pcre2
, hiredis
}:

stdenv.mkDerivation rec {
  pname = "oven-media-engine";
<<<<<<< HEAD
  version = "0.15.14";
=======
  version = "0.15.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AirenSoft";
    repo = "OvenMediaEngine";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-pLLnk0FXJ6gb0WSdWGEzJSEbKdOpjdWECIRzrHvi8HQ=";
  };

  sourceRoot = "${src.name}/src";
=======
    sha256 = "sha256-gQ9Z8VMu5v4zEo4vtViNFG0QP5JooHsQxJPMOnZmVZM=";
  };

  sourceRoot = "source/src";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  makeFlags = [ "release" "CONFIG_LIBRARY_PATHS=" "CONFIG_PKG_PATHS=" "GLOBAL_CC=$(CC)" "GLOBAL_CXX=$(CXX)" "GLOBAL_LD=$(CXX)" "SHELL=${stdenv.shell}" ];
  enableParallelBuilding = true;

  nativeBuildInputs = [ bc pkg-config perl ];
  buildInputs = [ openssl srt zlib ffmpeg_4 libvpx libopus srtp jemalloc pcre2 libuuid hiredis ];

  preBuild = ''
    patchShebangs core/colorg++
    patchShebangs core/colorgcc
    patchShebangs projects/main/update_git_info.sh

    sed -i -e 's/const AVOutputFormat /AVOutputFormat /g' \
      projects/modules/mpegts/mpegts_writer.cpp \
      projects/modules/file/file_writer.cpp \
      projects/modules/rtmp/rtmp_writer.cpp
    sed -i -e '/^CC =/d' -e '/^CXX =/d' -e '/^AR =/d' projects/third_party/pugixml-1.9/scripts/pugixml.make
  '';

  installPhase = ''
    install -Dm0755 bin/RELEASE/OvenMediaEngine $out/bin/OvenMediaEngine
    install -Dm0644 ../misc/conf_examples/Origin.xml $out/share/examples/origin_conf/Server.xml
    install -Dm0644 ../misc/conf_examples/Logger.xml $out/share/examples/origin_conf/Logger.xml
    install -Dm0644 ../misc/conf_examples/Edge.xml $out/share/examples/edge_conf/Server.xml
    install -Dm0644 ../misc/conf_examples/Logger.xml $out/share/examples/edge_conf/Logger.xml
  '';

  meta = with lib; {
    description = "Open-source streaming video service with sub-second latency";
    homepage    = "https://ovenmediaengine.com";
    license     = licenses.agpl3Only;
    maintainers = with maintainers; [ lukegb ];
<<<<<<< HEAD
    platforms   = platforms.linux;
=======
    platforms   = [ "x86_64-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
