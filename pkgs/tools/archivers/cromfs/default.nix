{stdenv, fetchurl, pkgconfig, fuse, perl}:

stdenv.mkDerivation {
  name = "cromfs-1.5.8.6";
  src = fetchurl {
    url = http://bisqwit.iki.fi/src/arch/cromfs-1.5.8.6.tar.bz2;
    sha256 = "00m362q0b7z1688pjhvnbr14y3p1lgaymq5k9r42z3blzw8mgmay";
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
