{ stdenv
, lib
, autoreconfHook
, boost
, fuse
, log4cxx
, zookeeper
, zookeeper_mt
}:

stdenv.mkDerivation rec {
  pname = "zkfuse";
  inherit (zookeeper_mt) version src;

  sourceRoot = "apache-${zookeeper.pname}-${version}/zookeeper-contrib/zookeeper-contrib-zkfuse";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zookeeper_mt log4cxx boost fuse ];

  postPatch = ''
    # Make the async API accessible, and use the proper include path.
    sed -i src/zkadapter.h \
        -e '/"zookeeper\.h"/i#define THREADED' \
        -e 's,"zookeeper\.h",<zookeeper/zookeeper.h>,'
  '';

  # c++17 (gcc-11's default) breaks the build as:
  #   zkadapter.h:616:33: error: ISO C++17 does not allow dynamic exception specifications
  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v src/zkfuse $out/bin
  '';

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ ztzg ];
    license = licenses.asl20;
    mainProgram = "zkfuse";
  };
}
