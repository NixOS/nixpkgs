{ stdenv, fetchurl, libsysfs, gnutls, openssl, libcap }:

assert stdenv ? glibc;

let
  time = "20121221";
in
stdenv.mkDerivation rec {
  name = "iputils-${time}";
  
  src = fetchurl {
    url = "http://www.skbuff.net/iputils/iputils-s${time}.tar.bz2";
    sha256 = "17riqp8dh8dvx32zv3hyrghpxz6xnxa6vai9b4yc485nqngm83s5";
  };

  buildInputs = [ libsysfs gnutls openssl libcap ];

  buildFlags = "all ninfod";

  installPhase =
    ''
      mkdir -p $out/sbin $out/bin
      cp -p ping ping6 tracepath tracepath6 traceroute6 $out/bin/
      cp -p clockdiff arping rdisc ninfod/ninfod $out/sbin/
    '';
    
  meta = {
    homepage = http://www.skbuff.net/iputils/;
    description = "A set of small useful utilities for Linux networking";
    platforms = stdenv.lib.platforms.linux;
  };
}
