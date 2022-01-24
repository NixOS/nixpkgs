{ lib, stdenv, fetchurl, boost, pkg-config, scons, util-linux, fuse, libevent, openssl, zlib }:

stdenv.mkDerivation {
  version = "0.8.1";
  pname = "ori";

  src = fetchurl {
    url = "https://bitbucket.org/orifs/ori/downloads/ori-0.8.1.tar.xz";
    sha256 = "8ce1a3dfbb6d1538885e993616bdfe71be44711d48f7f6798ff6bc0a39b3deca";
  };

  buildInputs = [
    boost pkg-config scons util-linux fuse libevent openssl zlib
  ];

  buildPhase = ''
    scons PREFIX=$out WITH_ORILOCAL=1 install
  '';

  dontInstall = true;

  meta = with lib; {
    description = "A secure distributed file system";
    homepage = "http://ori.scs.stanford.edu/";
    license = licenses.mit;
    platforms = platforms.unix;
    broken = true; # 2018-04-11
  };
}
