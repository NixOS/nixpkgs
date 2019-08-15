{ stdenv, lib, zookeeper, zookeeper_mt, fuse, autoreconfHook, log4cxx, boost }:

stdenv.mkDerivation rec {
  pname = "zkfuse";
  inherit (zookeeper) version src;

  sourceRoot = "${zookeeper.name}/src/contrib/zkfuse";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ zookeeper_mt log4cxx boost fuse ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v src/zkfuse $out/bin
  '';

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
    license = licenses.asl20;
  };
}
