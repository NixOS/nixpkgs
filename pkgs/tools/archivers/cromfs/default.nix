{stdenv, fetchurl, pkgconfig, fuse, perl}:

stdenv.mkDerivation {
  name = "cromfs-1.5.7";
  src = fetchurl {
    url = http://bisqwit.iki.fi/src/arch/cromfs-1.5.7.tar.bz2;
    sha256 = "7df900cd5d2656e0d2a9cdfb6da7dd194eef2e2a34537f7f69a56dc08a0c0deb";
  };

  patchPhase = ''sed -i 's@/bin/bash@/bin/sh@g' configure; set -x'';


  meta = {
    description = "FUSE Compressed ROM filesystem with lzma"  ;
	  homepage = http://bisqwit.iki.fi/source/cromfs.html;
  };
  
  installPhase = ''
    install -d $out/bin
    install cromfs-driver $out/bin
    install cromfs-driver-static $out/bin
    install util/cvcromfs $out/bin
    install util/mkcromfs $out/bin
    install util/unmkcromfs $out/bin
  '';

  buildInputs = [pkgconfig fuse perl];
}
