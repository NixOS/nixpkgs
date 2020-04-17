{ stdenv, fetchurl, boost, pkgconfig, scons, utillinux, fuse, libevent, openssl, zlib }:

stdenv.mkDerivation {
  version = "0.8.1";
  pname = "ori";

  src = fetchurl {
    url = "https://bitbucket.org/orifs/ori/downloads/ori-0.8.1.tar.xz";
    sha256 = "8ce1a3dfbb6d1538885e993616bdfe71be44711d48f7f6798ff6bc0a39b3deca";
  };

  buildInputs = [ 
    boost pkgconfig scons utillinux fuse libevent openssl zlib
  ];

  buildPhase = ''
    scons PREFIX=$out WITH_ORILOCAL=1 install
  '';

  installPhase = ":";

  meta = with stdenv.lib; {
    description = "A secure distributed file system";
    homepage = "http://ori.scs.stanford.edu/";
    license = licenses.mit;
    platforms = platforms.unix;
    broken = true; # 2018-04-11
  };
}
