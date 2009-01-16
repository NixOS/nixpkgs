{stdenv, fetchurl, pkgconfig, fuse, perl}:

stdenv.mkDerivation {
  name = "cromfs-1.5.6.2";
  src = fetchurl {
    url = http://bisqwit.iki.fi/src/arch/cromfs-1.5.6.2.tar.bz2;
    sha256 = "bbe5db623d3c0d2b92fe877d8c8e22a8f8d84210739313bf691d42c05406464d";
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
