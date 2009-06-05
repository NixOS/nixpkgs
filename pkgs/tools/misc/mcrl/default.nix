{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "mcrl-2.18.4";
  src = fetchurl {
    url = http://homepages.cwi.nl/~mcrl/mcrl-2.18.4.tar.gz ;
    sha256 = "0gld7x3cv3y0vwjr1snz24xzr818sj1l2dfn8qhirfyhc7dnnqfw";
  };

  RMPROG = "${coreutils}/bin/rm -f";
}



