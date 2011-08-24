{stdenv, fetchurl, pkgconfig, curl, gpgme}:

stdenv.mkDerivation {
  name = "opkg-0.1.8";
  src = fetchurl {
    url = http://opkg.googlecode.com/files/opkg-0.1.8.tar.gz;
    sha256 = "0q0w7hmc6zk7pnddamd5v8d76qnh3043lzh5np24jbb6plqbz57z";
  };
  buildInputs = [ pkgconfig curl gpgme ];
}
