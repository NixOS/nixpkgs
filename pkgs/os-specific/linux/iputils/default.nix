{ stdenv, fetchurl, libsysfs, openssl }:

assert stdenv ? glibc;

stdenv.mkDerivation {
  name = "iputils-20101006";
  
  src = fetchurl {
    url = http://www.skbuff.net/iputils/iputils-s20101006.tar.bz2;
    sha256 = "1rvfvdnmzlmgy9a6xv5v4n785zmn10v2l7yaq83rdfgbh1ng8fpx";
  };

  buildInputs = [ libsysfs openssl ];

  # Urgh, it uses Make's `-l' dependency "feature". 
  makeFlags = "VPATH=${libsysfs}/lib:${stdenv.glibc}/lib:${openssl}/lib";

  installPhase =
    ''
      mkdir -p $out/sbin
      cp -p arping ping ping6 rdisc tracepath tracepath6 traceroute6 $out/sbin/
    '';
    
  meta = {
    homepage = http://www.skbuff.net/iputils/;
    description = "A set of small useful utilities for Linux networking";
    platforms = stdenv.lib.platforms.linux;
  };
}
