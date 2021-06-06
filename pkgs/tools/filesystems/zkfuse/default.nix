{ stdenv
, lib
, autoreconfHook
, gnused
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

  nativeBuildInputs = [ autoreconfHook gnused ];
  buildInputs = [ zookeeper_mt log4cxx boost fuse ];

  postPatch = ''
    # Make the async API accessible, and use the proper include path.
    sed -i src/zkadapter.h \
        -e '/"zookeeper\.h"/i#define THREADED' \
        -e 's,"zookeeper\.h",<zookeeper/zookeeper.h>,'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v src/zkfuse $out/bin
  '';

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ztzg ];
    license = licenses.asl20;
  };
}
