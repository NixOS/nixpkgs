{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, srt
, ffmpeg_3_4
, bc
, pkg-config
, perl
, openssl
, zlib
, ffmpeg
, libvpx
, libopus
, srtp
, jemalloc
, pcre2
}:

let
  ffmpeg = ffmpeg_3_4.overrideAttrs (super: {
    pname = "${super.pname}-ovenmediaengine";
    src = fetchFromGitHub {
      owner = "Airensoft";
      repo = "FFmpeg";
      rev = "142b4bb64b64e337f80066e6af935a68627fedae";  # on branch ome/3.4
      sha256 = "0fla3940q3z0c0ik2xzkbvdfvrdg06ban7wi6y94y8mcipszpp11";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "oven-media-engine";
  version = "0.10.9-hotfix";

  src = fetchFromGitHub {
    owner = "AirenSoft";
    repo = "OvenMediaEngine";
    rev = "v${version}";
    sha256 = "1fhria0vwqsgmsglv5gn858li33vfy2dwy1f1qdd2jwikskb53am";
  };

  patches = [
    (fetchpatch {
      # Needed to fix compilation under GCC 10.
      url = "https://github.com/AirenSoft/OvenMediaEngine/commit/ad83e1d2226445d649e4b7e0c75106e31af4940d.patch";
      sha256 = "1zk1rgi1wsjl6gdx3hdmgxlgindv6a3lsnkwcgi87ga9abw4vafw";
      stripLen = 1;
    })
  ];

  sourceRoot = "source/src";
  makeFlags = "release CONFIG_LIBRARY_PATHS= CONFIG_PKG_PATHS= GLOBAL_CC=$(CC) GLOBAL_CXX=$(CXX) GLOBAL_LD=$(CXX) SHELL=${stdenv.shell}";
  enableParallelBuilding = true;

  nativeBuildInputs = [ bc pkg-config perl ];
  buildInputs = [ openssl srt zlib ffmpeg libvpx libopus srtp jemalloc pcre2 ];

  preBuild = ''
    patchShebangs core/colorg++
    patchShebangs core/colorgcc
    patchShebangs projects/main/update_git_info.sh

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
    license     = licenses.gpl2Only;
    maintainers = with maintainers; [ lukegb ];
    platforms   = [ "x86_64-linux" ];
  };
}
