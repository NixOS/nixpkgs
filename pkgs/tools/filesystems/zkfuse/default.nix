{ stdenv, lib, zookeeper, zookeeper_mt, fuse, pkgconfig, autoreconfHook, log4cxx, boost, tree }:

stdenv.mkDerivation rec {
  name = "zkfuse";

  src = zookeeper.src;
  patches = [
    # see: https://issues.apache.org/jira/browse/ZOOKEEPER-1929
    ./zookeeper-1929.patch
  ];

  setSourceRoot = "export sourceRoot=${zookeeper.name}/src/contrib/zkfuse";

  buildInputs = [ autoreconfHook zookeeper_mt log4cxx boost fuse ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v src/zkfuse $out/bin
  '';

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
