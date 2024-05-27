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
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "AirenSoft";
    repo = "OvenMediaEngine";
    rev = "v${version}";
    sha256 = "sha256-hkLIJ3vGpnywcOw+bfEsQESGFe1FUcCVJlMlVgGsrNs=";
  };

  sourceRoot = "${src.name}/src";
  makeFlags = [ "release" "CONFIG_LIBRARY_PATHS=" "CONFIG_PKG_PATHS=" "GLOBAL_CC=$(CC)" "GLOBAL_CXX=$(CXX)" "GLOBAL_LD=$(CXX)" "SHELL=${stdenv.shell}" ];
  enableParallelBuilding = true;

  nativeBuildInputs = [ bc pkg-config perl ];
  buildInputs = [ openssl srt zlib ffmpeg_4 libvpx libopus srtp jemalloc pcre2 libuuid hiredis ];

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
    mainProgram = "OvenMediaEngine";
    homepage    = "https://ovenmediaengine.com";
    license     = licenses.agpl3Only;
    maintainers = with maintainers; [ lukegb ];
    platforms   = platforms.linux;
  };
}
