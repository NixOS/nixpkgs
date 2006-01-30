{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "dovecot-1.0.alpha2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/dovecot-1.0.alpha2.tar.gz;
    md5 = "ea33ac1bf13a8252d880082ef6811081" ;
  };
  
}
