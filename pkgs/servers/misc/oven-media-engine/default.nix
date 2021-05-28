{ stdenv
, fetchFromGitHub
, srt
, ffmpeg_3_4
, bc
, pkgconfig
, perl
, openssl
, zlib
, ffmpeg
, libvpx
, libopus
, srtp
, jemalloc
, ... }:

let
  ffmpeg = ffmpeg_3_4.overrideAttrs (super: {
    pname = "${super.pname}-ovenmediaengine";
    src = fetchFromGitHub {
      owner = "Airensoft";
      repo = "FFmpeg";
      rev = "142b4bb64b64e337f80066e6af935a68627fedae";  # ome/3.4
      sha256 = "0fla3940q3z0c0ik2xzkbvdfvrdg06ban7wi6y94y8mcipszpp11";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "oven-media-engine";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "AirenSoft";
    repo = "OvenMediaEngine";
    rev = "v${version}";
    sha256 = "15lrlynsldlpa21ryzccf5skgiih6y5fc9qg0bfqh557wnnmml6w";
  };

  sourceRoot = "source/src";
  makeFlags = "release CONFIG_LIBRARY_PATHS= CONFIG_PKG_PATHS= GLOBAL_CC=$(CC) GLOBAL_CXX=$(CXX) GLOBAL_LD=$(CXX) SHELL=${stdenv.shell}";
  enableParallelBuilding = true;

  nativeBuildInputs = [ bc pkgconfig perl ];
  buildInputs = [ openssl srt zlib ffmpeg libvpx libopus srtp jemalloc ];

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

  meta = with stdenv.lib; {
    description = "Open-source streaming video service with sub-second latency";
    homepage    = "https://ovenmediaengine.com";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lukegb ];
    platforms   = [ "x86_64-linux" ];
  };
}
