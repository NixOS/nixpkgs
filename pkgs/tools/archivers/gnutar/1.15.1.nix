{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnutar-1.15.1";
  src = fetchurl {
    url = http://nixos.org/tarballs/tar-1.15.1.tar.bz2;
    md5 = "57da3c38f8e06589699548a34d5a5d07";
  };
}
