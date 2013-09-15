{ stdenv, fetchurl, pkgconfig, fuse, scons }:

stdenv.mkDerivation rec {
  name = "fuse-exfat-1.0.1";

  src = fetchurl {
    url = "http://exfat.googlecode.com/files/${name}.tar.gz";
    sha256 = "0n27hpi45lj9hpi7k8d7npiwyhasf1v832g7ckpknd6lnyhipb0j";
  };

  buildInputs = [ pkgconfig fuse scons ];

  buildPhase = ''
    export CCFLAGS="-O2 -Wall -std=c99 -I${fuse}/include"
    export LDFLAGS="-L${fuse}/lib"
    mkdir -pv $out/sbin
    scons DESTDIR=$out/sbin install
  '';

  installPhase = ":";

  meta = {
    homepage = http://code.google.com/p/exfat/;
    description = "A FUSE-based filesystem that allows read and write access to exFAT devices";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}

