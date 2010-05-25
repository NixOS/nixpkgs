{ # Support for the IDEA cipher (used by the old PGP) should only be
  # enabled if it is legal for you to do so.
  ideaSupport ? false

, stdenv, fetchurl, readline, bzip2
}:

let

  idea = fetchurl {
    url = http://nixos.org/tarballs/idea.c.gz;
    md5 = "9dc3bc086824a8c7a331f35e09a3e57f";
  };

in

stdenv.mkDerivation rec {
  name = "gnupg-1.4.10";

  src = fetchurl {
    url = "mirror://gnupg/gnupg/${name}.tar.bz2";
    sha256 = "0f5v8c8fkxcnrlmnijaq2sqfqq6xhmbyi2p44pj98y6n6927z452";
  };

  buildInputs = [ readline bzip2 ];

  preConfigure = stdenv.lib.optionalString ideaSupport
    ''
      gunzip < ${idea} > ./cipher/idea.c
    '';
  
  meta = {
    description = "A free implementation of the OpenPGP standard for encrypting and signing data";
    homepage = http://www.gnupg.org/;
  };
}
